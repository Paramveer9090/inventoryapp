import 'package:true_leaf_inventory_app/app/models/get_all_data_model.dart';

class GetDetailsResponseModel {
  final GetDetailsData? data;

  GetDetailsResponseModel({
    this.data,
  });

  GetDetailsResponseModel.fromJson(Map<String, dynamic> json) : data = (json['data'] as Map<String, dynamic>?) != null ? GetDetailsData.fromJson(json['data'] as Map<String, dynamic>) : null;

  Map<String, dynamic> toJson() => {'data': data?.toJson()};
}

class GetDetailsData {
  final int? id;
  final String? name;
  final dynamic categoryOrder;
  final dynamic categoryId;
  final dynamic subCategoryId;
  final String? createdAt;
  final String? updatedAt;
  String? categoryType;
  String? subCategoryType;
  String? taxType;
  final dynamic deletedAt;
  final String? status;
  final dynamic number;
  final String? date;
  final String? description;
  final dynamic productId;
  final dynamic addedById;
  final String? title;
  final dynamic tax;
  final String? supplierName;
  final String? supplierNumber;
  final dynamic supplierEmail;
  final String? companyName;
  final String? contactName;
  final String? address;
  final String? pincode;
  final String? phoneNumber;
  final String? email;
  final String? paymentTerms;
  final dynamic sellingPrice;
  final dynamic stock;
  final dynamic maximumSellingPrice;
  final dynamic boxSize;
  final dynamic taxId;
  final String? imageUrl;
  final dynamic productImage;
  final List<dynamic>? media;
  final dynamic discountType;
  final dynamic discount;
  final dynamic finalPrice;
  final int? supplierId;
  final dynamic daysPayableOutstanding;
  final String? invoiceNumber;
  final String? dueDate;
  final dynamic expenseTotal;
  final dynamic expenseTax;
  final List<OrderItem>? orderItem;
  final dynamic poFile;
  final Supplier? supplier;
  final dynamic invoiceId;
  final dynamic paymentId;
  final dynamic amount;
  final dynamic expenseId;
  final String? orderId;
  final dynamic orderTotal;
  final String? comments;
  final String? deliveryNote;
  final String? customerSign;

  final dynamic salesManagerId;
  final dynamic customerId;
  final dynamic extraDiscount;
  final dynamic deliveryAgentId;
  final dynamic orderTotalWithoutTax;
  final dynamic orderTax;
  final String? orderDate;
  final dynamic deliveryPic;
  final SalesManager? salesManager;
  final Customer? customer;

  GetDetailsData({
    this.id,
    this.name,
    this.status,
    this.categoryOrder,
    this.categoryId,
    this.createdAt,
    this.categoryType,
    this.updatedAt,
    this.deletedAt,
    this.number,
    this.date,
    this.subCategoryId,
    this.description,
    this.productId,
    this.addedById,
    this.title,
    this.taxType,
    this.orderId,
    this.tax,
    this.supplierName,
    this.supplierNumber,
    this.supplierEmail,
    this.companyName,
    this.subCategoryType,
    this.contactName,
    this.address,
    this.pincode,
    this.phoneNumber,
    this.email,
    this.paymentTerms,
    this.sellingPrice,
    this.stock,
    this.maximumSellingPrice,
    this.boxSize,
    this.taxId,
    this.productImage,
    this.media,
    this.imageUrl,
    this.discountType,
    this.discount,
    this.finalPrice,
    this.supplierId,
    this.daysPayableOutstanding,
    this.invoiceNumber,
    this.dueDate,
    this.expenseTotal,
    this.expenseTax,
    this.orderItem,
    this.poFile,
    this.supplier,
    this.invoiceId,
    this.paymentId,
    this.amount,
    this.expenseId,
    this.orderTotal,
    this.comments,
    this.deliveryNote,
    this.customerSign,
    this.salesManagerId,
    this.customerId,
    this.extraDiscount,
    this.deliveryAgentId,
    this.orderTotalWithoutTax,
    this.orderTax,
    this.orderDate,
    this.deliveryPic,
    this.salesManager,
    this.customer,
  });

