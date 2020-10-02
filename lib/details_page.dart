import 'package:app_example_reply/model/email_model.dart';
import 'package:app_example_reply/styling.dart';
import 'package:app_example_reply/transition/expand_transition.dart';
import 'package:app_example_reply/ui/rounded_avatar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/email.dart';

class DetailsPage extends StatefulWidget {
  final int id;
  final Email email;
  final Rect sourceRect;
  const DetailsPage({
    Key key,
    @required this.id,
    @required this.email,
    @required this.sourceRect,
  })  : assert(id != null && email != null && sourceRect != null),
        super(key: key);

  static Route<dynamic> route(BuildContext context, int id, Email email) {
    final RenderBox box = context.findRenderObject();
    final Rect sourceRect = box.localToGlobal(Offset.zero) & box.size;
    Provider.of<EmailModel>(context).currentlySelectedEmailId = id;
    return PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            DetailsPage(id: id, email: email, sourceRect: sourceRect),
        transitionDuration: const Duration(milliseconds: 350));
  }

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Widget get _header {
    final Animation<double> fadeAnimation = CurvedAnimation(
        parent: ModalRoute.of(context).animation, curve: Curves.fastOutSlowIn);
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Padding(
          padding: const EdgeInsets.only(left: 12, top: 12),
          child: FadeTransition(
              opacity: fadeAnimation,
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                    child: Text(widget.email.subject,
                        style: Theme.of(context).textTheme.headline4)),
                IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down),
                    padding: const EdgeInsets.only(left: 24, top: 0, right: 12),
                    onPressed: () {
                      Provider.of<EmailModel>(context)
                          .currentlySelectedEmailId = -1;
                      Navigator.of(context).pop();
                    })
              ]))),
      const SizedBox(height: 12),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(children: [
            Expanded(
                child: FadeTransition(
                    opacity: fadeAnimation,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${widget.email.sender} - ${widget.email.time}',
                              style: Theme.of(context).textTheme.bodyText1),
                          const SizedBox(height: 2),
                          Text('To ${widget.email.recipients}',
                              style: Theme.of(context).textTheme.caption)
                        ]))),
            Hero(
                tag: widget.email.subject,
                child: RoundedAvatar(
                    image: 'assets/images/${widget.email.avatar}'))
          ]))
    ]);
  }

  Widget get _body {
    final Animation<double> fadeAnimation = CurvedAnimation(
        parent: ModalRoute.of(context).animation,
        curve: Curves.fastLinearToSlowEaseIn);

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: FadeTransition(
            opacity: fadeAnimation,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const SizedBox(height: 24),
              Text(widget.email.message,
                  style: Theme.of(context).textTheme.bodyText2),
              if (widget.email.containsPictures) const SizedBox(height: 24),
              if (widget.email.containsPictures)
                Image.asset('assets/images/photo_grid.jpg'),
              const SizedBox(height: 56)
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return ExpandItemPageTransition(
        source: widget.sourceRect,
        title: widget.email.subject,
        child: Material(
            child: SafeArea(
                child: Container(
                    height: double.infinity,
                    margin: const EdgeInsets.all(4),
                    color: AppTheme.nearlyWhite,
                    child: Material(
                        color: Colors.white,
                        child: SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [_header, _body])))))));
  }
}
