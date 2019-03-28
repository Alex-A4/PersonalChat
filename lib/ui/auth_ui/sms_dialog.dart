import 'package:flutter/material.dart';
import '../../repositories/user_repository.dart';

class SmsVerifyDialog extends StatefulWidget {
  ConfirmSmsFunc smsFunc;

  SmsVerifyDialog({Key key, @required this.smsFunc}) : super(key: key);

  @override
  _SmsVerifyDialogState createState() => _SmsVerifyDialogState();
}

class _SmsVerifyDialogState extends State<SmsVerifyDialog> {
  TextEditingController _smsController = TextEditingController();

  @override
  void dispose() {
    _smsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Введите SMS код'),
      content: TextField(
        controller: _smsController,
        decoration: InputDecoration(hintText: '123456'),
        maxLength: 6,
        keyboardType: TextInputType.number,
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 16.0),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            widget.smsFunc(_smsController.text);
            Navigator.of(context).pop();
          },
          child: Text('Подтвердить'),
        ),
      ],
    );
  }
}
