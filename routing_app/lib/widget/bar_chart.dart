import 'package:flutter/material.dart';

class BarChartWidget extends StatelessWidget {
  final Map<String, double> emissions;
  final bool isLoading;
  final String errorMessage;

  const BarChartWidget({
    required this.emissions,
    this.isLoading = false,
    this.errorMessage = '',
    super.key,
  });

  Color _getEmissionColor(double value) {
    // You can customize these thresholds based on your emissions data
    if (value <= 20) {
      return Colors.green;
    } else if (value <= 40) {
      return Colors.yellow;
    } else if (value <= 60) {
      return Colors.orange;
    } else if (value <= 80) {
      return Colors.red;
    } else {
      return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Text(
        errorMessage,
        style: const TextStyle(color: Colors.red),
      );
    }

    // Find the maximum value for scaling
    final maxValue = emissions.values.reduce((max, value) => max > value ? max : value);
    const maxHeight = 200.0; // Maximum height for bars

    return Container(
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
            height: maxHeight + 50, // Add extra space for labels
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: emissions.entries.map((entry) {
                final barHeight = (entry.value / maxValue) * maxHeight;
                
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      entry.value.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 16,
                      height: barHeight,
                      decoration: BoxDecoration(
                        color: _getEmissionColor(entry.value),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.key,
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
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