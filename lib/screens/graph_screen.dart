import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:math_expressions/math_expressions.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  final TextEditingController controller = TextEditingController();
  List<FlSpot> points = [];

  double minX = -10, maxX = 10;
  double minY = -10, maxY = 10;

  void plotFunction() {
    String input = controller.text.trim();

    if (input.isEmpty) return;

    try {
      Parser p = Parser();
      Expression exp = p.parse(input);
      ContextModel cm = ContextModel();

      List<FlSpot> newPoints = [];
      double tempMinY = double.infinity;
      double tempMaxY = double.negativeInfinity;

      for (double x = -10; x <= 10; x += 0.1) {
        cm.bindVariable(Variable("x"), Number(x));
        double y = exp.evaluate(EvaluationType.REAL, cm);

        if (y.isFinite) {
          newPoints.add(FlSpot(x, y));

          if (y < tempMinY) tempMinY = y;
          if (y > tempMaxY) tempMaxY = y;
        }
      }

      setState(() {
        points = newPoints;
        minY = tempMinY - 2;
        maxY = tempMaxY + 2;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi biểu thức: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Graph Plotting"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Nhập hàm f(x): sin(x), x^2, x*3+1, ...",
                labelStyle: const TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.black54,
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: plotFunction,
              child: const Text("Vẽ đồ thị"),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),

                child: LineChart(
                  LineChartData(
                    minX: minX,
                    maxX: maxX,
                    minY: minY,
                    maxY: maxY,

                    gridData: FlGridData(
                      drawVerticalLine: true,
                      drawHorizontalLine: true,
                      getDrawingHorizontalLine: (_) => FlLine(
                        color: Colors.grey.withOpacity(0.3),
                        strokeWidth: 1,
                      ),
                      getDrawingVerticalLine: (_) => FlLine(
                        color: Colors.grey.withOpacity(0.3),
                        strokeWidth: 1,
                      ),
                    ),

                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),

                    lineBarsData: [
                      LineChartBarData(
                        spots: points,
                        isCurved: true,
                        color: Colors.red,
                        barWidth: 1.3, // ⭐ đường mảnh hơn
                        dotData: FlDotData(show: false),
                      ),
                    ],

                    // Trục OX & OY
                    extraLinesData: ExtraLinesData(
                      horizontalLines: [
                        HorizontalLine(
                          y: 0,
                          color: Colors.black,
                          strokeWidth: 1.5,
                        ),
                      ],
                      verticalLines: [
                        VerticalLine(
                          x: 0,
                          color: Colors.black,
                          strokeWidth: 1.5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
