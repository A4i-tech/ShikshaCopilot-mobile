import 'dart:convert';

/// Parses a JSON string into a [MeModel] object.
MeModel meModelFromJson(String str) => MeModel.fromJson(json.decode(str));

/// Converts a [MeModel] object to a JSON string.
String meModelToJson(MeModel data) => json.encode(data.toJson());

/// Represents the model for the current user's data.
class MeModel {
  /// Constructs a [MeModel].
  MeModel({this.success, this.data, this.message});

  /// Factory constructor to create a [MeModel] from JSON.
  factory MeModel.fromJson(Map<String, dynamic> json) => MeModel(
    success: json['success'],
    data: json['data'] == null ? null : Data.fromJson(json['data']),
    message: json['message'],
  );

  /// Indicates if the API call was successful.
  final bool? success;

  /// The user data.
  final Data? data;

  /// A message from the API.
  final String? message;

  /// Creates a copy of this [MeModel] with optional new values.
  MeModel copyWith({bool? success, Data? data, String? message}) => MeModel(
    success: success ?? this.success,
    data: data ?? this.data,
    message: message ?? this.message,
  );

  /// Converts this [MeModel] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'success': success,
    'data': data?.toJson(),
    'message': message,
  };
}

/// Represents the user's data.
class Data {
  /// Constructs a [Data] object.
  Data({
    this.id,
    this.name,
    this.state,
    this.block,
    this.phone,
    this.role,
    this.school,
    this.preferredLanguage,
    this.facilities,
    this.isProfileCompleted,
    this.profileImage,
    this.profileImageExpiresIn,
    this.isDeleted,
    this.rememberMeToken,
    this.isLoginAllowed,
    this.classes,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  /// Factory constructor to create a [Data] object from JSON.
  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json['_id'],
    name: json['name'],
    state: json['state'],
    block: json['block'],
    phone: json['phone'],
    role: json['role'] == null
        ? <String>[]
        : List<String>.from(json['role']!.map((x) => x)),
    school: json['school'] == null ? null : School.fromJson(json['school']),
    preferredLanguage: json['preferredLanguage'],
    facilities: json['facilities'] == null
        ? <Facility>[]
        : List<Facility>.from(
            json['facilities']!.map((x) => Facility.fromJson(x)),
          ),
    isProfileCompleted: json['isProfileCompleted'],
    profileImage: json['profileImage'],
    profileImageExpiresIn: json['profileImageExpiresIn'],
    isDeleted: json['isDeleted'],
    rememberMeToken: json['rememberMeToken'],
    isLoginAllowed: json['isLoginAllowed'],
    classes: json['classes'] == null
        ? <Class>[]
        : List<Class>.from(json['classes']!.map((x) => Class.fromJson(x))),
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt']),
    v: json['__v'],
  );

  /// The unique identifier of the user.
  final String? id;

  /// The name of the user.
  final String? name;

  /// The state of the user.
  final String? state;

  /// The block of the user.
  final String? block;

  /// The phone number of the user.
  final String? phone;

  /// The role(s) of the user.
  final List<String>? role;

  /// The school of the user.
  final School? school;

  /// The preferred language of the user.
  final String? preferredLanguage;

  /// The list of facilities.
  final List<Facility>? facilities;

  /// Indicates if the user's profile is complete.
  final bool? isProfileCompleted;

  /// The URL of the user's profile image.
  final String? profileImage;

  /// The expiration time of the profile image URL.
  final int? profileImageExpiresIn;

  /// Indicates if the user is deleted.
  final bool? isDeleted;

  /// The remember-me token.
  final bool? rememberMeToken;

  /// Indicates if login is allowed for the user.
  final bool? isLoginAllowed;

  /// The list of classes associated with the user.
  final List<Class>? classes;

  /// The creation timestamp.
  final DateTime? createdAt;

  /// The last update timestamp.
  final DateTime? updatedAt;

  /// The version key.
  final int? v;

  /// Creates a copy of this [Data] with optional new values.
  Data copyWith({
    String? id,
    String? name,
    String? state,
    String? block,
    String? phone,
    List<String>? role,
    School? school,
    String? preferredLanguage,
    List<Facility>? facilities,
    bool? isProfileCompleted,
    String? profileImage,
    int? profileImageExpiresIn,
    bool? isDeleted,
    bool? rememberMeToken,
    bool? isLoginAllowed,
    List<Class>? classes,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) => Data(
    id: id ?? this.id,
    name: name ?? this.name,
    state: state ?? this.state,
    block: block ?? this.block,
    phone: phone ?? this.phone,
    role: role ?? this.role,
    school: school ?? this.school,
    preferredLanguage: preferredLanguage ?? this.preferredLanguage,
    facilities: facilities ?? this.facilities,
    isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
    profileImage: profileImage ?? this.profileImage,
    profileImageExpiresIn: profileImageExpiresIn ?? this.profileImageExpiresIn,
    isDeleted: isDeleted ?? this.isDeleted,
    rememberMeToken: rememberMeToken ?? this.rememberMeToken,
    isLoginAllowed: isLoginAllowed ?? this.isLoginAllowed,
    classes: classes ?? this.classes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
  );

  /// Converts this [Data] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'name': name,
    'state': state,
    'block': block,
    'phone': phone,
    'role': role == null
        ? <dynamic>[]
        : List<dynamic>.from(role!.map((String x) => x)),
    'school': school?.toJson(),
    'preferredLanguage': preferredLanguage,
    'facilities': facilities == null
        ? <dynamic>[]
        : List<dynamic>.from(facilities!.map((Facility x) => x.toJson())),
    'isProfileCompleted': isProfileCompleted,
    'profileImage': profileImage,
    'profileImageExpiresIn': profileImageExpiresIn,
    'isDeleted': isDeleted,
    'rememberMeToken': rememberMeToken,
    'isLoginAllowed': isLoginAllowed,
    'classes': classes == null
        ? <dynamic>[]
        : List<dynamic>.from(classes!.map((Class x) => x.toJson())),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': v,
  };
}

/// Represents a class.
class Class {
  /// Constructs a [Class].
  Class({
    this.board,
    this.classClass,
    this.medium,
    this.subject,
    this.name,
    this.sem,
    this.id,
  });

