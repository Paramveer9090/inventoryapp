
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class CustomElevatedButton extends StatefulWidget {
  final String label;
  final Color backgroundColor;
  final Function()? onPressed;

  const CustomElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = AppColors.elevatedButtonColor,
  });

  @override
  State<CustomElevatedButton> createState() => _CustomElevetdButtonState();
}

class _CustomElevetdButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor /*widget.backgroundColor*/),
      child: Text(
        widget.label,
        textAlign: TextAlign.center,
      ),
    );
  }
}
