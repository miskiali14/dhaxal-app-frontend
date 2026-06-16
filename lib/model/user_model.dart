class User {
  String? id;
  String? name;
  String? email;
  String? image;
  String? password;
  String? gender;
  String? token;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.gender,
    this.token,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      image: json['image'] as String?,
      gender: json['gender'] as String?,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'password': password,
      'image': image,
      'gender': gender,
      'token': token,
    };
  }
}
