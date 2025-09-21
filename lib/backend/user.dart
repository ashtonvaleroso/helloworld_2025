class User {
  String name;
  String email;
  final (int, int) workingHours; // (startHour, endHour)

  User({
    required this.name,
    required this.email,
    this.workingHours = (9, 17),
  });
}