  /// Factory constructor to create a [Class] from JSON.
  factory Class.fromJson(Map<String, dynamic> json) => Class(
    board: json['board'],
    classClass: json['class'],
    medium: json['medium'],
    subject: json['subject'],
    name: json['name'],
    sem: json['sem'],
    id: json['_id'],
  );

  /// The board of education.
  final String? board;

  /// The class/grade level.
  final int? classClass;

  /// The medium of instruction.
  final String? medium;

  /// The subject.
  final String? subject;

  /// The name of the class.
  final String? name;

  /// The semester.
  final int? sem;

  /// The unique identifier.
  final String? id;

  /// Creates a copy of this [Class] with optional new values.
  Class copyWith({
    String? board,
    int? classClass,
    String? medium,
    String? subject,
    String? name,
    int? sem,
    String? id,
  }) => Class(
    board: board ?? this.board,
    classClass: classClass ?? this.classClass,
    medium: medium ?? this.medium,
    subject: subject ?? this.subject,
    name: name ?? this.name,
    sem: sem ?? this.sem,
    id: id ?? this.id,
  );

  /// Converts this [Class] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'board': board,
    'class': classClass,
    'medium': medium,
    'subject': subject,
    'name': name,
    'sem': sem,
    '_id': id,
  };
}

/// Represents a facility.
class Facility {
  /// Constructs a [Facility].
  Facility({
    this.type,
    this.details,
    this.otherType,
    this.typeChipSet,
    this.detailsChipSet,
  });

  /// Factory constructor to create a [Facility] from JSON.
  factory Facility.fromJson(Map<String, dynamic> json) => Facility(
    type: json['type'],
    details: json['details'] == null
        ? <String>[]
        : List<String>.from(json['details']!.map((x) => x)),
    otherType: json['otherType'],
    typeChipSet: json['typeChipSet'],
    detailsChipSet: json['detailsChipSet'],
  );

  /// The type of facility.
  final String? type;

  /// The details of the facility.
  final List<String>? details;

  /// The other type of facility.
  final String? otherType;

  /// Whether the facility type is a chip set.
  final bool? typeChipSet;

  /// Whether the facility details are a chip set.
  final bool? detailsChipSet;

  /// Creates a copy of this [Facility] with optional new values.
  Facility copyWith({
    String? type,
    List<String>? details,
    String? otherType,
    bool? typeChipSet,
    bool? detailsChipSet,
  }) => Facility(
    type: type ?? this.type,
    details: details ?? this.details,
    otherType: otherType ?? this.otherType,
    typeChipSet: typeChipSet ?? this.typeChipSet,
    detailsChipSet: detailsChipSet ?? this.detailsChipSet,
  );

  /// Converts this [Facility] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'type': type,
    'details': details == null
        ? <dynamic>[]
        : List<dynamic>.from(details!.map((String x) => x)),
    'otherType': otherType,
    'typeChipSet': typeChipSet,
    'detailsChipSet': detailsChipSet,
  };
}

/// Represents a school.
class School {
  /// Constructs a [School].
  School({this.id, this.name});

  /// Factory constructor to create a [School] from JSON.
  factory School.fromJson(Map<String, dynamic> json) =>
      School(id: json['_id'], name: json['name']);

  /// The unique identifier of the school.
  final String? id;

  /// The name of the school.
  final String? name;

  /// Creates a copy of this [School] with optional new values.
  School copyWith({String? id, String? name}) =>
      School(id: id ?? this.id, name: name ?? this.name);

  /// Converts this [School] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{'_id': id, 'name': name};
}
