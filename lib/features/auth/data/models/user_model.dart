import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends UserEntity {
  UserModel({
    required String id,
    required String phone,
    required String name,
    String? photoUrl,
    required bool isApproved,
    required bool exists,
  }) : super(
    id: id,
    phone: phone,
    name: name,
    photoUrl: photoUrl,
    isApproved: isApproved,
    exists: exists,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? "",
      phone: json['phone'] ?? "",
      name: json['name'] ?? "",
      photoUrl: json['photoUrl'] ?? "",
      isApproved: json['isApproved'] ?? false,
      exists: json['exists'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
