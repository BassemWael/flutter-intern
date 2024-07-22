import 'package:hive/hive.dart';

part 'users.g.dart';

@HiveType(typeId: 1)
class Users {
  Users({
    required this.name,
    required this.email,
  });

  @HiveField(0)
  String name;

  @HiveField(1)
  String email;
}
