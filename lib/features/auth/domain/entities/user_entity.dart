class UserEntity {
  final String id;
  final String phone;
  final String name;
  final String? photoUrl;
  final bool isApproved; // Admin approval status
  final bool exists; // Flag to determine if user exists or not

  UserEntity({
    required this.id,
    required this.phone,
    required this.name,
    this.photoUrl,
    required this.isApproved,
    required this.exists, // New property for checking user existence
  });
}
