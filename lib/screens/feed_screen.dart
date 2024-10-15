import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:instagram_clone_flutter/utils/global_variable.dart';
import 'package:instagram_clone_flutter/widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:
          width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      appBar: width > webScreenSize
          ? null
          : AppBar( // 一个常见的AppBar是由 leading title actions 组成的
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
                height: 32,
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.messenger_outline,
                    color: primaryColor,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
      body: StreamBuilder( // 用来监听一个数据流
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        // 监听 posts 集合 当这个集合出现了增减更新 这个流会触发更新 返回一个快照 这个快照类型是 QuerySnapshot
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              // AsyncSnapshot 特别在与 StreamBuilder 或 FutureBuilder 配合时 代表异步操作（如数据流）的当前状态
              // 声明了 QuerySnapshot 是以 Map 的形式存储
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length, 
            // snapshot.data! 是对 AsyncSnapshot 一个属性解包操作 
            // snapshot.data! == FirebaseFirestore.instance.collection('posts')
            itemBuilder: (ctx, index) => Container(
              margin: EdgeInsets.symmetric(
                horizontal: width > webScreenSize ? width * 0.3 : 0,
                vertical: width > webScreenSize ? 15 : 0,
              ),
              child: PostCard(
                snap: snapshot.data!.docs[index].data(), // data() 是针对指定文件的函数调用
              ),
            ),
          );
        },
      ),
    );
  }
}
// 该文件会显示出一个页面 有 AppBar 和 Streambuilder 会根据监听到的变化对页面进行自动更新