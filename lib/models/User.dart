class User {
  int? id;
  String? username;
  String? nama;
  String? password;
  String? nomorHP;

  User({this.id, this.username, this.nama, this.password, this.nomorHP});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    nama = json['nama'];
    password = json['password'];
    nomorHP = json['nomorHP'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['nama'] = nama;
    data['password'] = password;
    data['nomorHP'] = nomorHP;
    return data;
  }
}
