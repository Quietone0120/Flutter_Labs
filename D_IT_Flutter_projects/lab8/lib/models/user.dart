class User {
  int id;
  String name;
  String city;
  int age;
  List<String> hobbies;

  User({
    required this.id,
    required this.name,
    required this.city,
    required this.age,
    required this.hobbies,
  });

  // JSON-оос User объект рүү хөрвүүлэх
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      age: json['age'],
      hobbies: List<String>.from(json['hobbies']),
    );
  }

  // User объектыг JSON рүү хөрвүүлэх
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'age': age,
      'hobbies': hobbies,
    };
  }
}
