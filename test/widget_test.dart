// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_chat/models/chat.dart';
import 'package:personal_chat/models/message.dart';
import 'package:personal_chat/models/user.dart';

void main() {
  testUserCreatingRestoring();
  testChatCreating();
  testChatRestoring();
}

void testUserCreatingRestoring() {
  print('testUserCreatingRestoring()');
  User user = User('Vasya Pupkin', '+79115923175');
  user.chatsHash.addAll([3958737792, 6958237593]);
  print(user.toJson());
  User newUser = User.fromJson(user.toJson());
  print(newUser.toJson());
  print('------------------------');
}

void testChatRestoring() {
  print('TestChatRestoring()');
  Chat chat = Chat.fromJson(getJsonChat());
  print(chat.toJson());
  print('-----------------------');
}

void testChatCreating() {
  print('TestChatCreating()');
  User user1 = User('Vasya Pupkin', '+79115923175');
  User user2 = User('Petya Sidorov', '+79256231274');

  List<Message> messages = [
    Message(
        messageTime: DateTime.now(),
        context: 'WTF?',
        senderHash: user1.hashCode,
        status: true,
        type: MessageType.Text),
    Message(
        messageTime: DateTime.now(),
        context: "It's ok",
        senderHash: user2.hashCode,
        status: false,
        type: MessageType.Text)
  ];

  Chat chat = Chat(hashPerson1: user1.hashCode, hashPerson2: user2.hashCode);
  chat.messages = messages;
  print(chat.toJson());
  print('------------------------------');
}

Map<String, dynamic> getJsonChat() => {
      'chatHash': 3958737792,
      'hash1': 1407034086,
      'hash2': 572334810,
      'messages': [
        {
          'type': 0,
          'time': '2019-03-27 19:01:45.834067Z',
          'context': 'WTF?',
          'status': true,
          'senderHash': 1407034086
        },
        {
          'type': 0,
          'time': '2019-03-27 19:01:45.834618Z',
          'context': "It's ok",
          'status': false,
          'senderHash': 572334810
        }
      ]
    };
