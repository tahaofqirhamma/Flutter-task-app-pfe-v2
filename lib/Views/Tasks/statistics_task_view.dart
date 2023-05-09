import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_management_app/Constants/Routes.dart';
import 'package:task_management_app/Services/auth/auth_service.dart';
import 'package:task_management_app/Services/cloud/tasks/cloud_storage_constants.dart';
import 'package:task_management_app/Services/cloud/tasks/cloud_task.dart';
import 'package:task_management_app/Utilities/StackedHorizontalBarChart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:task_management_app/Utilities/color_app.dart';

class StatisticsView extends StatefulWidget {
  const StatisticsView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StatisticsViewState createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  final userid = AuthService.firebase().currentUser!.id;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tasks')
          .where(owner, isEqualTo: userid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<CloudTask> tasks = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;

            return CloudTask(
              documentId: doc.id,
              ownerUserid: data[owner],
              taskDesc: data[taskdesc],
              taskTitle: data[tasktitle],
              taskDate: data[taskdate],
              taskStatus: data[taskstatus],
            );
          }).toList();

          final chartData = buildStackedBarChart(tasks);

          final allTasks = tasks.length;
          final canceledTasks =
              tasks.where((task) => task.taskStatus == "canceled").length;
          final completedTasks =
              tasks.where((task) => task.taskStatus == "completed").length;
          final perC = ((completedTasks / allTasks) * 100).toStringAsFixed(0);

          return SingleChildScrollView(
            child: Container(
              height: 1450,
              color: const Color.fromARGB(255, 242, 242, 242),
              child: Column(
                children: [
                  Container(
                    height: 100,
                    color: ColorApp.scndColor,
                    padding: const EdgeInsets.all(0.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                homeRoute, (route) => false);
                          },
                          child: const Text(
                            "<",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 40,
                              color: ColorApp.white,
                            ),
                          ),
                        ),
                        const Text(
                          'Statistics',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 25,
                            color: ColorApp.white,
                            decoration: TextDecoration.none,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 300,
                    padding: const EdgeInsets.all(30),
                    decoration: const BoxDecoration(
                        color: ColorApp.scndColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                        )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              top: 12, bottom: 12, right: 20, left: 20),
                          decoration: const BoxDecoration(
                            color: ColorApp.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Created Tasks",
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: 15,
                                    color: ColorApp.prpColor),
                              ),
                              Text(
                                " $allTasks",
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w900,
                                    color: ColorApp.grey),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 12, bottom: 12, right: 20, left: 20),
                          decoration: const BoxDecoration(
                            color: ColorApp.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Cancelled Tasks',
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: 15,
                                    color: ColorApp.prpColor),
                              ),
                              Text(
                                '$canceledTasks',
                                style: const TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 12, bottom: 12, right: 20, left: 20),
                          decoration: const BoxDecoration(
                            color: ColorApp.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Completd Tasks',
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: 15,
                                    color: ColorApp.prpColor),
                              ),
                              Text(
                                '$completedTasks',
                                style: const TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w900,
                                    color: ColorApp.fthColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  Container(
                    width: 500,
                    height: 250,
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: ColorApp.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          'Percentage of completion',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: ColorApp.prpColor,
                          ),
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 150,
                              width: 150,
                              child: CircularProgressIndicator(
                                value: double.parse(perC) / 100,
                                strokeWidth: 7.0,
                                backgroundColor:
                                    const Color.fromARGB(255, 225, 221, 221),
                                color: double.parse(perC) <= 33
                                    ? Colors.red
                                    : double.parse(perC) < 67
                                        ? Colors.orange
                                        : ColorApp.fthColor,
                              ),
                            ),
                            Text(
                              '$perC%',
                              style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w900,
                                  decoration: TextDecoration.none,
                                  color: double.parse(perC) <= 33
                                      ? Colors.red
                                      : double.parse(perC) < 67
                                          ? Colors.orange
                                          : ColorApp.fthColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 700,
                    color: const Color.fromARGB(255, 242, 242, 242),
                    padding: const EdgeInsets.only(top: 50.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: ColorApp.white,
                            border: Border.all(
                              color: ColorApp.white,
                              width: 1,
                            ),
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30))),
                        child: charts.BarChart(
                          chartData,
                          animate: true,
                          barGroupingType: charts.BarGroupingType.stacked,
                          behaviors: [
                            charts.ChartTitle(
                              'Tasks by Status and Due Date',
                              behaviorPosition: charts.BehaviorPosition.top,
                              titleOutsideJustification:
                                  charts.OutsideJustification.middle,
                              titleStyleSpec: const charts.TextStyleSpec(
                                fontSize: 18,
                                color: charts.MaterialPalette.black,
                              ),
                              titlePadding: 18,
                              subTitle: '',
                            ),
                            charts.SeriesLegend(
                              position: charts.BehaviorPosition.bottom,
                              horizontalFirst: false,
                              cellPadding:
                                  const EdgeInsets.symmetric(horizontal: 0.0),
                              entryTextStyle: const charts.TextStyleSpec(
                                color: charts.Color.black,
                                fontSize: 14,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ],
                          primaryMeasureAxis: charts.NumericAxisSpec(
                            renderSpec: const charts.GridlineRendererSpec(
                              minimumPaddingBetweenLabelsPx: 0,
                              labelJustification:
                                  charts.TickLabelJustification.inside,
                              labelStyle: charts.TextStyleSpec(
                                fontSize: 12,
                                color: charts.Color.black,
                              ),
                              lineStyle: charts.LineStyleSpec(),
                            ),
                            tickProviderSpec:
                                const charts.BasicNumericTickProviderSpec(
                              zeroBound: false,
                              dataIsInWholeNumbers: true,
                            ),
                            // Set the desired range of the axias
                            viewport: charts.NumericExtents(0, tasks.length),
                          ),
                          // Add the categoryAxis property to display the date vertically on the X-axis
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Container(
            color: ColorApp.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
