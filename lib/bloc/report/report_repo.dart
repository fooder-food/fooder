import 'package:flutter_notification/bloc/home/home_api_provider.dart';
import 'package:flutter_notification/bloc/notification/notification_api_provider.dart';
import 'package:flutter_notification/bloc/report/report_api_provider.dart';
import 'package:flutter_notification/model/notification_model.dart';
import 'package:flutter_notification/model/restaurant_model.dart';



class ReportRepo {
  factory ReportRepo() {
    return _instance;
  }

  ReportRepo._constructor();

  static final ReportRepo _instance = ReportRepo._constructor();
  final ReportApiPorivder _reportApiPorivder = ReportApiPorivder();

  Future<void> createReport({
    required String type,
    required String reportType,
    required String content,
    required String target,
  }) async => _reportApiPorivder.sendReport(type: type, reportType: reportType, content: content, target: target);
}