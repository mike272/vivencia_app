import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';

class data {
  String Data = "nothing";
}

class inputField extends StatelessWidget with ChangeNotifier {
  data dataFromField;
  String get Value {
    return dataFromField.Data;
  }

  final String hint;
  final hideInfo;
  inputField({this.hint, this.hideInfo = false, this.dataFromField});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hint,
            style: TextStyle(color: Colors.black54, fontSize: 13),
          ),
          TextField(
            obscureText: hideInfo,
            textAlign: TextAlign.start,
            onChanged: (newValue) {
              dataFromField.Data = newValue;
              //notifyListeners();
            },
          ),
        ],
      ),
    );
  }
}
