class Validators {
  //Login Validations
  static String? requiredEmail(value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter Email';
    }
    if (!RegExp(r'^[\w._%+-]+@\w+(?:\.\w{2,3}){1,2}$').hasMatch(value)) {
      return 'Special characters not allowed';
    }
    return null;
  }

  static String? password(value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter Password';
    }
    return null;
  }

  /// <<< To check password valid or not --------- >>>
  static String? passwordValidator(value) {
    String p = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

    RegExp regExp = RegExp(p);
    if (regExp.hasMatch(value)) {
      return "Please enter proper password";
    }
    return null;
  }

  //Common Validations
  static String? email(value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    if (!RegExp(r'^[\w._%+-]+@\w+(?:\.\w{2,3}){1,2}$').hasMatch(value)) {
      return 'Special characters not allowed';
    }
    return null;
  }

  static String? requiredDouble(value, fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please Enter $fieldName';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value) && !RegExp(r'^[0-9]+.[0-9]{1,2}$').hasMatch(value)) {
      return 'Enter Valid $fieldName';
    }
    return null;
  }

  static String? emptyOrDouble(value, fieldName) {
    if (!RegExp(r'^[0-9]*$').hasMatch(value) && !RegExp(r'^[0-9]*.[0-9]{1,2}$').hasMatch(value)) {
      return 'Enter Valid $fieldName';
    }
    return null;
  }

  static String? requiredInt(value, fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please Enter $fieldName';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value) && !RegExp(r'^-[0-9]+$').hasMatch(value)) {
      return 'Enter Valid $fieldName';
    }
    return null;
  }

  static String? emptyOrInt(value, fieldName) {
    if (!RegExp(r'^[0-9]*$').hasMatch(value) && !RegExp(r'^-[0-9]*$').hasMatch(value)) {
      return 'Enter Valid $fieldName';
    }
    return null;
  }

  static String? name(value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please Enter Name';
    }
    // if (RegExp(r'[0-9]+').hasMatch(value)) {
    //   return 'Numbers Not Allowed';
    // }
    // if (!RegExp(r'^[A-Za-z_\s.]+$').hasMatch(value)) {
    //   return 'Special Characters Not Allowed';
    // }
    return null;
  }

  static String? contactNumber(value) {
    if (value == null || value.isEmpty) {
      return 'Enter Contact Number';
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Enter Valid Contact Number';
    }
    return null;
  }

  static String? pinCode(value) {
    if (value == null || value.isEmpty) {
      return 'Enter Pincode';
    }
    if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) {
      return 'Enter Valid Pincode';
    }
    return null;
  }

  static String? sellingPrice(value) {
    if (value == null || value.isEmpty) {
      return 'Enter Selling Price';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Enter Valid Selling Price';
    }
    return null;
  }

  static String? stock(value) {
    if (value == null || value.isEmpty) {
      return 'Enter Stock';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Enter Valid Stock';
    }
    return null;
  }

  static String? address(value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter Address';
    }
    return null;
  }

  static String? canNotBeEmpty(value, {required String message}) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  //Discount Validators
  static String? doubleWithLimit(value, {required double maxLimit, required String fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please Enter $fieldName';
    }
    if (double.parse(value) < 0 || double.parse(value) > maxLimit) {
      return 'Please Enter Valid $fieldName';
    }
    return null;
  }

  // Quantity Limiter
  static String? quantityLimiter(value, {required double maxLimit, required String fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please Enter $fieldName';
    }
    if (double.parse(value) < 0 || double.parse(value) > maxLimit) {
      return '$fieldName can\'t be greater than In Stock';
    }
    return null;
  }

  static String? percentageDiscount(value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please Enter Discount';
    }
    if (double.parse(value) < 0 || double.parse(value) > 100) {
      return 'Please Enter Valid Percentage';
    }
    return null;
  }
}
