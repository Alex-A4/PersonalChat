///The PODO class that describes one message into the chat
class Message {
  ///The time of message when it was send
  /// All time storing in UTC, but when it shows to user, it converts to local
  final DateTime messageTime;

  /// The context of message, it could be text, image url, audio file url, sticker
  final String context;

  ///The status of message: true - read, false - not read
  final bool isRead;

  ///The hash code of person who send this message
  final int senderHash;

  //The type of message
  MessageType type;

  //Default constructor
  Message(
      {this.messageTime,
      this.context,
      this.isRead,
      this.senderHash,
      this.type});

  //Constructor to create object from JSON data
  Message.fromJson(Map<String, dynamic> data)
      : this.messageTime =
            DateTime.fromMicrosecondsSinceEpoch(data['time'], isUtc: true),
        this.context = data['context'],
        this.isRead = data['isRead'],
        this.senderHash = data['senderHash'] {
    switch (data['type'].toInt()) {
      case 0:
        this.type = MessageType.Text;
        break;
      case 1:
        this.type = MessageType.Sticker;
        break;
      case 2:
        this.type = MessageType.Audio;
        break;
      case 3:
        this.type = MessageType.Photo;
        break;
      default:
        this.type = MessageType.Text;
        break;
    }
  }

  //Method to convert Message object to JSON
  Map<String, dynamic> toJson() => {
        'type': this.type.index,
        'time': this.messageTime.toUtc().millisecondsSinceEpoch,
        'context': this.context,
        'isRead': this.isRead,
        'senderHash': this.senderHash,
      };
}

///Enum that describes type of message
enum MessageType {
  Text,
  Sticker,
  Audio,
  Photo,
}
