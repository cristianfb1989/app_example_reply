import 'package:app_example_reply/model/email_model.dart';
import 'package:app_example_reply/styling.dart';
import 'package:app_example_reply/transition/fab_fill_transition.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/email.dart';

class EditorPage extends StatefulWidget {
  final Rect sourceRect;
  const EditorPage({Key key, @required this.sourceRect})
      : assert(sourceRect != null),
        super(key: key);

  static Route<dynamic> route(context, GlobalKey key) {
    final RenderBox box = key.currentContext.findRenderObject();
    final Rect sourceRect = box.localToGlobal(Offset.zero) & box.size;
    return PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            EditorPage(sourceRect: sourceRect),
        transitionDuration: const Duration(milliseconds: 350));
  }

  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  String _senderEmail = 'from.jennifer@example.com';
  String _subject = '';
  String _recipient = 'Recipient';
  String _recipientAvatar = 'avatar.png';

  Widget get _spacer {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Container(
            width: double.infinity, height: 1, color: AppTheme.spacer));
  }

  Widget get _subjectRow {
    return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          IconButton(
              icon: const Icon(Icons.close, color: AppTheme.lightText),
              onPressed: () => Navigator.of(context).pop()),
          Expanded(
              child:
                  Text(_subject, style: Theme.of(context).textTheme.headline6)),
          IconButton(
              icon: Image.asset('assets/image/ic_send.png',
                  width: 24, height: 24),
              onPressed: null)
        ]));
  }

  Widget get _senderAddressRow {
    return PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        onSelected: (String email) {
          setState(() {
            _senderEmail = email;
          });
        },
        itemBuilder: (_) => <PopupMenuItem<String>>[
              PopupMenuItem<String>(
                  value: 'from.jennifer@example.com',
                  child: Text('from.jennifer@example.com',
                      style: Theme.of(context).textTheme.subtitle2)),
              PopupMenuItem<String>(
                  value: 'hey@phantom.works',
                  child: Text('hey@phantom.works',
                      style: Theme.of(context).textTheme.subtitle2))
            ],
        child: Padding(
            padding:
                const EdgeInsets.only(left: 12, top: 16, right: 10, bottom: 10),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(
                  child: Text(_senderEmail,
                      style: Theme.of(context).textTheme.subtitle2)),
              const Icon(Icons.arrow_drop_down,
                  color: AppTheme.lightText, size: 28)
            ])));
  }

  Widget get _recipientRow {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
              child: Wrap(children: [
            Chip(
                label: Text(_recipient,
                    style: Theme.of(context).textTheme.subtitle2),
                backgroundColor: AppTheme.chipBackground,
                padding: EdgeInsets.zero,
                avatar: CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/$_recipientAvatar')))
          ])),
          const Icon(Icons.add_circle_outline, color: AppTheme.lightText)
        ]));
  }

  @override
  Widget build(BuildContext context) {
    final EmailModel emailModel = Provider.of<EmailModel>(context);
    String fabIcon = 'assets/images/ic_edit.png';

    if (emailModel.currentlySelectedEmailId >= 0) {
      fabIcon = 'assets/images/ic_reply.png';
      final Email replyToEmail =
          emailModel.emails[emailModel.currentlySelectedEmailId];
      _subject = replyToEmail.subject;
      _recipient = replyToEmail.sender;
      _recipientAvatar = replyToEmail.avatar;
    }
    return FabFillTransition(
        source: widget.sourceRect,
        icon: fabIcon,
        child: Scaffold(
            body: SafeArea(
                child: Container(
                    height: double.infinity,
                    margin: const EdgeInsets.all(4),
                    color: AppTheme.nearlyWhite,
                    child: Material(
                        color: Colors.white,
                        child: SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                              _subjectRow,
                              _spacer,
                              _senderAddressRow,
                              _spacer,
                              _recipientRow,
                              _spacer,
                              const SizedBox(height: 8),
                              Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: TextField(
                                      minLines: 6,
                                      maxLines: 20,
                                      decoration: InputDecoration.collapsed(
                                          hintText: 'Message'),
                                      autofocus: false,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(fontSize: 14)))
                            ])))))));
  }
}
