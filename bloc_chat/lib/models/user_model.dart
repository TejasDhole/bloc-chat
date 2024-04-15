import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class User {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  User({required this.id, required this.name});
}