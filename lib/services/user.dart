class User{
  final int? id;
  final String name;
  final String phoneNumber;
  final String? nickname;
  final String? email;
  final String? address;

  User({this.id, required this.name, required this.phoneNumber, this.nickname, this.email, this.address });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      nickname: json['nickname'],
      email: json['email'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'name':name,
      'phoneNumber':phoneNumber,
      'nickname':nickname,
      'email':email,
      'address':address,
    };
  }

}