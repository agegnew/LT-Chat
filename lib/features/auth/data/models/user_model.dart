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
    required bool isApproved, // NEW: Approval field
  }) : super(id: id, phone: phone, name: name, photoUrl: photoUrl, isApproved: isApproved);

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
