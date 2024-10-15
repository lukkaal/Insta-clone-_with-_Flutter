import 'package:flutter/widgets.dart';
import 'package:instagram_clone_flutter/models/user.dart';
import 'package:instagram_clone_flutter/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  User get getUser => _user!; // getUser方法 返回一个实例对象

  Future<void> refreshUser() async { // // 如果用户信息被改变的话 可以调用这个函数 会返回到更新后的实例对象并赋值
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners(); // 通知所有订阅 UserProvider 的页面 更新用户信息
  }
}