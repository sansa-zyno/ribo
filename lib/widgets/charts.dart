/*import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  String txt1;
  String txt2;
  IconData icon;
  List<FlSpot> list;
  Color clr;
  Chart(this.txt1,this.txt2,this.icon,this.list,this.clr) ;

  static const _dateTextStyle = TextStyle(
    fontSize: 10,
    color: Colors.purple,
    fontWeight: FontWeight.bold,
  );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Jan';
        break;
      case 1:
        text = 'Feb';
        break;
      case 2:
        text = 'Mar';
        break;
      case 3:
        text = 'Apr';
        break;
      case 4:
        text = 'May';
        break;
      case 5:
        text = 'Jun';
        break;
      case 6:
        text = 'Jul';
        break;
      case 7:
        text = 'Aug';
        break;
      case 8:
        text = 'Sep';
        break;
      case 9:
        text = 'Oct';
        break;
      case 10:
        text = 'Nov';
        break;
      case 11:
        text = 'Dec';
        break;
      default:
        return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: _dateTextStyle),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.black, fontSize: 12.0);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text('\$ ${value + 0.5}', style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(2, 2))
            ]),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("$txt1"),
                        SizedBox(
                          height: 10,
                        ),
                        Text("$txt2")
                      ],
                    ),
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Icon(icon))
                  ],
                ),
              ),
              Expanded(
                child: LineChart(
                  LineChartData(
                    //lineTouchData: LineTouchData(enabled: false),
                    borderData: FlBorderData(
                        show: false,
                        border: Border.all(style: BorderStyle.none)),
                    lineBarsData: [
                      LineChartBarData(
                        spots: list,
                        isCurved: true,
                        barWidth: 3,
                        color: clr,
                        /*belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.deepPurple.withOpacity(0.4),
                                  cutOffY: cutOffYValue,
                                  applyCutOffY: true,
                                ),*/
                        /*aboveBarData: BarAreaData(
                                  show: true,
                                  color: Colors.orange.withOpacity(0.6),
                                  cutOffY: cutOffYValue,
                                  applyCutOffY: true,
                                ),*/
                        dotData: FlDotData(
                          show: false,
                        ),
                      ),
                    ],
                    minY: 0,
                    titlesData: FlTitlesData(
                      show: false,
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        axisNameWidget: const Text(
                          '2019',
                          style: _dateTextStyle,
                        ),
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 18,
                          interval: 1,
                          getTitlesWidget: bottomTitleWidgets,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        axisNameSize: 20,
                        axisNameWidget: const Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text('Value'),
                        ),
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          reservedSize: 40,
                          getTitlesWidget: leftTitleWidgets,
                        ),
                      ),
                    ),
                    gridData: FlGridData(
                      show: false,
                      drawVerticalLine: false,
                      horizontalInterval: 1,
                      checkToShowHorizontalLine: (double value) {
                        return value == 1 ||
                            value == 6 ||
                            value == 4 ||
                            value == 5;
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
