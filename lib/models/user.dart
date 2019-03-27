///The PODO class that describes one user in chat system
/// This class contains user name and his phone number
class User {
  final String name;
  final String phoneNumber;

  //Default constructor for user
  User(this.name, this.phoneNumber);

  //Restore user from JSON object
  User.fromJson(Map<String, dynamic> data)
      : name = data['userName'],
        phoneNumber = data['userPhone'];

  //Convert user to JSON object
  Map<String, dynamic> toJson() => {
        'userName': name,
        'userPhone': phoneNumber,
      };

  @override
  int get hashCode => (name.hashCode + phoneNumber.hashCode * 3 / 2).toInt();
}
