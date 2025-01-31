import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
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
  final itemCtrl = TextEditingController();
  late Box box;
  List items = [];

  void initBox() async {
    box = await Hive.openBox('items');
    // box.clear();
    loadBox();
  }

  void loadBox() {
    items = box.values.toList();
    setState(() {});
    print(box.keys);
    print(box.values);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Lists'),
        // actions: [
        //   IconButton(
        //     onPressed: addItem,
        //     icon: Icon(Icons.add),
        //   ),
        // ],
      ),
      body: ListView.builder(
        itemBuilder: (_, index) {
          return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                delete(index);
              },
              child: Card(child: ListTile(title: Text(items[index]))));
        },
        itemCount: items.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addItem,
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  void addItem() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Item'),
        content: TextField(
          controller: itemCtrl,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: add,
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void add() async {
    await box.add(itemCtrl.text);
    itemCtrl.clear();
    Navigator.of(context).pop();
    loadBox();
  }

  void delete(int i) async {
    print('delete $i');
    await box.deleteAt(i); //index
    loadBox();
  }

  // void add() async {
  //   // var box = Hive.box('items');
  //   var box = await Hive.openBox('items');
  //   // box.put('item', itemCtrl.text);
  //   box.add(itemCtrl.text);
  //   // print('placed inside the box');
  //   // print(box.get('item'));
  //   // box.clear();
  //   print(box.values);
  //   print('${box.keys} keys');
  // }
}
