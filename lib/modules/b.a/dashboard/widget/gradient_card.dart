import 'package:ba_merchandise/common/style/color.dart';
import 'package:flutter/material.dart';

class GradientCard extends StatelessWidget {
  final String img;
  final String number;
  final String label;

  GradientCard({
    required this.img,
    required this.number,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColor, Colors.blue.shade100],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 30,
                    child: Image(
                      fit: BoxFit.cover,
                      image: AssetImage(img),
                    ),
                  ),
                  Text(
                    label,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
              Text(
                number,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
