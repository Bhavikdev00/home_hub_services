import 'package:get_storage/get_storage.dart';

class StorageService{
  static final StorageService _instance = StorageService._internal();
  late GetStorage _storage;
  static String registerStatus = "Register";
  static String loginStatus = "LoginStatus";

  factory StorageService() {
    return _instance;
  }
  StorageService._internal() {
    _initStorage();
  }

  void _initStorage() async {
    await GetStorage.init(); // Initialize GetStorage
    _storage = GetStorage(); // Create an instance of GetStorage
  }

  Future<void> loginStatusCheck(bool value) async {
    await _storage.write(loginStatus, value);
  }

  dynamic getLoginStatus() {
    return _storage.read(loginStatus) ?? false;
  }

  RegisterStatusCheck(bool value) async {
    await _storage.write(registerStatus, value);
  }

  dynamic getRegisterStatus() {
    return _storage.read(registerStatus) ?? false;
  }

  Future<void> removeDAta() async {
    await _storage.erase();
  }
}