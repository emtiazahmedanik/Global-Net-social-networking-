import 'package:flutter/material.dart';

class TypingIndicatorWidget extends StatefulWidget {
  const TypingIndicatorWidget({super.key});

  @override
  State<TypingIndicatorWidget> createState() => _TypingIndicatorWidgetState();
}

class _TypingIndicatorWidgetState extends State<TypingIndicatorWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();

    _animation1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.33, curve: Curves.easeInOut),
      ),
    );

    _animation2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.33, 0.66, curve: Curves.easeInOut),
      ),
    );

    _animation3 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.66, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 60, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const ShapeDecoration(
              color: Color(0xFFEDEDED),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(17),
                  topRight: Radius.circular(17),
                  bottomLeft: Radius.circular(2),
                  bottomRight: Radius.circular(17),
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AnimatedBuilder(
                  animation: _animation1,
                  builder: (context, child) {
                    return Container(
                      width: 4,
                      height: 4 + (_animation1.value * 2),
                      decoration: const ShapeDecoration(
                        color: Color(0xFFABABAB),
                        shape: OvalBorder(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 3),
                AnimatedBuilder(
                  animation: _animation2,
                  builder: (context, child) {
                    return Container(
                      width: 4,
                      height: 4 + (_animation2.value * 2),
                      decoration: const ShapeDecoration(
                        color: Color(0xFFABABAB),
                        shape: OvalBorder(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 3),
                AnimatedBuilder(
                  animation: _animation3,
                  builder: (context, child) {
                    return Container(
                      width: 4,
                      height: 4 + (_animation3.value * 2),
                      decoration: const ShapeDecoration(
                        color: Color(0xFFABABAB),
                        shape: OvalBorder(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
