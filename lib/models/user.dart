///The PODO class that describes one user in chat system
/// This class contains user name and his phone number
class User {
  final String name;
  final String phoneNumber;

  ///List of chats hash where user participate
  final List<int> chatsHash;

  //Default constructor for user
  User(this.name, this.phoneNumber) : this.chatsHash = [];

  //Restore user from JSON object
  User.fromJson(Map<String, dynamic> data)
      : name = data['userName'],
        chatsHash = [],
        phoneNumber = data['userPhone'] {
    data['chatsHash'].forEach((hash) => chatsHash.add(hash as int));
  }

  //Convert user to JSON object
  Map<String, dynamic> toJson() => {
        'userName': name,
        'userPhone': phoneNumber,
        'chatsHash': chatsHash,
      };

  @override
  int get hashCode => (name.hashCode + phoneNumber.hashCode * 3 / 2).toInt();
}
