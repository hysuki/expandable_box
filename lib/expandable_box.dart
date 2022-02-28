import 'package:flutter/material.dart';
import 'palette.dart';

typedef ExpandableBoxBuilder = Widget Function(
    BuildContext context, ExpandableBoxState state);

class ExpandableBox extends StatefulWidget {
  final bool expand;
  final double collapsedHeight;
  final Duration animationDuration;
  final ExpandableBoxBuilder? headerBuilder;
  final ExpandableBoxBuilder builder;
  final ExpandableBoxBuilder? footerBuilder;

  const ExpandableBox({
    Key? key,
    this.expand = false,
    this.collapsedHeight = 100,
    this.animationDuration = const Duration(milliseconds: 500),
    this.headerBuilder,
    required this.builder,
    this.footerBuilder,
  }) : super(key: key);

  @override
  ExpandableBoxState createState() => ExpandableBoxState();
}

class ExpandableBoxState extends State<ExpandableBox>
    with TickerProviderStateMixin {
  final GlobalKey render = GlobalKey();
  late AnimationController _animationController;
  late Animation<double> _curveAnimation;
  late Animation<double> _animation;

  double _begin = 0;
  late bool expand;

  @override
  void initState() {
    expand = widget.expand;
    initAnimation();
    super.initState();
  }

  void initAnimation() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        _begin = widget.collapsedHeight / render.currentContext!.size!.height;
        if (expand) {
          _animation = Tween(begin: 1.0, end: _begin).animate(_curveAnimation);
        } else {
          _animation = Tween(begin: _begin, end: 1.0).animate(_curveAnimation);
        }
        _animationController.reset();
      });
    });

    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _curveAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_curveAnimation);
  }

  void _updateAnimation() {
    if (widget.expand) {
      if (expand) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    } else {
      if (expand) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggle() {
    setState(() {
      expand = !expand;
    });
    _updateAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        widget.headerBuilder != null
            ? widget.headerBuilder!(context, this)
            : Container(),
        ShaderMask(
          shaderCallback: (rect) {
            if (expand) {
              return const LinearGradient(
                      colors: [Palette.dark_charoal, Palette.dark_charoal])
                  .createShader(rect);
            } else {
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.6, 1],
                colors: [Colors.black, Colors.transparent],
              ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
            }
          },
          blendMode: BlendMode.dstIn,
          child: SizeTransition(
            axisAlignment: 1.0,
            sizeFactor: _animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(_animation),
              child: Container(
                key: render,
                child: widget.builder(context, this),
              ),
            ),
          ),
        ),
        widget.footerBuilder != null
            ? widget.footerBuilder!(context, this)
            : Container(),
      ],
    );
  }
}
