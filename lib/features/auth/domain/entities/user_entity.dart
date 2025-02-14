class UserEntity {
  final String id;
  final String phone;
  final String name;
  final String? photoUrl;
  final bool isApproved; // NEW: Admin approval status

  UserEntity({
    required this.id,
    required this.phone,
    required this.name,
    this.photoUrl,
    required this.isApproved,
  });
}
