class LoginAndSignUpResponseModel {
  final String? accessToken;
  final String? message;
  final List<LoginSignUpData>? data;
  final Errors? errors;

  LoginAndSignUpResponseModel({
    this.accessToken,
    this.data,
    this.message,
    this.errors,
  });

  LoginAndSignUpResponseModel.fromJson(Map<String, dynamic> json)
      : accessToken = json['access_token'] as String?,
        message = json['message'] as String?,
        errors = (json['errors'] as Map<String, dynamic>?) != null ? Errors.fromJson(json['errors'] as Map<String, dynamic>) : null,
        data = (json['data'] as List?)?.map((dynamic e) => LoginSignUpData.fromJson(e as Map<String, dynamic>)).toList();

  Map<String, dynamic> toJson() => {
        'message': message,
        'access_token': accessToken,
        'errors': errors?.toJson(),
        'data': data?.map((e) => e.toJson()).toList(),
      };
}

class Errors {
  final List<String>? password;

  Errors({
    this.password,
  });

  Errors.fromJson(Map<String, dynamic> json) : password = (json['password'] as List?)?.map((dynamic e) => e as String).toList();

  Map<String, dynamic> toJson() => {'password': password};
}

class LoginSignUpData {
  final int? id;
  final String? name;
  final String? email;
  final dynamic emailVerifiedAt;
  final dynamic createdAt;
  final dynamic updatedAt;
  final dynamic deletedAt;
  final List<Roles>? roles;

  LoginSignUpData({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.roles,
  });

  LoginSignUpData.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        email = json['email'] as String?,
        emailVerifiedAt = json['email_verified_at'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'],
        deletedAt = json['deleted_at'],
        roles = (json['roles'] as List?)?.map((dynamic e) => Roles.fromJson(e as Map<String, dynamic>)).toList();

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email, 'email_verified_at': emailVerifiedAt, 'created_at': createdAt, 'updated_at': updatedAt, 'deleted_at': deletedAt, 'roles': roles?.map((e) => e.toJson()).toList()};
}

class Roles {
  final int? id;
  final String? title;
  final dynamic createdAt;
  final dynamic updatedAt;
  final dynamic deletedAt;
  final Pivot? pivot;
  final List<Permissions>? permissions;

  Roles({
    this.id,
    this.title,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.pivot,
    this.permissions,
  });

  Roles.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        title = json['title'] as String?,
        createdAt = json['created_at'],
        updatedAt = json['updated_at'],
        deletedAt = json['deleted_at'],
        pivot = (json['pivot'] as Map<String, dynamic>?) != null ? Pivot.fromJson(json['pivot'] as Map<String, dynamic>) : null,
        permissions = (json['permissions'] as List?)?.map((dynamic e) => Permissions.fromJson(e as Map<String, dynamic>)).toList();

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'created_at': createdAt, 'updated_at': updatedAt, 'deleted_at': deletedAt, 'pivot': pivot?.toJson(), 'permissions': permissions?.map((e) => e.toJson()).toList()};
}

class Pivot {
  final int? userId;
  final int? roleId;

  Pivot({
    this.userId,
    this.roleId,
  });

  Pivot.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'] as int?,
        roleId = json['role_id'] as int?;

  Map<String, dynamic> toJson() => {'user_id': userId, 'role_id': roleId};
}

class Permissions {
  final int? id;
  final String? title;
  final dynamic createdAt;
  final dynamic updatedAt;
  final dynamic deletedAt;
  final String? name;
  final Pivot? pivot;

  Permissions({
    this.id,
    this.title,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.deletedAt,
    this.pivot,
  });

  Permissions.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        title = json['title'] as String?,
        name = json['name'] as String?,
        createdAt = json['created_at'],
        updatedAt = json['updated_at'],
        deletedAt = json['deleted_at'],
        pivot = (json['pivot'] as Map<String, dynamic>?) != null ? Pivot.fromJson(json['pivot'] as Map<String, dynamic>) : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'deleted_at': deletedAt,
        'name': name,
        'pivot': pivot?.toJson(),
      };
}
