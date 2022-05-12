import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:masterbank/http/webclient/transaction_webclient.dart';
import 'package:masterbank/models/contact.dart';
import 'package:masterbank/models/transaction.dart';
import 'package:masterbank/widgets/response_dialog.dart';
import 'package:masterbank/widgets/transaction_auth_dialog.dart';
import 'package:uuid/uuid.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  TransactionForm(this.contact);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();
  final TransactionWebClient _transactionWebClient = TransactionWebClient();
  final String transactionId = const Uuid().v4();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.contact.accountName,
                style: const TextStyle(fontSize: 24.0),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  widget.contact.accountNumber.toString(),
                  style: const TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: const TextStyle(fontSize: 24.0),
                  decoration: const InputDecoration(labelText: 'Value'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: const Text('Transfer'),
                    onPressed: () {
                      final double? value = double.tryParse(_valueController.text);
                      final transactionCreated = Transaction(transactionId , value ?? 0, widget.contact);
                      showDialog(
                        context: context,
                        // OBS: O "Context" deste "builder" precisa ter um nome diferente do "Context" do widget
                        builder: (contextDialog) {
                          return TransactionAuthDialog(
                            onConfirm: (String password) {
                              _sendTransaction(transactionCreated, password, context);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _sendTransaction(
    Transaction transactionCreated,
    String password,
    BuildContext context,
  ) async {
    Transaction transaction = await _send(
      transactionCreated,
      password,
      context,
    );

    _showSuccessfulMessage(transaction, context);
  }

  Future<void> _showSuccessfulMessage(Transaction transaction, BuildContext context) async {
    if (transaction != null) {
      await showDialog(
          context: context,
          builder: (context) {
            return SuccessDialog('Successful transaction');
          });
      Navigator.pop(context);
    }
  }

  Future<Transaction> _send(
      Transaction transactionCreated, String password, BuildContext context) async {
    final Transaction transaction = await _transactionWebClient
        .postTransaction(transactionCreated, password)
        .catchError((error) {
      _showFailureDialog(context, message: error.message);

      // Verifica se o tipo de erro esperado é um HttpException
      // Se o return for "false" então o "catchError" não será executado)
    }, test: (error) => error is HttpException).catchError((error) {
      _showFailureDialog(context, message: 'Timeout submitting the transaction');
    }, test: (error) => error is SocketException).catchError((error) {
      _showFailureDialog(context);
    });
    return transaction;
  }

  void _showFailureDialog(BuildContext context, {String message = 'Unknown error'}) {
    showDialog(
        context: context,
        builder: (contextDialog) {
          return FailureDialog(message);
        });
  }
}
