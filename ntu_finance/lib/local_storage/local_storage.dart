import 'package:hive/hive.dart';

class LocalStorageManager {
  final Box _userBox = Hive.box('userBox');

  void storeUserId(String userId) {
    _userBox.put('userId', userId);
  }

  String? getUserId() {
    return _userBox.get('userId');
  }

  void deleteUserId() {
    _userBox.delete('userId');
  }
}
