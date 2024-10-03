import 'package:flutter/material.dart';
import 'package:interactive_chart/interactive_chart.dart';


class FullScreenChartPage extends StatelessWidget {
  final List<CandleData> stockPrices;

  FullScreenChartPage({required this.stockPrices});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full Screen Stock Chart'),
      ),
      body: InteractiveChart(
        candles: stockPrices,
        style: ChartStyle(),
      ),
    );
  }
}
