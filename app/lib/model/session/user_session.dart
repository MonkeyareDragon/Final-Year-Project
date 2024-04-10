class UserSession {
  final int userId;
  final String accessToken;
  final String firstName;
  final String lastName;

  UserSession({
    required this.userId,
    required this.accessToken,
    required this.firstName,
    required this.lastName,
  });

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      userId: json['userId'],
      accessToken: json['accessToken'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'accessToken': accessToken,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
