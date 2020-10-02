import 'package:app_example_reply/styling.dart';
import 'package:flutter/material.dart';

class ExpandItemPageTransition extends StatelessWidget {
  final Rect source;
  final String title;
  final Widget child;
  const ExpandItemPageTransition({Key key, this.source, this.title, this.child})
      : super(key: key);

  double _calculateHeaderHeight(BuildContext context, String msg) {
    final double maxWidth = MediaQuery.of(context).size.width - 80;
    final TextSpan span =
        TextSpan(style: Theme.of(context).textTheme.headline4, text: msg);
    final TextPainter painter =
        TextPainter(text: span, textDirection: TextDirection.ltr);
    painter.layout(minWidth: 0, maxWidth: maxWidth);
    return painter.height + 26;
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = ModalRoute.of(context).animation;
    final double topDisplayPadding = MediaQuery.of(context).padding.top;
    return LayoutBuilder(builder: (context, constraints) {
      final Animation<double> positionAnimation =
          CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn);

      final Animation<RelativeRect> itemPosition = RelativeRectTween(
              begin: RelativeRect.fromLTRB(
                  0, source.top, 0, constraints.biggest.height - source.bottom),
              end: RelativeRect.fill)
          .animate(positionAnimation);

      final Animation<double> fadeMaterialBackgroud = CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.2, curve: Curves.ease));

      final double distanceToAvatar =
          topDisplayPadding + _calculateHeaderHeight(context, title) - 16;

      final Animation<Offset> contentOffSet =
          Tween<Offset>(begin: Offset(0, -distanceToAvatar), end: Offset.zero)
              .animate(positionAnimation);

      return Stack(children: [
        PositionedTransition(
            rect: itemPosition,
            child: ClipRect(
                child: OverflowBox(
                    alignment: Alignment.topLeft,
                    minHeight: constraints.maxHeight,
                    maxHeight: constraints.maxHeight,
                    child: AnimatedBuilder(
                        animation: contentOffSet,
                        child: FadeTransition(
                            opacity: fadeMaterialBackgroud,
                            child: Material(
                                color: AppTheme.nearlyWhite, child: child)),
                        builder: (context, child) {
                          return Transform.translate(
                              offset: contentOffSet.value, child: child);
                        }))))
      ]);
    });
  }
}
