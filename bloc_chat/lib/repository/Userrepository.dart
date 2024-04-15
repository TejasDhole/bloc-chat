import 'package:hive/hive.dart';

import '../models/user_model.dart';

class UserRepository {
  // final userBox = Hive.box<User>('userBox');
  late Box<User> userBox;

  Future<void> init() async {
    if (!Hive.isBoxOpen('userBox')) {
      userBox = await Hive.openBox<User>('userBox');
    } else {
      userBox = Hive.box<User>('userBox');
    }
  }
    void addUser(User user) {
      userBox.put(user.id, user);
    }

    List<User> getUsers() {
      return userBox.values.toList();
    }

}


class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0; // Unique identifier for your User class

  @override
  User read(BinaryReader reader) {
    // Implement logic to read User object from bytes
    // Example:
    final fields = reader.readMap();
    return User(
      id: fields['id'] as String,
      name: fields['name'] as String,
      // Add more fields as needed
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    // Implement logic to write User object to bytes
    // Example:
    writer.writeMap({
      'id': obj.id,
      'name': obj.name,
      // Add more fields as needed
    });
  }
}
