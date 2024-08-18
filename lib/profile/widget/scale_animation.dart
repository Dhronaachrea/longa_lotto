import 'package:flutter/material.dart';

class ScaleAnimate extends StatefulWidget {
  final ScaleController controller;
  final Widget child;

  const ScaleAnimate({
    Key? key,
    required this.controller,
    required this.child,
  }) : super(key: key);

  @override
  _ScaleAnimateState createState() => _ScaleAnimateState();
}

class _ScaleAnimateState extends State<ScaleAnimate>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this, value: 1);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.setState(this);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}

class ScaleController {
  _ScaleAnimateState _state = _ScaleAnimateState();

  void setState(_ScaleAnimateState state) {
    _state = state;
  }

  Future<void> scale({double? from}) {
    return _state._controller.forward(from: from ?? 0.8);
  }

  void dispose() {
    _state._controller.dispose();
  }
}
