import 'package:app_example_reply/transition/scale_out_transition.dart';
import 'package:app_example_reply/ui/list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/email_model.dart';

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<EmailModel>(builder: (context, model, child) {
      return ScaleOutTransition(
          child: Material(
              child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: ListView.builder(
                      itemCount: model.emails.length,
                      itemBuilder: (context, position) {
                        return ListItem(
                            id: position,
                            email: model.emails[position],
                            onDeleted: () => model.deleteEmail(position));
                      }))));
    });
  }
}
