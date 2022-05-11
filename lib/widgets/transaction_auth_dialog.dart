import 'package:flutter/material.dart';

class TransactionAuthDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // Título do dialog
      title: Text(
        'Authenticate',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
      // Conteúdo do Dialog
      content: const TextField(
        obscureText: true,
        maxLength: 4,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),
        style: TextStyle(
          fontSize: 32,
          letterSpacing: 24,
        ),
      ),
      // Botões de ação do dialog
      actions: <Widget>[
        TextButton(
          child: const Text('CANCEL'),
          onPressed: () {},
        ),
        TextButton(
          child: const Text('CONFIRM'),
          onPressed: () {},
        ),
      ],
    );
  }
}
