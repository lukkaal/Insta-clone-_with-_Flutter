import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  // 类中定义好的变量 类中函数可以直接使用
  final String description;
  final String uid;
  final String username;
  final likes;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage; // 类当中定义出的变量 每次调用到Post的实例的时候 需要使用构造函数对这些变量进行初始化

  const Post(
      {required this.description,
      required this.uid,
      required this.username,
      required this.likes,
      required this.postId,
      required this.datePublished,
      required this.postUrl,
      required this.profImage,
      });// 类的构造函数 required 表示调用的时候对参数进行初始化

  static Post fromSnap(DocumentSnapshot snap) { // 代码返回一个Post的实例对象
    var snapshot = snap.data() as Map<String, dynamic>; // 一般来说 DocumentSnapshot类型变量是一个文件的快照 参考FirebaseFirestore.instance.colletion('posts').doc('userid').get()

    return Post(
      description: snapshot["description"],
      uid: snapshot["uid"],
      likes: snapshot["likes"],
      postId: snapshot["postId"],
      datePublished: snapshot["datePublished"],
      username: snapshot["username"],
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage']
    ); // Snap.data()会返回一个Map<String, dynamic>, Firestore -> Collection -> docs -> fields, 文件里的对象都是键值对结构 
  }

   Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "likes": likes,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        'postUrl': postUrl,
        'profImage': profImage
      }; // 返回一个Json样式的文件 或者说直接返回一个Map<String, dynamic>返回类型的对象
}
