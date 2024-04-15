// import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

import '../bloc/authentication/authentication_bloc.dart';

class AuthRepository {
  AuthRepository() {

    init();
  }
  // AuthRepository({FirebaseAuth? firebaseAuth})
  //     : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance {
  //   Box<UserData> _userBox = Hive.box<UserData>('userData');
  // }
  late Box<UserData> _userBox;
    Future<void> init() async {
      if (!Hive.isBoxOpen('userData')) {
        _userBox = await Hive.openBox<UserData>('userData');
      }else {
        _userBox = Hive.box<UserData>('userData');
      }
    }

  // Future<void> signInWithEmailAndPassword(String email, String password) async {
  //   // await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  // }
    Future<void> signInWithEmailAndPassword(String email, String password) async {
      UserData? userData = getUserData();
      if (userData != null) {
        if (userData.email == email && userData.password == password) {
          // User is authenticated
        } else {
          AuthFailure;
          throw Exception('Invalid email or password');
        }
      } else {
        throw Exception('No user data found');
      }
    }

  Future<void> registerWithEmailAndPassword(String email, String password) async {
    // await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    // await _firebaseAuth.signOut();
  }

  // bool isUserSignedIn() {
  //   // return _firebaseAuth.currentUser != null;
  // }
  Future<void> registerUser(UserData userData) async {
    await _userBox.put('userData', userData);
  }
  UserData? getUserData() {
    if (_userBox.isNotEmpty) {
      return _userBox.get('userData');
    }
    return null;
  }

  Future<void> saveUserData(UserData userData) async {
    await _userBox.put('userData', userData);
  }
}

class UserData {
  final String name;
  final String email;
  final String password;

  UserData({required this.password, required this.name, required this.email});

  // Convert UserData to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }

  // Create UserData object from a map
  static UserData fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['name'],
      email: map['email'], password: map['password'],
    );
  }
}
class UserDataAdapter extends TypeAdapter<UserData> {
  @override
  final typeId = 10;

  @override
  UserData read(BinaryReader reader) {
    return UserData(
      name: reader.readString(),
      email: reader.readString(),
      password: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, UserData obj) {
    writer.writeString(obj.name);
    writer.writeString(obj.email);
    writer.writeString(obj.password);
  }
}