  GetDetailsData.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        categoryOrder = json['category_order'],
        categoryId = json['category_id'] as dynamic,
        subCategoryId = json['sub_category_id'] as dynamic,
        createdAt = json['created_at'] as String?,
        status = json['status'] as String?,
        categoryType = json['categoryType'] ?? "",
        taxType = json['taxType'] ?? "",
        orderId = json['order_id'] as String?,
        subCategoryType = json['subCategoryType'] ?? "",
        updatedAt = json['updated_at'] as String?,
        deletedAt = json['deleted_at'],
        number = json['number'],
        date = json['date'] as String?,
        description = json['description'] as String?,
        productId = json['product_id'],
        addedById = json['added_by_id'],
        title = json['title'] as String?,
        tax = json['tax'],
        supplierName = json['supplier_name'] as String?,
        supplierNumber = json['supplier_number'] as String?,
        supplierEmail = json['supplier_email'],
        companyName = json['company_name'] as String?,
        contactName = json['contact_name'] as String?,
        address = json['address'] as String?,
        pincode = json['pincode'] as String?,
        phoneNumber = json['phone_number'] as String?,
        email = json['email'] as String?,
        paymentTerms = json['payment_terms'] as String?,
        sellingPrice = json['selling_price'],
        stock = json['stock'],
        maximumSellingPrice = json['maximum_selling_price'],
        boxSize = json['box_size'],
        taxId = json['tax_id'],
        productImage = json['product_image'],
        media = json['media'] as List?,
        discountType = json['discount_type'],
        discount = json['discount'],
        finalPrice = json['final_price'],
        supplierId = json['supplier_id'] as int?,
        daysPayableOutstanding = json['days_payable_outstanding'],
        imageUrl = json['image_url'] as String?,
        invoiceNumber = json['invoice_number'] as String?,
        dueDate = json['due_date'] as String?,
        expenseTotal = json['expense_total'],
        expenseTax = json['expense_tax'],
        invoiceId = json['invoice_id'],
        paymentId = json['payment_id'],
        amount = json['amount'],
        expenseId = json['expense_id'],
        orderItem = (json['order_item'] as List?)?.map((dynamic e) => OrderItem.fromJson(e as Map<String, dynamic>)).toList(),
        poFile = json['po_file'],
        orderTotal = json['order_total'],
        comments = json['comments'] as String?,
        deliveryNote = json['delivery_note'] as String?,
        customerSign = json['customer_sign'] as String?,
        salesManagerId = json['sales_manager_id'],
        customerId = json['customer_id'],
        extraDiscount = json['extra_discount'],
        deliveryAgentId = json['delivery_agent_id'],
        orderTotalWithoutTax = json['order_total_without_tax'],
        orderTax = json['order_tax'],
        orderDate = json['order_date'] as String?,
        deliveryPic = json['delivery_pic'],
        salesManager = (json['sales_manager'] as Map<String, dynamic>?) != null ? SalesManager.fromJson(json['sales_manager'] as Map<String, dynamic>) : null,
        customer = (json['customer'] as Map<String, dynamic>?) != null ? Customer.fromJson(json['customer'] as Map<String, dynamic>) : null,
        supplier = (json['supplier'] as Map<String, dynamic>?) != null ? Supplier.fromJson(json['supplier'] as Map<String, dynamic>) : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'status': status,
        'category_order': categoryOrder,
        'category_id': categoryId,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'categoryType': categoryType,
        'deleted_at': deletedAt,
        'sub_category_id': subCategoryId,
        'number': number,
        'date': date,
        'description': description,
        'taxType': taxType,
        'product_id': productId,
        'added_by_id': addedById,
        'subCategoryType': subCategoryType,
        'title': title,
        'order_id': orderId,
        'tax': tax,
        'supplier_name': supplierName,
        'supplier_number': supplierNumber,
        'supplier_email': supplierEmail,
        'company_name': companyName,
        'contact_name': contactName,
        'order_total': orderTotal,
        'comments': comments,
        'delivery_note': deliveryNote,
        'customer_sign': customerSign,
        'sales_manager_id': salesManagerId,
        'customer_id': customerId,
        'extra_discount': extraDiscount,
        'delivery_agent_id': deliveryAgentId,
        'order_total_without_tax': orderTotalWithoutTax,
        'order_tax': orderTax,
        'due_date': dueDate,
        'order_date': orderDate,
        'discount_type': discountType,
        'delivery_pic': deliveryPic,
        'order_item': orderItem?.map((e) => e.toJson()).toList(),
        'sales_manager': salesManager?.toJson(),
        'customer': customer?.toJson(),
        'address': address,
        'pincode': pincode,
        'phone_number': phoneNumber,
        'email': email,
        'payment_terms': paymentTerms,
        'selling_price': sellingPrice,
        'stock': stock,
        'maximum_selling_price': maximumSellingPrice,
        'invoice_id': invoiceId,
        'payment_id': paymentId,
        'amount': amount,
        'expense_id': expenseId,
        'box_size': boxSize,
        'tax_id': taxId,
        'product_image': productImage,
        'media': media,
        'image_url': imageUrl,
        'discount': discount,
        'final_price': finalPrice,
        'supplier_id': supplierId,
        'days_payable_outstanding': daysPayableOutstanding,
        'invoice_number': invoiceNumber,
        'expense_total': expenseTotal,
        'expense_tax': expenseTax,
        'po_file': poFile,
        'supplier': supplier?.toJson(),
      };
}

