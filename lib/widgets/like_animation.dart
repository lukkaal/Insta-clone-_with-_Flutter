import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
// 有状态组件（StatefulWidget） 动画状态需要在组件生命周期中更新。
  final Widget child;
  final bool isAnimating;
  final Duration duration; // 动画持续时间
  final VoidCallback? onEnd; // 无返回值且不带参数的回调函数
  final bool smallLike;
  const LikeAnimation({
    Key? key,
    required this.child,
    required this.isAnimating,
    this.duration = const Duration(milliseconds: 150),
    this.onEnd,
    this.smallLike = false,
  }) : super(key: key); // 构造函数

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  // 这个混入类提供了一个 Ticker 使得动画能与屏幕刷新同步
  // 每个动画都需要一个 Ticker 来驱动动画帧
  late AnimationController controller;
  // 用于控制动画的 AnimationController
  late Animation<double> scale;
  // 用于缩放的动画属性 它的类型为 Animation<double>

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this, // 表示该动画将与屏幕的刷新帧同步
      duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2),
      // widget.duration 是从父组件传递进来的 Duration 对象
      // ~/ 2 使得代码灵活性更强 父组件不用依附到子组件
    );
    scale = Tween<double>(begin: 1, end: 1.2).animate(controller);
    // 缩放属性 利用 controller 实现
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isAnimating != oldWidget.isAnimating) {
      startAnimation();
    }
  }// 当父组件被重构时（比如父组件的 setState() 被调用或父组件接收到新的属性
  // Flutter 会调用子组件的 didUpdateWidget() 方法 通知子组件父组件的更新
  // 需要在子组件内定义 允许子组件根据父组件的新状态进行相应的更新
  // 如果检测到属性发生了变化 可以执行相应的更新逻辑


  startAnimation() async {
    if (widget.isAnimating || widget.smallLike) {
      await controller.forward();
      await controller.reverse();
      await Future.delayed(
        const Duration(milliseconds: 200),
      );
      // 对于上述动画而言 实际上只定义出了controller 和 scale的变化
      // 但是 controller 可以通过前向和后向来使同一个动画分别有两个效果

      if (widget.onEnd != null) {
        widget.onEnd!(); // 如果有回调函数那么调用
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }// 对 controller 重载 dispose()

  @override
  Widget build(BuildContext context) {
    // 使用 scale 动画控制子组件（widget.child）的缩放效果
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
