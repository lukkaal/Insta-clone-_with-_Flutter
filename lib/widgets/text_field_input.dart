import 'package:flutter/material.dart';
// 这个文件重新定义了一个TextField 也就是说在原先的基础上变成了 TextFieldInput
// 这个组件会允许用户在UI中输入参数 
class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController; // 对于每一个Textfield而言 需要一个controller来跟踪输入的字符
  final bool isPass;
  final String hintText;
  final TextInputType textInputType; // TextInputType 是输入框的字符种类 有text和emailAddress等
  const TextFieldInput({
    Key? key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    required this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );

    return TextField(
      // 可以指定字符的风格 然后再在 decoration 中去设置 hinttext style
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,// 分别对应着不同状态下的边框
        filled: true, //是否用指定的颜色去填充边框
        contentPadding: const EdgeInsets.all(8), //用户输入的字符举例边框的位置
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
