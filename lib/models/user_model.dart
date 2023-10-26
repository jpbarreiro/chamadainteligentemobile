class AuthUser {
  static final AuthUser _instance = AuthUser._internal();

  factory AuthUser() {
    return _instance;
  }

  AuthUser._internal();

  late UserModel userModel;
  void login(Map<String, dynamic> json) {
    userModel = UserModel(json);
  }
}

class UserModel{
  late String name;
  late String id;
  late String role;

  UserModel(Map<String, dynamic> json){
    id = json["id"];
    name = json["name"];
    role = json["role"];
  }
}