import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:transit_station/constants/colors.dart';

class ProfitBarChart extends StatelessWidget {
  const ProfitBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.yellow, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profit',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Days',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 30,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10,
                      getTitlesWidget: (value, meta) {
                        return Text('${value.toInt()}K', style: const TextStyle(fontSize: 12));
                      },
                      reservedSize: 28,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 0:
                            return const Text('Sun');
                          case 1:
                            return const Text('Mon');
                          case 2:
                            return const Text('Tue');
                          case 3:
                            return const Text('Wed');
                          case 4:
                            return const Text('Thu');
                          case 5:
                            return const Text('Fri');
                          case 6:
                            return const Text('Sat');
                          default:
                            return const Text('');
                        }
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                barGroups: _buildBarGroups(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return [
      _makeGroupData(0, 25, 20),
      _makeGroupData(1, 30, 15),
      _makeGroupData(2, 20, 30),
      _makeGroupData(3, 15, 20),
      _makeGroupData(4, 25, 10),
      _makeGroupData(5, 10, 15),
      _makeGroupData(6, 20, 25),
    ];
  }

  BarChartGroupData _makeGroupData(int x, double blueValue, double yellowValue) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: blueValue,
          color: defaultColor,
          width: 12,
          borderRadius: BorderRadius.circular(0),
        ),
        BarChartRodData(
          toY: yellowValue,
          color: yellowColor,
          width: 12,
          borderRadius: BorderRadius.circular(0),
        ),
      ],
      barsSpace: 4,
    );
  }
}
