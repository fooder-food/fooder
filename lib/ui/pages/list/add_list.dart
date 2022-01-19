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
  String _navTitle = 'New My List';
  String _buttonTitle = 'Done';
  String _updateUniqueId = '';
  @override
  void initState() {
    _addListBloc = BlocProvider.of<AddListBloc>(context);
    Future.delayed(Duration.zero, updateInit);
    super.initState();
  }

  void updateInit() {
    final arg = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String? title = arg["title"];
    final String? description = arg["description"];
    if(title != null && description != null) {
      _titleTextEditingController.text = title;
      _descriptionTextEditingController.text = description;
      setState(() {
        _navTitle = 'Edit Information';
        _buttonTitle = 'Update';
        _updateUniqueId = arg["uniqueId"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appbarTheme = Theme.of(context).appBarTheme;
    return Scaffold(
      appBar: screenAppBar(appbarTheme, appTitle: _navTitle),
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
              labelName: 'Description',
              maxLines: 5,
              textInputAction: TextInputAction.next,
            ),
            BlocConsumer<AddListBloc, AddListState>(
              listener: (context, state) {
                if(state.status == CollectionListStatus.loadSuccess) {
                  _titleTextEditingController.clear();
                  _descriptionTextEditingController.clear();
                  showToast(context: context, msg: 'Add List Successful');
                  Navigator.of(context).pop();
                }
                if(state.status == CollectionListStatus.updateSuccess) {
                  _titleTextEditingController.clear();
                  _descriptionTextEditingController.clear();
                  showToast(context: context, msg: 'Update Successful');
                  Navigator.of(context).pop();
                }
              },
              builder: (context, state) {
                return  FooderCustomButton(isBorder: false, buttonContent: _buttonTitle, onTap: () {
                  if(_updateUniqueId.isNotEmpty) {
                    _addListBloc.add(UpdateList(
                        uniqueId: _updateUniqueId,
                        title: _titleTextEditingController.text,
                        description: _descriptionTextEditingController.text)
                    );
                  } else {
                    _addListBloc.add(AddSingleList(
                      title: _titleTextEditingController.text,
                      description: _descriptionTextEditingController.text,
                    ));
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
