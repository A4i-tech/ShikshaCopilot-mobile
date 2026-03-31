import '../../../utils/exports.dart';

/// Parses a JSON string into a [ProfileModel] object.
ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

/// Converts a [ProfileModel] object to a JSON string.
String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

/// Represents the profile model for a user.
class ProfileModel {
  /// Constructs a [ProfileModel].
  ProfileModel({this.success, this.data, this.message});

  /// Factory constructor to create a [ProfileModel] from JSON.
  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    success: json['success'],
    data: json['data'] == null ? null : User.fromJson(json['data']),
    message: json['message'],
  );

  /// Indicates if the API call was successful.
  final bool? success;

  /// The user data.
  final User? data;

  /// A message from the API.
  final String? message;

  /// Creates a copy of this [ProfileModel] with optional new values.
  ProfileModel copyWith({bool? success, User? data, String? message}) =>
      ProfileModel(
        success: success ?? this.success,
        data: data ?? this.data,
        message: message ?? this.message,
      );

  /// Converts this [ProfileModel] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'success': success,
    'data': data?.toJson(),
    'message': message,
  };
}

/// Represents a user's profile information.
class User {
  /// Constructs a [User].
  User({
    this.id,
    this.name,
    this.state,
    this.zone,
    this.district,
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
    this.otp,
  });

  /// Factory constructor to create a [User] from JSON.
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['_id'],
    name: json['name'],
    state: json['state'],
    zone: json['zone'],
    district: json['district'],
    block: json['block'],
    phone: json['phone'],
    role: json['role'] == null
        ? <String>[]
        : List<String>.from(json['role']!.map((x) => x)),
    school: json['school'] == null
        ? null
        : json['school'] is String
        ? School(id: json['school'])
        : School.fromJson(json['school']),
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
        ? <ClassDetail>[]
        : List<ClassDetail>.from(
            json['classes']!.map((x) => ClassDetail.fromJson(x)),
          ),
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt']),
    v: json['__v'],
    otp: json['otp'],
  );

  /// The unique identifier of the user.
  final String? id;

  /// The name of the user.
  final String? name;

  /// The state of the user.
  final String? state;

  /// The zone of the user.
  final String? zone;

  /// The district of the user.
  final String? district;

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
  String? profileImage;

  /// The expiration time of the profile image URL.
  final int? profileImageExpiresIn;

  /// Indicates if the user is deleted.
  final bool? isDeleted;

  /// The remember-me token.
  final bool? rememberMeToken;

  /// Indicates if login is allowed for the user.
  final bool? isLoginAllowed;

  /// The list of class details associated with the user.
  List<ClassDetail>? classes;

  /// The creation timestamp.
  final DateTime? createdAt;

  /// The last update timestamp.
  final DateTime? updatedAt;

  /// The version key.
  final int? v;

  /// The one-time password.
  final String? otp;

  /// Creates a copy of this [User] with optional new values.
  User copyWith({
    String? id,
    String? name,
    String? state,
    String? zone,
    String? district,
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
    List<ClassDetail>? classes,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    String? otp,
  }) => User(
    id: id ?? this.id,
    name: name ?? this.name,
    state: state ?? this.state,
    zone: zone ?? this.zone,
    district: district ?? this.district,
    block: block ?? this.block,
    phone: phone ?? this.phone,
    role: role ?? this.role,
    school: school ?? this.school,
    preferredLanguage: preferredLanguage ?? this.preferredLanguage,
    facilities: facilities ?? this.facilities,
    isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
    profileImage: profileImage,
    profileImageExpiresIn: profileImageExpiresIn ?? this.profileImageExpiresIn,
    isDeleted: isDeleted ?? this.isDeleted,
    rememberMeToken: rememberMeToken ?? this.rememberMeToken,
    isLoginAllowed: isLoginAllowed ?? this.isLoginAllowed,
    classes: classes ?? this.classes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
    otp: otp ?? this.otp,
  );

  /// Converts this [User] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'name': name,
    'state': state,
    'zone': zone,
    'district': district,
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
        : List<dynamic>.from(classes!.map((ClassDetail x) => x.toJson())),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': v,
    'otp': otp,
  };
}

