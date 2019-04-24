import 'package:personal_chat/models/message.dart';

///The PODO class that describes one chat between two users
class Chat {
  /// The list of messages in chat
  /// All items in list stores in backward order
  List<Message> _messages;

  List<Message> get messages => _messages;

  /// Add message to start of list
  void addMessage(Message newMessage) {
    messages.insert(0, newMessage);
  }

  //The hash code of chat, it needs to identify that
  final int chatHash;

  //The hash code of interlocutors
  final int hashPerson1;
  final int hashPerson2;

  final String person1Phone;
  final String person2Phone;

  //Default constructor
  Chat(
      {this.hashPerson1,
      this.hashPerson2,
      this.person1Phone,
      this.person2Phone})
      : this.chatHash = (hashPerson1 + hashPerson2) * 2,
        _messages = [];

  //Constructor to restore chat from JSON object
  Chat.fromJson(Map<String, dynamic> data)
      : this.chatHash = data['chatHash'],
        this.hashPerson1 = data['hash1'],
        this.hashPerson2 = data['hash2'],
        this.person1Phone = data['pers1Phone'],
        this.person2Phone = data['pers2Phone'] {
    _messages = [];
    data['messages']
        .forEach((message) => _messages.add(Message.fromJson(message)));
  }

  /// Convert chat to JSON object
  /// Save just last 30 messages to reduce needed memory
  Map<String, dynamic> toJson() {
    var msg = _messages.length > 29 ? _messages.getRange(0, 30) : _messages;
    return {
      'chatHash': this.chatHash,
      'hash1': this.hashPerson1,
      'hash2': this.hashPerson2,
      'pers1Phone': this.person1Phone,
      'pers2Phone': this.person2Phone,
      'messages': msg.map((message) => message.toJson()).toList(),
    };
  }
}
