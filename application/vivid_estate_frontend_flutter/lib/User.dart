class User {
  const User(
      {required this.Name,
      required this.Email,
      required this.Username,
      required this.Password,
      required this.Type});
  final String Name;
  final String Email;
  final String Username;
  final String Password;
  final String Type;
}

class CNIC {
  const CNIC(
      {required this.cnic_number,
      required this.cnic_father_name,
      required this.cnic_name,
      required this.cnic_dob});
  final String cnic_number;
  final String cnic_father_name;
  final String cnic_name;
  final String cnic_dob;
}
