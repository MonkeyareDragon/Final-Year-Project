class DateHelper {
  static int calculateAge(String dobString) {
    DateTime dob = DateTime.parse(dobString);
    final now = DateTime.now();
    int age = now.year - dob.year;

    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }

    return age;
  }
}