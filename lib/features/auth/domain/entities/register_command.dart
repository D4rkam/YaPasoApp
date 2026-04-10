class RegisterCommand {
  final String username;
  final String name;
  final String lastName;
  final String password;
  final String email;
  final String fileNum;
  final int age;
  final int? schoolId;

  const RegisterCommand({
    required this.username,
    required this.name,
    required this.lastName,
    required this.password,
    required this.email,
    required this.fileNum,
    required this.age,
    required this.schoolId,
  });
}
