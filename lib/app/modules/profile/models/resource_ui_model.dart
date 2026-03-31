import 'package:get/get.dart';

/// A UI model for representing a resource.
class ResourceUIModel {
  /// Constructs a [ResourceUIModel].
  ResourceUIModel({
    String? type,
    List<String>? detail,
    String? otherType,
    bool? typeChipSet,
    bool? detailsChipSet,
  }) {
    this.type.value = type;
    if (detail != null) {
      this.detail.assignAll(detail);
    }
    this.otherType.value = otherType;
    this.typeChipSet.value = typeChipSet;
    this.detailsChipSet.value = detailsChipSet;
  }

  /// The type of the resource.
  final RxnString type = RxnString();

  /// The details of the resource.
  final RxList<String> detail = <String>[].obs;

  /// The other type of the resource.
  final RxnString otherType = RxnString();

  /// Whether the resource type is a chip set.
  final RxnBool typeChipSet = RxnBool();

  /// Whether the resource details are a chip set.
  final RxnBool detailsChipSet = RxnBool();
}
