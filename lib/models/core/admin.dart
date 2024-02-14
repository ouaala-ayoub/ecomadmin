import 'dart:convert';

class Admin {
  String? id;
  String? username;
  String? password;
  bool root;

  Admin({this.id, this.username, this.password, this.root = false});

  @override
  String toString() =>
      '(id: $id, username: $username, password: $password, root: $root)';

  factory Admin.fromMap(Map<String, dynamic> data) => Admin(
        id: data['_id'] as String?,
        username: data['username'] as String?,
        password: data['password'] as String?,
        root: data['root'] ?? false,
      );

  Map<String, dynamic> toMap() => {
        '_id': id,
        'username': username,
        'password': password,
        'root': root,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [].
  factory Admin.fromJson(String data) {
    return Admin.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [] to a JSON string.
  String toJson() => json.encode(toMap());
}
