import 'package:flutter/material.dart';
import 'package:flutter_notification/model/providers/user_model.dart';
import 'package:flutter_notification/ui/pages/profile/init_items.dart';
import 'package:flutter_notification/ui/shared/widget/custom_app_bar.dart';
import 'package:provider/provider.dart';

class FooderProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';
  const FooderProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appbarTheme = Theme.of(context).appBarTheme;
    return Scaffold(
      appBar: screenAppBar(appbarTheme, appTitle: ''),
      body: Consumer<AuthModel>(
        builder:(_, auth, __) {
          if(auth.user == null) {
            Future(() =>
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false)
            );
            return Container();
          }
          return _profileContent(context);
        } ,
      ),
    );
  }

  Widget _profileContent(BuildContext context) {
    return Column(
      children: [
        _accountSection(context),
      ],
    );
  }

  Widget _accountSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Text(
              'Account',
              style: textTheme.headline2,
            ),
          ),
          ...profileSelectionList.map((selection) => _profileSelectTab(context, selection)),
        ],
      ),
    );
  }

  Widget _profileSelectTab(BuildContext context, Map<String, dynamic> selection) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
       final routeName = selection["to"].toString();
       print(routeName);
        Navigator.of(context).pushNamed(routeName);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    selection["name"].toString(),
                    style: textTheme.subtitle1!.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 20,)
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(color: Colors.grey,),
          ],
        ),
      ),
    );
  }
}