class OrderItem {
  final String? subCategoryName;
  final int? subCategoryId;
  final String? categoryName;
  final int? categoryId;
  final String? name;
  final String? exp_date;
  final int? productId;
  final int? stock;
  final int? isBox;
  final int? purchasePrice;
  final int? taxId;
  final int? boxSize;
  final int? tax;
  final String? title;
  final String? image_url;
  final int? quantity;
  final int? sellingPrice;
  final int? maximumSellingPrice;
  final int? salePrice;

  OrderItem({
    this.subCategoryName,
    this.subCategoryId,
    this.categoryName,
    this.categoryId,
    this.name,
    this.productId,
    this.stock,
    this.isBox,
    this.purchasePrice,
    this.taxId,
    this.boxSize,
    this.tax,
    this.quantity,
    this.sellingPrice,
    this.maximumSellingPrice,
    this.salePrice,
    this.image_url,
    this.exp_date,
    this.title,
  });

  OrderItem.fromJson(Map<String, dynamic> json)
      : subCategoryName = json['sub_category_name'] as String?,
        subCategoryId = json['sub_category_id'] as int?,
        categoryName = json['category_name'] as String?,
        categoryId = json['category_id'] as int?,
        name = json['name'] as String?,
        exp_date = json['exp_date'] as String?,
        image_url = json['image_url'] as String?,
        productId = json['product_id'] as int?,
        stock = json['stock'] as int?,
        isBox = json['is_box'] as int?,
        purchasePrice = json['purchase_price'] as int?,
        taxId = json['tax_id'] as int?,
        boxSize = json['box_size'] as int?,
        tax = json['tax'] as int?,
        quantity = json['quantity'] as int?,
        sellingPrice = json['selling_price'] as int?,
        maximumSellingPrice = json['maximum_selling_price'] as int?,
        salePrice = json['sale_price'] as int?,
        title = json['title'] as String?;

  Map<String, dynamic> toJson() => {
        'sub_category_name': subCategoryName,
        'sub_category_id': subCategoryId,
        'category_name': categoryName,
        'category_id': categoryId,
        'quantity': quantity,
        'stock': stock,
        'selling_price': sellingPrice,
        'name': name,
        'maximum_selling_price': maximumSellingPrice,
        'is_box': isBox,
        'sale_price': salePrice,
        'tax_id': taxId,
        'exp_date': exp_date,
        'product_id': productId,
        'purchase_price': purchasePrice,
        'box_size': boxSize,
        'tax': tax,
        'image_url': image_url,
        'title': title
      };
}
