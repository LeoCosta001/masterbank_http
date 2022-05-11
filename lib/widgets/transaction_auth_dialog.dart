import 'package:flutter/material.dart';

class TransactionAuthDialog extends StatefulWidget {
  final Function(String password) onConfirm;

  TransactionAuthDialog({required this.onConfirm});

  @override
  State<TransactionAuthDialog> createState() => _TransactionAuthDialogState();
}

class _TransactionAuthDialogState extends State<TransactionAuthDialog> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Authenticate',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
      content: TextField(
        controller: _passwordController,
        obscureText: true,
        maxLength: 4,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        style: const TextStyle(
          fontSize: 32,
          letterSpacing: 24,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('CANCEL'),
          onPressed: () {},
        ),
        TextButton(
          child: const Text('CONFIRM'),
          onPressed: () {
            widget.onConfirm(_passwordController.value.text);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
