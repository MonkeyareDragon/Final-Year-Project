class UserProfile {
  final String avatar;
  final String gender;
  final String dob;
  final double weight;
  final double height;
  final String goal;
  final User user;

  UserProfile({
    required this.avatar,
    required this.gender,
    required this.dob,
    required this.weight,
    required this.height,
    required this.goal,
    required this.user,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      avatar: json['avatar'],
      gender: json['gender'],
      dob: json['dob'],
      weight: json['weight'].toDouble(),
      height: json['height'].toDouble(),
      goal: json['goal'],
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'avatar': avatar,
      'gender': gender,
      'dob': dob,
      'weight': weight,
      'height': height,
      'goal': goal,
      'user': user.toJson(),
    };
  }
}

class User {
  final String username;
  final String firstName;
  final String lastName;

  User({
    required this.username,
    required this.firstName,
    required this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
    };
  }
}