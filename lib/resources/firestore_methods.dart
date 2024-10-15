import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone_flutter/models/post.dart';
import 'package:instagram_clone_flutter/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // 这里的 _firestore 其实和上一个 _auth_methods 文档里的是一个东西
  //都是 FirebaseFirestore.instance 的引用 (相当于就是全局变量)

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      ); // 初始化一个 Post 的实例对象 参数来自 界面的Text + 从 Storage 拉来的url + 初始化likes
      await _firestore.collection('posts').doc(postId).set(post.toJson());
      // 操作的对象也是firestore 在posts下创建一个以postId命名的文件 而postId本身也是uuid去生成的
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // 对列表调用 .contains 可以返回 bool 用于查看列表是否存在元素
        // if the likes list contains the user uid, we need to remove it
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove(
              [uid]) // FieldValue 是一个类，arrayRemove 是它的一个方法 用来在列表中唯一删除指定的元素
        });
      } else {
        // else we need to add uid to the likes array
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion(
              [uid]) // FieldValue 是一个类，arrayUnion 是它的一个方法 用来在列表中唯一添加指定的元素
        }); // 这个函数是异步的，所以需要等待它完成 点击触发函数的逻辑是 喜欢或不喜欢 底层逻辑是将list中元素增添或者删除
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post comment
  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(
                commentId) // 在posts下创建一个以postId命名的文件 在这个文件下创建一个以commentId命名的文件 conmmentId也是uuid去生成的
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .delete(); // 调用函数直接删除掉某个postId的文件 postId是uuid生成并存储在post
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Follow/unfollow user
  Future<void> followUser(String uid, String followId) async {
    try {
      // 点击按钮之后会对user中对应 uid 和 followId 的 followers/ followings 进行增添或者删除
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following =
          (snap.data()! as dynamic)['following']; // 获取到uid对应的following列表

      if (following.contains(followId)) {
        // 如果列表中已经存在followId，则删除
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        // 如果列表中不存在followId，则增添
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }
}
