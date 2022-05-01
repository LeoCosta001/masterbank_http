import 'package:flutter/material.dart';
import 'package:masterbank/database/dao/contact_dao.dart';
import 'package:masterbank/models/contact.dart';
import 'package:masterbank/screens/contacts_form.dart';
import 'package:masterbank/screens/transaction_form.dart';
import 'package:masterbank/widgets/centered_message.dart';
import 'package:masterbank/widgets/loading_page.dart';

class ContactsList extends StatefulWidget {
  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  final ContactDao _contactDao = ContactDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer'),
      ),
      body: FutureBuilder<List<Contact>>(
        initialData: const [],
        future: _contactDao.findAll(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return LoadingPage();
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              if (snapshot.data != null) {
                final List<Contact> contactList = snapshot.data as List<Contact>;
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final Contact contact = contactList[index];
                    return _ContactItem(contact, onClick: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => TransactionForm(contact)),
                      );
                    });
                  },
                  itemCount: contactList.length,
                );
              }
              return CenteredMessage(
                'Unknown error!',
                icon: Icons.error,
                color: Theme.of(context).errorColor,
              );
          }
          return Container();
        },
      ),

      /// Exibe uma lista vazia durante a requisição
      /// OBS: Está comentado por que nesta situação não está sendo tratado os status da requisição devidamente
      // body: FutureBuilder<List<Contact>>(
      //   initialData: const [],
      //   future: findAll(),
      //   builder: (context, snapshot) {
      //     if (snapshot.data != null) {
      //       final List<Contact> contactList = snapshot.data as List<Contact>;
      //       return ListView.builder(
      //         itemBuilder: (context, index) {
      //           final Contact contact = contactList[index];
      //           return _ContactItem(contact);
      //         },
      //         itemCount: contactList.length,
      //       );
      //     }
      //     return Container();
      //   },
      // ),

      /// Exibe um "Loading" enquanto o valor do "snapshot.data" for "null".
      /// OBS: Está comentado por que nesta situação não é muito viavel tendo em vista que a lista carrega osdados rapido já que a lista é pequena e carregada a partir de um DB local.
      /// Para que um erro não seja exibido durante a requisição foi adicionado um valor inicial sendo uma lista vazia.
      // body: FutureBuilder<List<Contact>>(
      //   future: Future.delayed(const Duration(seconds: 1)).then((value) => findAll()),
      //   builder: (context, snapshot) {
      //     if (snapshot.data != null) {
      //       final List<Contact> contactList = snapshot.data as List<Contact>;
      //       return ListView.builder(
      //         itemBuilder: (context, index) {
      //           final Contact contact = contactList[index];
      //           return _ContactItem(contact);
      //         },
      //         itemCount: contactList.length,
      //       );
      //     }
      //     // Exibe um "Loading" enquanto o valor do "snapshot.data" for "null"
      //     return Center(
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: <Widget>[
      //           const CircularProgressIndicator(),
      //           Padding(
      //             padding: const EdgeInsets.only(top: 16.0),
      //             child: Text(
      //               'Loading...',
      //               style: TextStyle(
      //                 fontSize: 24.0,
      //                 color: Theme.of(context).primaryColor,
      //               ),
      //             ),
      //           )
      //         ],
      //       ),
      //     );
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
            builder: (context) => ContactsForm(),
          ))
              .then((value) {
            /// Atualiza a lista novamente quando o usuário retornar da página seguinte
            setState(() {});
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final Contact contact;
  final Function onClick;

  const _ContactItem(
    this.contact, {
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => onClick(),
        title: Text(
          contact.accountName,
          style: const TextStyle(fontSize: 24.0),
        ),
        subtitle: Text(
          contact.accountNumber.toString(),
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
