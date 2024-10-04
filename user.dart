class User {
  final String username;
  int counter;

  User({required this.username, required this.counter});

  // Convert a User object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'counter': counter,
    };
  }

  // Convert a Map object into a User object
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'],
      counter: map['counter'],
    };
  }
}
