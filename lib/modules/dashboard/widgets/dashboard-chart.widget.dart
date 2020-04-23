import 'dart:math';

/// Donut chart with labels example. This is a simple pie chart with a hole in
/// the middle.
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter/material.dart';

class DashboardChartWidget extends StatelessWidget {
  final bool animate;

  Map<String, double> dataMap;

  DashboardChartWidget(this.dataMap, {this.animate});

  List<Color> colorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
  ];

  /// Creates a [PieChart] with sample data and no transition.
  factory DashboardChartWidget.withSampleData() {
    Random random = new Random();

    Map<String, double> dataMap = new Map();
    dataMap.putIfAbsent("Manopera", () => random.nextDouble() * (1000 - 100) + 100);
    dataMap.putIfAbsent("Piese", () => random.nextDouble() * (2000 - 500) + 500);
    dataMap.putIfAbsent("Itp", () => random.nextDouble() * (200 - 100) + 100);
    dataMap.putIfAbsent("Carburant", () => random.nextDouble() * (400 - 100) + 100);
    dataMap.putIfAbsent("Asigurare", () => random.nextDouble() * (600 - 300) + 300);

    return DashboardChartWidget(dataMap);
  }

  @override
  Widget build(BuildContext context) {
    return PieChart(
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 800),
      chartRadius: MediaQuery.of(context).size.width / 1.2,
      showChartValuesInPercentage: false,
      showChartValues: true,
      showChartValuesOutside: true,
      chartValueBackgroundColor: Colors.grey[200],
      showLegends: true,
      legendPosition: LegendPosition.bottom,
      decimalPlaces: 1,
      showChartValueLabel: true,
      initialAngle: 0,
      chartValueStyle: defaultChartValueStyle.copyWith(
        color: Colors.blueGrey[900].withOpacity(0.9),
      ),
      chartType: ChartType.disc,
    );
  }
}