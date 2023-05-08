import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:task_management_app/Services/cloud/tasks/cloud_task.dart';
import 'dart:developer' as devtools;

List<charts.Series<dynamic, String>> buildStackedBarChart(
  Iterable<CloudTask> tasks,
) {
  Map<String, Map<DateTime, int>> data = {};
  final taskStatusOrder = ["canceled", "in progress", "completed"];
  final statusValues = {
    for (var status in taskStatusOrder) status: taskStatusOrder.indexOf(status)
  };
  final sortedTasks = List<CloudTask>.from(tasks)
    ..sort((a, b) {
      final dueDateComparison = DateFormat('dd/MM')
          .parse(a.taskDate)
          .compareTo(DateFormat('dd/MM').parse(b.taskDate));
      if (dueDateComparison != 0) {
        return dueDateComparison;
      } else {
        final aStatusValue = statusValues[a.taskStatus];
        final bStatusValue = statusValues[b.taskStatus];
        return aStatusValue!.compareTo(bStatusValue!);
      }
    });

  for (var task in sortedTasks) {
    devtools.log('${task.taskDate}: ${task.taskStatus}');
  }

  for (var task in sortedTasks) {
    String status = task.taskStatus;
    DateTime dueDate = DateFormat('dd/MM').parse(task.taskDate);
    data[status] ??= {};
    data[status]![dueDate] ??= 0;
    data[status]![dueDate] = (data[status]![dueDate] ?? 0) + 1;
  }

  List<charts.Series<dynamic, String>> seriesList = [];
  data.forEach((status, dateCounts) {
    List<StackedBarChartData> seriesData = [];
    dateCounts.forEach((date, count) {
      seriesData.add(StackedBarChartData(date, count));
    });
    seriesData
        .sort((a, b) => a.date.compareTo(b.date)); // sort the data by date
    seriesList.add(
      charts.Series<dynamic, String>(
        id: status,
        colorFn: (_, __) => getColorByStatus(status),
        data: seriesData,
        domainFn: (dynamic data, _) => DateFormat('dd/MM').format(data.date),
        measureFn: (dynamic data, _) => data.count,
      ),
    );
  });
  return seriesList;
}

class StackedBarChartData {
  final DateTime date;
  final int count;

  StackedBarChartData(this.date, this.count);
}

charts.Color getColorByStatus(String status) {
  switch (status) {
    case 'completed':
      return charts.ColorUtil.fromDartColor(
          const Color(0xFF56BC97)); // set a custom green color
    case 'in progress':
      return charts.ColorUtil.fromDartColor(
          const Color(0xFFFFA500)); // set a custom orange color
    case 'canceled':
      return charts.ColorUtil.fromDartColor(
          const Color(0xFFEE3E4D)); // set a custom red color
    default:
      return charts.ColorUtil.fromDartColor(
          const Color(0xFFC4C4C4)); // set a custom gray color
  }
}
