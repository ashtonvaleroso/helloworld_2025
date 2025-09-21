class User {
  String name;
  int workingHoursStart;
  int workingHoursEnd;

  User({
    required this.name,
    this.workingHoursStart = 9,
    this.workingHoursEnd = 17,
  });

  static User get defaultUser => User(
        name: "Default User",
        workingHoursStart: 9,
        workingHoursEnd: 17,
      );
}
