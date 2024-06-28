
import 'package:flutter/material.dart';

class ClubOrder extends StatefulWidget {
  final String phone;
  const ClubOrder({super.key, required this.phone});

  @override
  State<ClubOrder> createState() => _ClubOrderState();
}

class _ClubOrderState extends State<ClubOrder> {
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
                        "Orders",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(top: 2),
                child: Text(
                  "The green checkmark indicates the recipients already \n received their drink,while the yellow icon indicates \nthe recipient is yet to receive.",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              ],
          )),
        ));
  }
}

class Order {
  final String amount;
  final String club;
  final String datecreated;
  final String drankeename;
  final String drankeeemail;
  final String drinkname;
  final String fullname;
  final String status;
  final String ordersecret;

  Order(
      {required this.amount,
      required this.club,
      required this.datecreated,
      required this.drankeename,
      required this.drankeeemail,
      required this.drinkname,
      required this.ordersecret,
      required this.fullname,
      required this.status});
}
