import 'package:flutter/material.dart';
import 'package:persistent_data/car.dart';
import 'package:persistent_data/notes.dart';
import 'package:realm/realm.dart';

void main() {
  runApp(ListApp());
}

class ListApp extends StatelessWidget {
  const ListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListScreen(),
    );
  }
}

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late Realm realm;
  late RealmResults<Note> notes;

  final titleCtrl = TextEditingController();
  final contentCtrl = TextEditingController();

  void initRealm() {
    var config = Configuration.local([Note.schema]);
    realm = Realm(config);
    loadNotes();
  }

  void loadNotes() {
    notes = realm.all<Note>();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initRealm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          var note = notes[index];
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (_) {
              doDelete(note);
              loadNotes();
            },
            child: Card(
              child: ListTile(
                title: Text(note.title),
                subtitle: Text(note.content),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  void showAddDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            actions: [
              ElevatedButton(
                onPressed: doAdd,
                child: Text(
                  'Add',
                ),
              )
            ],
            title: Text('Add Note'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                ),
                TextField(
                  controller: contentCtrl,
                ),
              ],
            ),
          );
        });
  }

  void doAdd() {
    realm.write(() {
      var n = Note(titleCtrl.text, contentCtrl.text, date: DateTime.now());
      realm.add(n);
      print('added');
      loadNotes();
    });
  }

  void doDelete(Note n) {
    realm.write(() {
      realm.delete(n);
    });
  }

  void doUpdate(Note n) {
    realm.write(() {
      n.title = '';
    });
  }
}
