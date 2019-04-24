import 'package:personal_chat/models/message.dart';

///The PODO class that describes one chat between two users
class Chat {
  //The list of messages in chat
  List<Message> messages;

  //The hash code of chat, it needs to identify that
  final int chatHash;

  //The hash code of interlocutors
  final int hashPerson1;
  final int hashPerson2;

  //Default constructor
  Chat({this.hashPerson1, this.hashPerson2})
      : this.chatHash = (hashPerson1 + hashPerson2) * 2,
        messages = [];

  //Constructor to restore chat from JSON object
  Chat.fromJson(Map<String, dynamic> data)
      : this.chatHash = data['chatHash'],
        this.hashPerson1 = data['hash1'],
        this.hashPerson2 = data['hash2'] {
    messages = [];
    data['messages']
        .forEach((message) => messages.add(Message.fromJson(message)));
  }

  /// Convert chat to JSON object
  /// Save just last 20 messages to reduce needed memory
  Map<String, dynamic> toJson() {
    var msg = messages.length > 19 ? messages.getRange(0, 20) : messages;
    return {
      'chatHash': this.chatHash,
      'hash1': this.hashPerson1,
      'hash2': this.hashPerson2,
      'messages': msg.map((message) => message.toJson()).toList(),
    };
  }
}
