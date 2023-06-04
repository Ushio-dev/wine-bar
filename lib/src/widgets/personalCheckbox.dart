import 'package:flutter/material.dart';

class PersonalCheckBox extends StatefulWidget {
  final bool estadoComida;
  PersonalCheckBox({Key? key, required this.estadoComida}) : super(key: key);

  @override
  State<PersonalCheckBox> createState() => _PersonalCheckBoxState();
}

class _PersonalCheckBoxState extends State<PersonalCheckBox> {
  @override
  Widget build(BuildContext context) {
    return _buildCheckBox(widget.estadoComida);
  }

  Widget _buildCheckBox(bool estadoComida) {
    return Checkbox(
      value: estadoComida, 
      onChanged: (value) {
        setState(() {
          estadoComida = value!;
        });
        
        /*
        if (!estadoComida){
          estadoComida = value!;
        } else {
          null;
        }
        */
      },
    );
  }
}