import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double value;
  final double percentage;

  ChartBar({
    required this.label,
    required this.value,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      FittedBox(
          child: Text(
              '${value.toStringAsFixed(2)}')), //o FittedBox diminui o tamanho do texto para caber dentro do box
      SizedBox(
        height: 5,
      ),
      Container(
        height: 100,
        width: 10,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1.0),
              color: Color.fromRGBO(220, 220, 220, 1),
              borderRadius: BorderRadius.circular(5),
            )),
            FractionallySizedBox(
                heightFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                ))
          ],
        ),
      ),
      SizedBox(
        height: 5,
      ),
      Text(label)
    ]);
  }
}
