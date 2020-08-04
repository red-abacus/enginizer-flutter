import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class GroupedStackedWeightPatternBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  GroupedStackedWeightPatternBarChart(this.seriesList, {this.animate});

  factory GroupedStackedWeightPatternBarChart.withSampleData() {
    return new GroupedStackedWeightPatternBarChart(
      createSampleData(),
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      defaultRenderer: new charts.BarRendererConfig(
        groupingType: charts.BarGroupingType.stacked,
        weightPattern: [2, 1],
      ),
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<OrdinalSales, String>> createSampleData() {
    final desktopSalesDataA = [
      new OrdinalSales('1', 8, charts.Color.fromHex(code: '#c5a1a1')),
      new OrdinalSales('1', 16, charts.Color.fromHex(code: '#e0e1e2')),
    ];

    final tableSalesDataA = [
      new OrdinalSales('2', 10, charts.Color.fromHex(code: '#c5a1a1')),
      new OrdinalSales('2', 15, charts.Color.fromHex(code: '#e0e1e2')),
    ];

    final mobileSalesDataA = [
      new OrdinalSales('3', 30, charts.Color.fromHex(code: '#c5a1a1')),
      new OrdinalSales('3', 10, charts.Color.fromHex(code: '#e0e1e2')),
    ];

    final desktopSalesDataB = [
      new OrdinalSales('4', 15, charts.Color.fromHex(code: '#c5a1a1')),
      new OrdinalSales('4', 20, charts.Color.fromHex(code: '#e0e1e2')),
    ];

    final tableSalesDataB = [
      new OrdinalSales('5', 5, charts.Color.fromHex(code: '#c5a1a1')),
      new OrdinalSales('5', 15, charts.Color.fromHex(code: '#e0e1e2')),
    ];

    final mobileSalesDataB = [
      new OrdinalSales('6', 5, charts.Color.fromHex(code: '#c5a1a1')),
      new OrdinalSales('6', 30, charts.Color.fromHex(code: '#e0e1e2')),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        colorFn: (OrdinalSales sales, __) {
          return sales.color;
        },
        id: 'Desktop A',
        seriesCategory: 'A',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: desktopSalesDataA,
      ),
      new charts.Series<OrdinalSales, String>(
        colorFn: (OrdinalSales sales, __) {
          return sales.color;
        },
        id: 'Tablet A',
        seriesCategory: 'A',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: tableSalesDataA,
      ),
      new charts.Series<OrdinalSales, String>(
        colorFn: (OrdinalSales sales, __) {
          return sales.color;
        },
        id: 'Mobile A',
        seriesCategory: 'A',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: mobileSalesDataA,
      ),
      new charts.Series<OrdinalSales, String>(
        colorFn: (OrdinalSales sales, __) {
          return sales.color;
        },
        id: 'Desktop B',
        seriesCategory: 'B',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: desktopSalesDataB,
      ),
      new charts.Series<OrdinalSales, String>(
        colorFn: (OrdinalSales sales, __) {
          return sales.color;
        },
        id: 'Tablet B',
        seriesCategory: 'B',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: tableSalesDataB,
      ),
      new charts.Series<OrdinalSales, String>(
        colorFn: (OrdinalSales sales, __) {
          return sales.color;
        },
        id: 'Mobile B',
        seriesCategory: 'B',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: mobileSalesDataB,
      ),
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;
  final charts.Color color;

  OrdinalSales(this.year, this.sales, this.color);
}
