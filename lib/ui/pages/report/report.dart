import 'package:flutter/material.dart';
import 'package:flutter_notification/ui/shared/widget/custom_app_bar.dart';
import 'package:flutter_notification/ui/shared/widget/custom_text_form_field.dart';

import 'init.dart';

class FooderReportScreen extends StatefulWidget {
  static const routeName = '/report';
  const FooderReportScreen({Key? key}) : super(key: key);

  @override
  _FooderReportScreenState createState() => _FooderReportScreenState();
}

class _FooderReportScreenState extends State<FooderReportScreen> {
  int? selectReport;
  @override
  Widget build(BuildContext context) {
    final appbarTheme = Theme.of(context).appBarTheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: screenAppBar(
        appbarTheme,
        appTitle: 'Request to Edit Information',
        actions: [
          IconButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.check_rounded,
                color: Colors.grey[600],
              )
          ),
        ]
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Text('Detail',
              style:textTheme.subtitle1!.copyWith(
                fontWeight: FontWeight.w400,
              ) ,
            ),
            for(var report in reportSelection)
              checboxTile(report),
            FooderCustomTextFormField(
              labelName: '',
              readonly: selectReport == null,
              placeholderName: '(Optional) if you want to provide us with more informaion. please press here',
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget checboxTile(Map<String, dynamic> report) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        CheckboxListTile(
          title: Text(report["title"] as String,
            style: textTheme.subtitle2!.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
          ),
          value: selectReport == report["id"],
          onChanged: (bool? value) {
            setState(() {
              selectReport = report['id'];
            });
          },
        ),
        const Divider(),
      ],
    );
  }
}
