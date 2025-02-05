import 'package:realm/realm.dart';

part 'notes.realm.dart';

@RealmModel()
class _Note {
  late String title;
  DateTime? date;
}
