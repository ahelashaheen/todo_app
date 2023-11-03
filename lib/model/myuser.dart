class MyUser {
  static const String collectionsName = 'users';
  String? id;
  String? email;
  String? name;

  MyUser({required this.id, required this.name, required this.email});

  MyUser.fromFireStore(Map<String, dynamic> data) :this(
    id: data['id'],
    email: data['email'],
    name: data['name'],
  );

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'email': email,
      'name': name
    };
  }

}