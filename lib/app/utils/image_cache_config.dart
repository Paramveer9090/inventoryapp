import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:true_leaf_inventory_app/app/utils/app_constant.dart';

/// Enhanced image caching configuration for better performance
class ImageCacheConfig {
  static final CacheManager _cacheManager = CacheManager(
    Config(
      'inventoryAppImageCache',
      stalePeriod: Duration(days: 30), // Keep images for 30 days
      maxNrOfCacheObjects: 200, // Limit cache to 200 images
      repo: JsonCacheInfoRepository(databaseName: 'inventory_image_cache'),
      fileSystem: IOFileSystem('inventory_images'),
      fileService: HttpFileService(),
    ),
  );

  static CacheManager get cacheManager => _cacheManager;

  /// Clear image cache when needed (for memory management)
  static Future<void> clearCache() async {
    await _cacheManager.emptyCache();
  }

  /// Get cache info for monitoring
  static Stream<FileResponse> getImageStream(String url) {
    return _cacheManager.getFileStream(url);
  }
}

/// Optimized image widget with enhanced caching and error handling
class OptimizedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;

  const OptimizedNetworkImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = CachedNetworkImage(
      imageUrl: _buildFullUrl(imageUrl),
      width: width,
      height: height,
      fit: fit,
      cacheManager: ImageCacheConfig.cacheManager,
      placeholder: (context, url) => _buildPlaceholder(),
      errorWidget: (context, url, error) => _buildErrorWidget(),
      fadeInDuration: Duration(milliseconds: 200),
      fadeOutDuration: Duration(milliseconds: 100),
      memCacheWidth: width != null && width!.isFinite ? width!.toInt() : null,
      memCacheHeight: height != null && height!.isFinite ? height!.toInt() : null,
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  String _buildFullUrl(String url) {
    if (url.startsWith('http')) {
      return url;
    }
    return '${Constants.imageBaseUrl}$url';
  }

  Widget _buildPlaceholder() {
    if (placeholder != null) {
      return Image.asset(
        placeholder!,
        width: width,
        height: height,
        fit: fit,
      );
    }

    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade400),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    if (errorWidget != null) {
      return errorWidget!;
    }

    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 32,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 4),
          Text(
            'No image',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}

/// Pre-load critical images for better performance
class ImagePreloader {
  static final List<String> _criticalImages = [
    'assets/images/logo.png',
    'assets/images/dummy.png',
    'assets/images/dashboard.png',
  ];

  static Future<void> preloadCriticalImages(BuildContext context) async {
    for (String imagePath in _criticalImages) {
      try {
        await precacheImage(AssetImage(imagePath), context);
      } catch (e) {
        // Handle preload errors silently
      }
    }
  }

  static Future<void> preloadNetworkImages(
    BuildContext context,
    List<String> imageUrls,
  ) async {
    for (String url in imageUrls.take(5)) {
      // Limit to first 5 images
      try {
        await precacheImage(
          CachedNetworkImageProvider(
            url.startsWith('http') ? url : '${Constants.imageBaseUrl}$url',
            cacheManager: ImageCacheConfig.cacheManager,
          ),
          context,
        );
      } catch (e) {
        // Handle preload errors silently
      }
    }
  }
}