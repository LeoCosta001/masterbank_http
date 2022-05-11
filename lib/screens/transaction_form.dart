import 'package:flutter/material.dart';
import 'package:masterbank/http/webclient/transaction_webclient.dart';
import 'package:masterbank/models/contact.dart';
import 'package:masterbank/models/transaction.dart';
import 'package:masterbank/widgets/response_dialog.dart';
import 'package:masterbank/widgets/transaction_auth_dialog.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  TransactionForm(this.contact);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();
  final TransactionWebClient _transactionWebClient = TransactionWebClient();

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
                      final transactionCreated = Transaction(value ?? 0, widget.contact);
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
    _transactionWebClient.postTransaction(transactionCreated, password).then(
      (Transaction? transaction) {
        if (transaction != null) {
          showDialog(
              context: context,
              builder: (context) {
                return SuccessDialog('Successful transaction');
              }).then((value) => Navigator.pop(context));
        }
      },
    ).catchError((error) {
      showDialog(
          context: context,
          builder: (contextDialog) {
            return FailureDialog(error.message);
          });
      // Verifica se o tipo de erro esperado é um Exception
      // Se o return for "false" então o "catchError" não será executado)
    }, test: (error) => error is Exception);
  }
}
