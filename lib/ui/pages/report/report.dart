import 'package:flutter/material.dart';
import 'package:flutter_notification/bloc/report/report_repo.dart';
import 'package:flutter_notification/ui/shared/widget/custom_app_bar.dart';
import 'package:flutter_notification/ui/shared/widget/custom_button.dart';
import 'package:flutter_notification/ui/shared/widget/custom_text_form_field.dart';
import 'package:flutter_notification/ui/shared/widget/toast.dart';

import 'init.dart';

class FooderReportScreen extends StatefulWidget {
  static const routeName = '/report';
  const FooderReportScreen({Key? key}) : super(key: key);

  @override
  _FooderReportScreenState createState() => _FooderReportScreenState();
}

class _FooderReportScreenState extends State<FooderReportScreen> {
  int? selectReport;
  String uniqueId = '';
  final TextEditingController _textController = TextEditingController();
  final ReportRepo _reportRepo = ReportRepo();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, initReport);
  }

  void initReport() {
    final arg = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
     setState(() {
       uniqueId = arg["uniqueId"];
     });
  }
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
                try {
                  if(selectReport != null) {
                    final report = reportSelection.firstWhere((element) => element["id"] == selectReport);
                    await _reportRepo.createReport(
                      type: 'restaurant',
                      reportType: report["title"],
                      content: _textController.text,
                      target: uniqueId,
                    );
                  }
                  showToast(msg: 'Report success, admin will handle as soon as posible', context: context);
                  Navigator.of(context).pop();
                } catch(e) {
                  showToast(msg: 'unknown error', context: context);
                }
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
              textEditingController: _textController,
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
