import 'package:flutter/material.dart';

class SquareButton extends StatelessWidget {
  const SquareButton({this.buttonText, this.function, this.smallText});
  final buttonText;
  final Function function;
  final smallText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  smallText,
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),
                color: Colors.transparent,
                height: 63,
              )),
          Expanded(
            flex: 3,
            child: MaterialButton(
              //color: Colors.deepPurpleAccent,
              onPressed: function,
              //Go to login screen.
              // ,
              minWidth: 200.0,
              height: 63.0,
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                //borderRadius: BorderRadius.circular(30.0)),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                  alignment: Alignment.center,
                  child: Text(
                    buttonText,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SquareButtonSimple extends StatelessWidget {
  const SquareButtonSimple({
    this.buttonText,
    this.function,
  });
  final buttonText;
  final Function function;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        alignment: Alignment.center,
        child: MaterialButton(
          //color: Colors.deepPurpleAccent,
          onPressed: function,
          //Go to login screen.
          // ,
          minWidth: double.infinity,
          height: 63.0,
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            //borderRadius: BorderRadius.circular(30.0)),
            child: Container(
              constraints:
                  BoxConstraints(maxWidth: double.infinity, minHeight: 50.0),
              alignment: Alignment.center,
              child: Text(
                buttonText,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
