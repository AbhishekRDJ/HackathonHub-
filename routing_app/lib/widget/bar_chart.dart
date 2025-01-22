import 'package:flutter/material.dart';

class BarChartWidget extends StatelessWidget {
  final Map<String, double> emissions;
  final bool isLoading;
  final String errorMessage;

  BarChartWidget({
    required this.emissions,
    this.isLoading = false,
    this.errorMessage = '',
    super.key,
  });

  // Define ranges for each emission type
  final Map<String, Map<String, double>> _emissionRanges = {
    'CO2_emissions': {'min': 50, 'max': 500},
    'NOx_Emission': {'min': 0.1, 'max': 2},
    'PM2.5_Emissions': {'min': 0.01, 'max': 0.19},
    'VOC_Emissions': {'min': 0.01, 'max': 0.1},
    'SO2_Emissions': {'min': 0.01, 'max': 0.1},
  };

  Color _getEmissionColor(String type, double value) {
    final range = _emissionRanges[type];
    if (range == null) return Colors.blue;

    final normalizedValue =
        (value - range['min']!) / (range['max']! - range['min']!);

    if (normalizedValue <= 0.3) {
      return Colors.lightGreen;
    } else if (normalizedValue <= 0.5) {
      return Colors.yellow;
    } else if (normalizedValue <= 0.7) {
      return Colors.orange;
    }  else {
      return Colors.red;
    }
  }

  double _calculateBarHeight(String type, double value, double maxHeight) {
    final range = _emissionRanges[type];
    if (range == null) return maxHeight;

    // Calculate percentage within its own range
    double percentage =
        (value - range['min']!) / (range['max']! - range['min']!);
    // Ensure the percentage is between 0 and 1
    percentage = percentage.clamp(0.0, 1.0);

    return percentage * maxHeight;
  }

  String _formatValue(double value) {
    if (value >= 100) {
      return value.toStringAsFixed(0);
    } else if (value >= 1) {
      return value.toStringAsFixed(1);
    } else {
      return value.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (errorMessage.isNotEmpty) {
      return Text(
        errorMessage,
        style: const TextStyle(color: Colors.red),
      );
    }

    const maxHeight = 200.0; // Maximum height for bars

    return isLoading == true
        ? const Center(child: CircularProgressIndicator())
        : Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Emissions Bar Chart',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: maxHeight + 50,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: emissions.entries.map((entry) {
                      final barHeight = _calculateBarHeight(
                          entry.key, entry.value, maxHeight);

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            _formatValue(entry.value),
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 16,
                            height: barHeight,
                            decoration: BoxDecoration(
                              color: _getEmissionColor(entry.key, entry.value),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            entry.key.split(
                                '_')[0], // Show only the first part of the name
                            style: const TextStyle(
                                fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
  }
}
