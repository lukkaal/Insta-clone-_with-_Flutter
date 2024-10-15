import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone_flutter/resources/auth_methods.dart';
import 'package:instagram_clone_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone_flutter/responsive/responsive_layout.dart';
import 'package:instagram_clone_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_clone_flutter/screens/signup_screen.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:instagram_clone_flutter/utils/global_variable.dart';
import 'package:instagram_clone_flutter/utils/utils.dart';
import 'package:instagram_clone_flutter/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // 两个 Controller 分别对应到登录的 email & password 利用 controller 可以接收并引用到字符
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  } // 需要对 controller 重新指定 dispose 方法
 
  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
        // Future<String> loginUser 是返回值为 String 类型的异步函数
    if (res == 'success') {
      if (context.mounted) { // 需要先知道是否 context.mounted 还是处于挂载状态 即是否有效 否则可能已经被销毁
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              ),
            ),
            (route) => false);
        // pushAndRemoveUntil 是一个导航方法，它不仅将新页面推入导航栈，还会移除栈中已有的页面
        // (route) => false: 条件函数，这里返回 false，表示删除栈中所有页面。
        // 因此当新的页面被推入栈中时，栈中所有之前的页面都会被移除。这样用户按返回键将无法返回到之前的页面。

        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      if (context.mounted) {
        showSnackBar(context, res);
      } // 使用自定义函数 showSnackBar 在当前 context 展示返回值（success 或者 对应的报错）
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > webScreenSize
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 32), // 根据不同的设备指定不同的padding大小
          width: double.infinity, // 代表了这个 Container 的宽度是 infinity 即顶到两边
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // 水平方向 向中心对齐
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ), // Flexible 的意义是可以比较灵活去填充该 Widget 剩余的位置 flex表示该 Flexible 组件在所有空余位置所占比率
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
                height: 64,
              ), // 导入相关 Svg 依赖包 即可传入svg格式文件
              const SizedBox(
                height: 64,
              ),
              TextFieldInput(
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ), // 自行定义的 TextField 传入指定的参数 位于text_field_input.dart文件中
              const SizedBox(
                height: 24,
              ), // 一般来说 SizedBox 是一个指定大小的Box或Container 但是也可以仅定义大小后用来占位
              TextFieldInput(
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                textEditingController: _passwordController,
                isPass: true,
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell( // InkWell组件可以使得点击后有水纹的效果
                onTap: loginUser, // 点击之后会采用到的 回调函数
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center, //child 的 align
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color: blueColor,
                  ),
                  child: !_isLoading
                      ? const Text(
                          'Log in',
                        )
                      : const CircularProgressIndicator( // 一个旋转的圆圈表示正在等待中 
                          color: primaryColor, 
                        ),
                ),// Container 是一个常用的布局组件，用于包装和修饰单个子 widget。
                  // 它可以添加填充、边距、边框、背景颜色等修饰功能。所以只能是 child 而没有 children
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // row 和 column 的 mainAxis 不一样
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      'Dont have an account?',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        ' Signup.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 不论是InkWell 还是 GestureDetector 所针对处理的对象都是 child，
// 各自的ontap也是指对child 进行tap后的跳转和setstate
