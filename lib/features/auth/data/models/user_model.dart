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
  }) : super(id: id, phone: phone, name: name, photoUrl: photoUrl, isApproved: isApproved);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? "",               // Default to empty string if null
      phone: json['phone'] ?? "",         // Default to empty string
      name: json['name'] ?? "",           // Default to empty string
      photoUrl: json['photoUrl'] ?? "",   // Default to empty string
      isApproved: json['isApproved'] ?? false,  // Default to false if null
    );
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
