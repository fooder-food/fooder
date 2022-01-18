import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notification/bloc/add-list/add_list_bloc.dart';
import 'package:flutter_notification/ui/shared/widget/custom_app_bar.dart';
import 'package:flutter_notification/ui/shared/widget/custom_button.dart';
import 'package:flutter_notification/ui/shared/widget/custom_text_form_field.dart';
import 'package:flutter_notification/ui/shared/widget/toast.dart';

class FooderAddListScreen extends StatefulWidget {
  static const routeName = '/add-list';
  const FooderAddListScreen({Key? key}) : super(key: key);

  @override
  _FooderAddListScreenState createState() => _FooderAddListScreenState();
}

class _FooderAddListScreenState extends State<FooderAddListScreen> {
  late AddListBloc _addListBloc;
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final TextEditingController _titleTextEditingController = TextEditingController();
  final TextEditingController _descriptionTextEditingController = TextEditingController();
  @override
  void initState() {
    _addListBloc = BlocProvider.of<AddListBloc>(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final appbarTheme = Theme.of(context).appBarTheme;
    return Scaffold(
      appBar: screenAppBar(appbarTheme, appTitle: 'New My List'),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            FooderCustomTextFormField(
              labelName: 'Title(e.g., Best Food)',
              textEditingController: _titleTextEditingController,
              focusNode: _titleFocus,
              maxLines: 5,
              textInputAction: TextInputAction.next,
            ),
            FooderCustomTextFormField(
              textEditingController: _descriptionTextEditingController,
              focusNode: _descriptionFocus,
              labelName: 'Title(e.g., Best Food)',
              maxLines: 5,
              textInputAction: TextInputAction.next,
            ),
            BlocConsumer<AddListBloc, AddListState>(
              listener: (context, state) {
                if(state.status == CollectionListStatus.loadSuccess) {
                  _titleTextEditingController.text = "";
                  _descriptionTextEditingController.text = "";
                  showToast(context: context, msg: 'Add List Successful');
                  Navigator.of(context).pop();
                }
              },
              builder: (context, state) {
                return  FooderCustomButton(isBorder: false, buttonContent: 'Done', onTap: () {
                  _addListBloc.add(AddSingleList(
                    title: _titleTextEditingController.text,
                    description: _descriptionTextEditingController.text,
                  ));
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
