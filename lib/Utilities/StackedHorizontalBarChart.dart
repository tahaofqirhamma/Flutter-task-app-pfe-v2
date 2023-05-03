import 'dart:ui';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:task_management_app/Services/cloud/tasks/cloud_storage_constants.dart';
import 'package:task_management_app/Services/cloud/tasks/cloud_task.dart';

List<charts.Series<StackedBarChartData, String>> buildStackedBarChart(
    Iterable<CloudTask> tasks) {
  // Group tasks by status and due date
  Map<String, Map<String, int>> data = {};
  for (var task in tasks) {
    String status = task.taskStatus;
    String dueDate = task.taskDate;
    data[status] ??= {};
    data[status]![dueDate] ??= 0;
    data[status]![dueDate] = (data[status]![dueDate] ?? 0) + 1;
  }

  // Build data series for each status
  /// This code is building a list of `charts.Series` objects, which will be used to create a stacked bar
  /// chart.
  List<charts.Series<StackedBarChartData, String>> seriesList = [];
  data.forEach((status, dateCounts) {
    List<StackedBarChartData> seriesData = [];
    dateCounts.forEach((date, count) {
      seriesData.add(StackedBarChartData(date, count));
    });
    seriesList.add(
      charts.Series<StackedBarChartData, String>(
        id: status,
        colorFn: (_, __) => getColorByStatus(status),
        data: seriesData,
        domainFn: (StackedBarChartData data, _) => data.date.substring(0, 5),
        measureFn: (StackedBarChartData data, _) => data.count,
      ),
    );
  });

  return seriesList;
}

class StackedBarChartData {
  final String date;
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
