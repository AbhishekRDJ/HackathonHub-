import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BarChartWidget extends StatelessWidget {
  final Map<String, double> emissions;

  BarChartWidget({required this.emissions});

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barGroups = emissions.entries
        .map((entry) => BarChartGroupData(
              x: emissions.keys.toList().indexOf(entry.key),
              barRods: [
                BarChartRodData(
                  toY: entry.value, // No `fromY` in the latest version
                  color: Colors.blue, // Use `color` instead of `colors`
                  width: 16,
                )
              ],
            ))
        .toList();

    return Container(
      height: 400,
      padding: EdgeInsets.all(20),
      child: BarChart(
        BarChartData(
          barGroups: barGroups,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toString(),
                    style: TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < emissions.keys.length) {
                    return Text(
                      emissions.keys.elementAt(value.toInt()),
                      style: TextStyle(fontSize: 10),
                    );
                  }
                  return Text('');
                },
              ),
            ),
          ),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: true),
          barTouchData: BarTouchData(enabled: true),
        ),
      ),
    );
  }
}
