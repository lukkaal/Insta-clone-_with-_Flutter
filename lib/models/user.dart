import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  // 类中定义的变量 用于记录User的信息
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;// 类当中定义出的变量 每次调用到User的实例的时候 需要使用构造函数对这些变量进行初始化

  const User(
      {required this.username,
      required this.uid,
      required this.photoUrl,
      required this.email,
      required this.bio,
      required this.followers,
      required this.following});// 类的构造函数 required 表示调用的时候对参数进行初始化

  static User fromSnap(DocumentSnapshot snap) { // 代码返回一个User的实例对象
    var snapshot = snap.data() as Map<String, dynamic>; /// 一般来说 DocumentSnapshot类型变量是一个文件的快照 参考FirebaseFirestore.instance.colletion('users').doc('userid').get()

    return User(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      bio: snapshot["bio"],
      followers: snapshot["followers"],
      following: snapshot["following"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
      };// 返回一个Json样式的文件 或者说直接返回一个Map<String, dynamic>返回类型的对象
}
