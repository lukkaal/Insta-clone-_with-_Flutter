import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone_flutter/models/user.dart' as model;
import 'package:instagram_clone_flutter/resources/storage_methods.dart';

class AuthMethods {
  // 使用Firebase的Auth功能 也就是存入后端数据库前的验证部分
  // 启用instance单例模式：在项目内任何位置调用instance都可以获取到相应的信息
  // 这里的_firestore 和 _auth 都只是本文件内对 instance 的别称
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  //_auth 实例对象有非常多的用法 是对Firebase 认证系统的交互
  //常用的是_auth.currentuser 会返回一个User对象(Flutter自行定义的) 
  //可以查看FireAuth自行生成的 唯一的uid等参数

  // get user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!; 

    DocumentSnapshot documentSnapshot =
    // 返回 doc:user/uid 的文件快照 在Firestore当中
    // 绝大部分数据都是存储在 firestore 当中 在 fireauth 当中存储的是根据所使用的登录方式自动存储的值 
    // 如uid email 等
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  // Signing Up User

  Future<String> signUpUser({// required 表示这些参数在调用函数的时候必须要传入
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        // registering user in auth with email and password
        // 注册时使用邮箱+密码注册 注册与仓库之间的authentic是一个异步的过程 所以使用await
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        // cred是Usercredential的实例对象 可以对 Usercredential 调用 .user 来获取到刚刚注册好的用户信息
        // 但是实际上 在完成注册后的同时 FirebaseAuth.instance.currentUser 已经自动设置为了当前的 User实例
        // 所以 cred.user 和  FirebaseAuth.instance.currentUser 的返回值此时均为 User！user（因为可能现在没有对象）

        String photoUrl =
            await StorageMethods().uploadImageToStorage('profilePics', file, false);
        // 照片需要存储到 Storage
        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          photoUrl: photoUrl,
          email: email,
          bio: bio,
          followers: [],
          following: [],
        );// 信息从：界面中输入的Text + Auth的uid + 初始化 follower/ following

        // adding user in our database
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());
        // 在 firestore 中设置相应的 Map<String, dynamic>
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res; // Signup 的确是一个异步的过程(有许多await的过程) 返回的值也是一个Future<String>
  }

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        ); // 这里只是为了登录 不需要对数据库的数据进行处理 所以只需要await就好 
        //完成之后_auth.currentUser 自动会变成对应的User
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
