import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// for picking up image from gallery
Future<Uint8List> pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker(); // 首先是需要导入相关包 在这里也需要实例化一个 ImagePicker的对象
  XFile? file = await imagePicker.pickImage(source: source); // 利用实例化的对象调用 pickImage 函数 可以从相机或者文件中获取照片
  // XFile 表示的是 异步选择的文件
  if (file != null) {
    return await file.readAsBytes(); // 获得了文件之后 可以自定义返回文件的方式 Bytes Lines String Onread 等等 
    // 这里返回的是 Uint8List 类型的文件 是二进制的
  }
}

// for displaying snackbars
showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar( 
    // ScaffoldMessenger 可以用显示 material banners 或者 snackbar
    // 需要指定出此时的 buildcontext 以便在当前页面显示出
    SnackBar(
      content: Text(text),
    ),
  );
}
// 在调用ScaffoldMessenger的时候 material banners 和 snackbar 有不同的操作方式：
// 前者调用后需要使用 hideCurrentMaterialBanner 去手动关闭掉（leading content actions）
// 后者不需要 默认时间是4s 可以使用 duration 来指定显示时间
