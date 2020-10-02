import 'package:app_example_reply/home_page.dart';
import 'package:app_example_reply/model/email_model.dart';
import 'package:app_example_reply/styling.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(ReplyApp());

class ReplyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<EmailModel>.value(value: EmailModel())
        ],
        child: MaterialApp(
            title: 'Reply',
            theme: ThemeData(
                scaffoldBackgroundColor: AppTheme.notWhite,
                canvasColor: AppTheme.notWhite,
                accentColor: AppTheme.orange,
                textTheme: AppTheme.textTheme),
            onGenerateRoute: (RouteSettings settings) {
              if (settings.name == '/') {
                return PageRouteBuilder<void>(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        HomePage());
              }
            }));
  }
}
