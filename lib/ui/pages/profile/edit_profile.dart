import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notification/bloc/profile/profile_repo.dart';
import 'package:flutter_notification/core/service/storage/storage_service.dart';
import 'package:flutter_notification/model/auth_model.dart';
import 'package:flutter_notification/model/providers/user_model.dart';
import 'package:flutter_notification/model/user_model.dart';
import 'package:flutter_notification/ui/shared/widget/avatar.dart';
import 'package:flutter_notification/ui/shared/widget/custom_app_bar.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter_notification/ui/shared/widget/custom_text_form_field.dart';
import 'package:flutter_notification/ui/shared/widget/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FooderEditProfileScreen extends StatefulWidget {
  static const String routeName = '/edit-profile';

  const FooderEditProfileScreen({Key? key}) : super(key: key);

  @override
  State<FooderEditProfileScreen> createState() => _FooderEditProfileScreenState();
}

class _FooderEditProfileScreenState extends State<FooderEditProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  late final TextEditingController _emailController;
  late final TextEditingController _usernameController;
  late final TextEditingController _phoneController;
  final ProfileRepo _profileRepo = ProfileRepo();
  XFile? _tempAvatar;

  @override
  void initState() {
   _emailController = TextEditingController();
   _usernameController = TextEditingController();
   _phoneController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.clear();
    _emailController.clear();
    _phoneController.clear();
    super.dispose();
  }

  void  _showActionSheet(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    showAdaptiveActionSheet(
      context: context,
      title: Text('Select Action', style: textTheme.subtitle1,),
      actions: <BottomSheetAction>[
        BottomSheetAction(
            leading: Container(
              padding: const EdgeInsets.only(right: 10),
              child: const Icon(Icons.camera, color: Colors.grey,),
            ),
            title: Text('Camera', style: textTheme.subtitle1,),
            onPressed: () {
              _getImageFromCamera();
            }
        ),
        BottomSheetAction(
            leading: Container(
              padding: const EdgeInsets.only(right: 10),
              child: const Icon(Icons.drive_folder_upload_rounded, color: Colors.grey,),
            ),
            title: Text('Upload From Device', style: textTheme.subtitle1,),
            onPressed: () {
              _getImageFromGallery();
            }
        ),
      ],
    );
  }

  void _getImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if(image != null) {
      setState(() {
        //_tempAvatar = File(image.path.toString());
        _tempAvatar = image;
      });
      Navigator.of(context).pop();
    }
  }

  void _getImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if(image != null) {
      setState(() {
       // _tempAvatar = File(image.path.toString());
        _tempAvatar = image;
      });
      Navigator.of(context).pop();
    }
  }

  Future customShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => discardDialog(context)
    );
  }

  Future<bool> _onWillPop() async {
    if(_tempAvatar != null) {
      final shouldPop =  await customShowDialog(context);
      return shouldPop;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final appbarTheme = Theme.of(context).appBarTheme;
    final User? user = context.select((AuthModel auth) => auth.user!.user);
    if(user != null) {
      _emailController.text = user.email;
      _usernameController.text = user.username;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: screenAppBar(
          appbarTheme,
          appTitle: 'Edit Personal Info',
          onPopCallback: () async {
            if(_tempAvatar != null) {
              final isBack = await customShowDialog(context);
              if(isBack) {
                Navigator.of(context).pop();
              }
              return;
            }
            return Navigator.of(context).pop();
          },
          actions: [
            IconButton(
              onPressed: () async {
                try {
                  final updateUser = await _profileRepo.updateInfo(
                    email: _emailController.text,
                    phone: _phoneController.text,
                    username: _usernameController.text,
                    avatar: _tempAvatar,
                  );
                  context.read<AuthModel>().updateUser(updateUser);
                  showToast(
                      msg: 'update details successful',
                      context: context,
                      backgroundColor: Colors.green
                  );

                  Auth auth = context.read<AuthModel>().user!;
                  String encoded = jsonEncode(auth.toJson());
                  StorageService().setStr("user", encoded);
                } catch(e) {
                  print(e);
                  showToast(
                      msg: 'update details Errors',
                      context: context,
                      backgroundColor: Colors.red,
                  );
                }
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.check_rounded,
                color: Colors.black,
              )
            )
          ]
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _profileAvatar(context),
                _profileInfoSection(context),
              ],
            ),
          ),
        )
      ),
    );
  }

  Widget _profileAvatar(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        width: 150,
        height: 150,
        child: Stack(
          children: [
            Consumer<AuthModel>(
              builder: (_, authModel, __) {
                final user = authModel.user!.user!;
                if(_tempAvatar != null) {
                  return ClipOval(
                    child: Container(
                      child: Image.file(
                        File(_tempAvatar!.path.toString()),
                        fit: BoxFit.cover,
                        width: 150,
                        height: 150,
                      ),
                    ),
                  );
                }

                return fooderAvatar(
                  user: user,
                );
              }
            ),
            Positioned(
              right: 10,
              bottom: 5,
              child: Material(
                shape: const CircleBorder(),
                child: Ink(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {
                      _showActionSheet(context);
                    },
                    child: const Icon(Icons.add, color: Colors.white,),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _profileInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Details',
          style:Theme.of(context).textTheme.subtitle2!.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        FooderCustomTextFormField(
          labelName: 'Email',
          textEditingController: _emailController,

        ),
        FooderCustomTextFormField(
          labelName: 'Username',
          textEditingController: _usernameController,
        ),
        FooderCustomTextFormField(labelName: 'Phone',),
      ],
    );
  }

  Widget discardDialog(BuildContext context) {
    return AlertDialog(
      content: const Text('Did you want discard your image?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text('yes'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('No'),
        ),
      ],
    );
  }
}
