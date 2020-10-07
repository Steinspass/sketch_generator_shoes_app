import 'package:flutter/material.dart';

class ButtonGradientWidget extends StatefulWidget {

  final String title;
  final Function() onTap;


  ButtonGradientWidget({
    @required this.title,
    @required this.onTap
  });

  @override
  _ButtonGradientWidgetState createState() => _ButtonGradientWidgetState();
}

class _ButtonGradientWidgetState extends State<ButtonGradientWidget> {
  
  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: MediaQuery.of(context).size.height / 13.0,
        width: MediaQuery.of(context).size.width * 0.45,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 15.0
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 22.0,
          vertical: 16.0
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: Color(0xFF3B3957),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              spreadRadius: 0.5,
              blurRadius: 2
            )
          ]
        ),
        child: Text(
          widget.title,
          style: TextStyle(
            color: Colors.grey[50],
            fontSize:  18.0,
            fontWeight: FontWeight.w500
          ),
        ),
      ),
    );
  }
}