/// Represents the details of a class.
class ClassDetail {
  /// Constructs a [ClassDetail].
  ClassDetail({
    String? board,
    int? classClass,
    String? subject,
    String? medium,
    List<SubjectDetail>? subjectDetails,
    int? boysStrength,
    int? girlsStrength,
    String? name,
    int? sem,
  }) {
    this.board.value = board;
    this.classClass.value = classClass;
    this.subject.value = subject;
    this.medium.value = medium;
    this.subjectDetails = subjectDetails;
    this.boysStrength.value = boysStrength;
    this.girlsStrength.value = girlsStrength;
    this.name.value = name;
    this.sem.value = sem;
    boysStrengthController.text = boysStrength?.toString() ?? '';
    girlsStrengthController.text = girlsStrength?.toString() ?? '';
  }
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  /// Factory constructor to create a [ClassDetail] from JSON.
  factory ClassDetail.fromJson(Map<String, dynamic> json) => ClassDetail(
    board: json['board'],
    classClass: _parseInt(json['class']),
    subject: json['subject'],
    medium: json['medium'],
    subjectDetails: json['subjectDetails'] == null
        ? <SubjectDetail>[]
        : List<SubjectDetail>.from(
            json['subjectDetails']!.map((x) => SubjectDetail.fromJson(x)),
          ),
    boysStrength: json['boysStrength'],
    girlsStrength: json['girlsStrength'],
    name: json['name'] ?? json['subject'],
    sem: json['sem'],
  );

  /// The board of education.
  final RxnString board = RxnString();

  /// The class/grade level.
  final RxnInt classClass = RxnInt();

  /// The subject.
  final RxnString subject = RxnString();

  /// The medium of instruction.
  final RxnString medium = RxnString();

  /// The details of the subjects.
  List<SubjectDetail>? subjectDetails;

  /// The number of boys in the class.
  final RxnInt boysStrength = RxnInt();

  /// The number of girls in the class.
  final RxnInt girlsStrength = RxnInt();

  /// The name of the class.
  final RxnString name = RxnString();

  /// The semester.
  final RxnInt sem = RxnInt();

  /// Text editing controller for boys strength.
  final TextEditingController boysStrengthController = TextEditingController();

  /// Text editing controller for girls strength.
  final TextEditingController girlsStrengthController = TextEditingController();

  /// Converts this [ClassDetail] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'board': board.value,
    'class': classClass.value,
    'subject': subject.value,
    'medium': medium.value,
    'subjectDetails': subjectDetails == null
        ? <dynamic>[]
        : List<dynamic>.from(
            subjectDetails!.map((SubjectDetail x) => x.toJson()),
          ),
    'boysStrength': boysStrength.value,
    'girlsStrength': girlsStrength.value,
    'name': name.value,
    'sem': sem.value,
  };
}

/// Represents the details of a subject.
class SubjectDetail {
  /// Constructs a [SubjectDetail].
  SubjectDetail({this.subjectName, this.sem});

  /// Factory constructor to create a [SubjectDetail] from JSON.
  factory SubjectDetail.fromJson(Map<String, dynamic> json) =>
      SubjectDetail(subjectName: json['subjectName'], sem: json['sem']);

  /// The name of the subject.
  final String? subjectName;

  /// The semester.
  final int? sem;

  /// Creates a copy of this [SubjectDetail] with optional new values.
  SubjectDetail copyWith({String? subjectName, int? sem}) => SubjectDetail(
    subjectName: subjectName ?? this.subjectName,
    sem: sem ?? this.sem,
  );

  /// Converts this [SubjectDetail] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'subjectName': subjectName,
    'sem': sem,
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
    dynamic otherType,
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
  School({this.id, this.name, this.facilities});

  /// Factory constructor to create a [School] from JSON.
  factory School.fromJson(Map<String, dynamic> json) => School(
    id: json['_id'],
    name: json['name'],
    facilities: json['facilities'] == null
        ? <dynamic>[]
        : List<dynamic>.from(json['facilities']!.map((x) => x)),
  );

  /// The unique identifier of the school.
  final String? id;

  /// The name of the school.
  final String? name;

  /// The list of facilities in the school.
  final List<dynamic>? facilities;

  /// Creates a copy of this [School] with optional new values.
  School copyWith({String? id, String? name, List<dynamic>? facilities}) =>
      School(
        id: id ?? this.id,
        name: name ?? this.name,
        facilities: facilities ?? this.facilities,
      );

  /// Converts this [School] object to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'name': name,
    'facilities': facilities == null
        ? <dynamic>[]
        : List<dynamic>.from(facilities!.map((x) => x)),
  };
}
