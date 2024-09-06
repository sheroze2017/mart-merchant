import 'package:flutter/material.dart';

class StatusContainer extends StatelessWidget {
  final String img;
  final String number;
  final String label;
  final Color color;

  StatusContainer(
      {required this.img,
      required this.number,
      required this.label,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1),
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Container(
                  height: 40,
                  child: Image(
                    color: color,
                    fit: BoxFit.cover,
                    image: AssetImage(img),
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(fontSize: 14, color: color),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
