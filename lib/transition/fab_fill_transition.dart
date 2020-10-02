import 'package:app_example_reply/styling.dart';
import 'package:flutter/material.dart';

class FabFillTransition extends StatelessWidget {
  final Rect source;
  final Widget child;
  final String icon;
  const FabFillTransition({
    Key key,
    this.source,
    this.child,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = ModalRoute.of(context).animation;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final Animation<double> positionAnimation =
          CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn);
      final Animation<RelativeRect> itemPosition = RelativeRectTween(
              begin: RelativeRect.fromLTRB(
                  source.left,
                  source.top,
                  constraints.biggest.width - source.right,
                  constraints.biggest.height - source.bottom),
              end: RelativeRect.fill)
          .animate(positionAnimation);

      final BorderRadiusTween borderTween = BorderRadiusTween(
          begin: BorderRadius.circular(source.width / 2),
          end: BorderRadius.circular(0.0));

      final Animation<double> fadeMaterialBackground = CurvedAnimation(
          parent: animation, curve: const Interval(0.2, 1, curve: Curves.ease));

      final Animation<double> scaleAnimation = CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.9, curve: Curves.fastOutSlowIn));

      final Tween<double> fabIconTween = Tween<double>(begin: 1.0, end: 3.0);
      return Stack(children: [
        PositionedTransition(
            rect: itemPosition,
            child: AnimatedBuilder(
                animation: positionAnimation,
                child: OverflowBox(
                    alignment: Alignment.topCenter,
                    minWidth: constraints.maxWidth,
                    maxWidth: constraints.maxWidth,
                    minHeight: constraints.maxHeight,
                    maxHeight: constraints.maxHeight,
                    child: child),
                builder: (BuildContext context, Widget child) {
                  return ClipRRect(
                      borderRadius: borderTween.evaluate(positionAnimation),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(children: [
                        Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: AppTheme.orange,
                            alignment: Alignment.center,
                            child: ScaleTransition(
                                alignment: Alignment.topCenter,
                                scale: fabIconTween.animate(scaleAnimation),
                                child: Image.asset(icon, width: 24))),
                        FadeTransition(
                            opacity: fadeMaterialBackground,
                            child: ScaleTransition(
                                alignment: Alignment.topCenter,
                                scale: scaleAnimation,
                                child: child))
                      ]));
                }))
      ]);
    });
  }
}
