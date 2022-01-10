import 'package:flutter/material.dart';
import 'package:flutter_notification/ui/shared/widget/custom_app_bar.dart';
import 'package:flutter_notification/ui/shared/widget/custom_button.dart';
import 'package:flutter_notification/ui/shared/widget/custom_text_form_field.dart';

class FooderAddListScreen extends StatefulWidget {
  static const routeName = '/add-list';
  const FooderAddListScreen({Key? key}) : super(key: key);

  @override
  _FooderAddListScreenState createState() => _FooderAddListScreenState();
}

class _FooderAddListScreenState extends State<FooderAddListScreen> {

  final FocusNode _titleFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    final appbarTheme = Theme.of(context).appBarTheme;
    return Scaffold(
      appBar: screenAppBar(appbarTheme, appTitle: 'New My List'),
      body: Column(
        children: [
          FooderCustomTextFormField(
            labelName: 'Title(e.g., Best Food)',
            focusNode: _titleFocus,
            maxLines: 5,
            textInputAction: TextInputAction.next,
          ),
          FooderCustomTextFormField(
            focusNode: _descriptionFocus,
            labelName: 'Title(e.g., Best Food)',
            maxLines: 5,
            textInputAction: TextInputAction.next,
          ),
          FooderCustomButton(isBorder: false, buttonContent: 'Done', onTap: () {}),
        ],
      ),
    );
  }
}
