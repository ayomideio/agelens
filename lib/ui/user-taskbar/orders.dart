
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  final String phone;
  const Orders({super.key, required this.phone});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  String dropdownValue = 'Box';
  List<String> dropdownItems = ['Box', 'Box 2', 'Box 3'];
  List<String> selectedOptions = [];
  List<String> options = [
    'Documents',
    'Glass',
    'Liquid',
    'Food',
    'Electronic',
    'Product',
    'Others'
  ];

  bool isSelected(String option) {
    return selectedOptions.contains(option);
  }

  void toggleSelection(String option) {
    setState(() {
      if (isSelected(option)) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.add(option);
      }
    });
  }

  Widget buildOption(String option) {
    final isSelected = this.isSelected(option);

    return GestureDetector(
      onTap: () => toggleSelection(option),
      child: Container(
        width: 100,
        height: 45,
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.black,
            width: 2,
          ),
        ),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isSelected
                ? Icon(
                    Icons.done,
                    color: Colors.white,
                    size: 15,
                  )
                : SizedBox(),
            Text(
              option,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
Widget _buildFactorLabel(String factorName) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 5),
    child: Text(
      "- $factorName",
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.left,
    ),
  );
}

return Container(
  color: Color(0xff90DDE8).withOpacity(.1),
  child: SingleChildScrollView(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
            child: Row(
              children: [
                Text(
                  "About",
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Welcome to our Medical Readmission Prediction App!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Text(
                  "Our app predicts the likelihood of patient readmission by analyzing key medical and demographic factors:",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 10),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    _buildFactorLabel("All Med Count"),
                    _buildFactorLabel("Time in Hospital"),
                    _buildFactorLabel("Total Num Procedures"),
                    _buildFactorLabel("Diabetes Meds Count"),
                    _buildFactorLabel("Change"),
                    _buildFactorLabel("Num Comorbidity"),
                    _buildFactorLabel("Diabetes Med"),
                    _buildFactorLabel("Number Visit"),
                    _buildFactorLabel("Age"),
                  ],
                ),
                SizedBox(height: 15),
                Text(
                  "By analyzing these factors using advanced machine learning techniques, our app assists healthcare providers in identifying patients at higher risk of readmission, enabling proactive interventions to improve patient outcomes.",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
);

  }
}

class Order {
  final String amount;
  final String userId;
  final String datecreated;

  final String txRef;

  final String status;

  Order(
      {required this.amount,
      required this.userId,
      required this.datecreated,
      required this.txRef,
      required this.status});
}
