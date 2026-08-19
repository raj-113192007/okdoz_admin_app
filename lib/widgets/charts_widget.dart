import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SalesChartCard extends StatelessWidget {
  const SalesChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Sales Overview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: const [
                    Text('This Week', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF64748B)),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          // Legend
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildLegendItem('Restaurant', Colors.orange),
              _buildLegendItem('Grocery', Colors.green),
              _buildLegendItem('Pharmacy', Colors.blue),
              _buildLegendItem('Pickup & Courier', Colors.amber),
              _buildLegendItem('Electronics Service', Colors.grey.shade700),
            ],
          ),
          const SizedBox(height: 24),
          // Chart
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 600;
                final fontSize = isMobile ? 10.0 : 12.0;
                final style = TextStyle(color: const Color(0xFF94A3B8), fontSize: fontSize);
                
                return LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 5,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(color: Colors.grey.shade200, strokeWidth: 1);
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            Widget text;
                            switch (value.toInt()) {
                              case 0: text = Text('18 May', style: style); break;
                              case 1: text = Text('19 May', style: style); break;
                              case 2: text = Text('20 May', style: style); break;
                              case 3: text = Text('21 May', style: style); break;
                              case 4: text = Text('22 May', style: style); break;
                              case 5: text = Text('23 May', style: style); break;
                              case 6: text = Text('24 May', style: style); break;
                              default: text = Text('', style: style); break;
                            }
                            return SideTitleWidget(
                              meta: meta,
                              space: 4,
                              child: text,
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 5,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()}L',
                              style: style,
                            );
                          },
                          reservedSize: isMobile ? 32 : 42,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: 6,
                minY: 0,
                maxY: 20,
                lineBarsData: [
                  _createLineData(Colors.orange, [12, 10, 15, 13, 16, 14, 18]), // Restaurant
                  _createLineData(Colors.green, [8, 7, 9, 8, 10, 9, 12]), // Grocery
                  _createLineData(Colors.blue, [5, 4, 6, 5, 7, 6, 8]), // Pharmacy
                  _createLineData(Colors.amber, [3, 2, 4, 3, 5, 4, 5]), // Pickup
                  _createLineData(Colors.grey.shade700, [1, 1, 2, 1, 2, 2, 3]), // Electronics
                ],
              ),
            );
          },
        ),
      ),
    ],
  ),
);
}

  LineChartBarData _createLineData(Color color, List<double> values) {
    return LineChartBarData(
      spots: values.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
      isCurved: true,
      color: color,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true, getDotPainter: (spot, percent, barData, index) {
        return FlDotCirclePainter(radius: 3, color: Colors.white, strokeWidth: 1.5, strokeColor: color);
      }),
      belowBarData: BarAreaData(show: false),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 8, height: 2, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
      ],
    );
  }
}

class SectorChartCard extends StatelessWidget {
  const SectorChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 1100;

    return Container(
      height: isMobile ? 550 : 350,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Top Performing Sectors', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: const [
                    Text('This Month', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF64748B)),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: isMobile
                ? Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            PieChart(
                              PieChartData(
                                sectionsSpace: 0,
                                centerSpaceRadius: 50,
                                startDegreeOffset: -90,
                                sections: [
                                  PieChartSectionData(color: Colors.orange, value: 44, title: '', radius: 30),
                                  PieChartSectionData(color: Colors.green, value: 24, title: '', radius: 30),
                                  PieChartSectionData(color: Colors.blue, value: 16, title: '', radius: 30),
                                  PieChartSectionData(color: Colors.amber, value: 10, title: '', radius: 30),
                                  PieChartSectionData(color: Colors.grey.shade700, value: 6, title: '', radius: 30),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text('Total Revenue', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                                Text('₹ 25,75,430', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSectorLegend('Restaurant', '44%', '₹ 12,45,320', Colors.orange),
                            _buildSectorLegend('Grocery', '24%', '₹ 6,75,450', Colors.green),
                            _buildSectorLegend('Pharmacy', '16%', '₹ 5,35,400', Colors.blue),
                            _buildSectorLegend('Pickup & Courier', '10%', '₹ 2,15,670', Colors.amber),
                            _buildSectorLegend('Electronics Service', '6%', '₹ 1,13,700', Colors.grey.shade700),
                          ],
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            PieChart(
                              PieChartData(
                                sectionsSpace: 0,
                                centerSpaceRadius: 45,
                                startDegreeOffset: -90,
                                sections: [
                                  PieChartSectionData(color: Colors.orange, value: 44, title: '', radius: 28),
                                  PieChartSectionData(color: Colors.green, value: 24, title: '', radius: 28),
                                  PieChartSectionData(color: Colors.blue, value: 16, title: '', radius: 28),
                                  PieChartSectionData(color: Colors.amber, value: 10, title: '', radius: 28),
                                  PieChartSectionData(color: Colors.grey.shade700, value: 6, title: '', radius: 28),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text('Total Revenue', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                                Text('₹ 25.75L', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSectorLegend('Restaurant', '44%', '₹ 12,45,320', Colors.orange),
                            _buildSectorLegend('Grocery', '24%', '₹ 6,75,450', Colors.green),
                            _buildSectorLegend('Pharmacy', '16%', '₹ 5,35,400', Colors.blue),
                            _buildSectorLegend('Pickup & Courier', '10%', '₹ 2,15,670', Colors.amber),
                            _buildSectorLegend('Electronics Service', '6%', '₹ 1,13,700', Colors.grey.shade700),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectorLegend(String label, String percentage, String amount, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            percentage,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          const SizedBox(width: 8),
          Text(
            amount,
            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}
