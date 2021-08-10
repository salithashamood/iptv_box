import 'package:flutter/material.dart';

class ChannelForm extends StatefulWidget {
  const ChannelForm({
    Key key,
    this.data,
    this.text,
    this.icon,
    this.onSaved,
  }) : super(key: key);
  final String data;
  final String text;
  final Icon icon;
  final Function onSaved;

  @override
  _ChannelFormState createState() => _ChannelFormState();
}

class _ChannelFormState extends State<ChannelForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        TextFormField(
          initialValue: widget.data,
          onSaved: (value) {
            widget.onSaved(value);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Required *';
            }
            return null;
          },
          decoration: InputDecoration(prefixIcon: widget.icon),
        ),
      ],
    );
  }
}
