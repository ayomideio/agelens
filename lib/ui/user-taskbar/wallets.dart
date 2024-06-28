import 'package:shared_preferences/shared_preferences.dart';

import 'models/shipments.dart';
import 'package:flutter/material.dart';

class wallets extends StatefulWidget {
  final String selectedTab;

  final fullname;
  final String telephone;
  const wallets(
      {super.key,
      required this.selectedTab,
      required this.fullname,
      required this.telephone});

  @override
  State<wallets> createState() => _walletsState();
}

class _walletsState extends State<wallets> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  List<Shipments> filteredShipments = [];
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _slideAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
    updateFilteredShipments();
  }

  @override
  void didUpdateWidget(wallets oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedTab != oldWidget.selectedTab) {
      _animationController.reset();
      _animationController.forward();
      updateFilteredShipments();
    }
  }

  void updateFilteredShipments() {
    setState(() {
      filteredShipments = sortShipmentsByStatus(widget.selectedTab);
    });
  }

  List<Shipments> sortShipmentsByStatus(String status) {
    List<Shipments> matchedList = [];
    List<Shipments> remainingList = [];

    for (var shipment in shipments_) {
      if (shipment.status == status) {
        matchedList.add(shipment);
      } else {
        remainingList.add(shipment);
      }
    }
    if (!status.isEmpty) {
      return matchedList;
    } else {
      return shipments_;
    }

    // [...matchedList, ...remainingList];
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String selectedStatus = '';
  List<Shipments> shipments_ = [
    Shipments(
        status: 'in-progress',
        title: 'Arriving today!',
        subTitle:
            'Your delivery #NEJ20089934122231 \n from Atlanta, is arriving today!',
        amount: '\$1400 USD',
        deliveryDate: 'Sep 20,2023'),
    Shipments(
        status: 'pending',
        title: 'Arriving today!',
        subTitle:
            'Your delivery #NEJ20089934122231 \n from Atlanta, is arriving today!',
        amount: '\$1400 USD',
        deliveryDate: 'Sep 20,2023'),
    Shipments(
        status: 'pending',
        title: 'Arriving today!',
        subTitle:
            'Your delivery #NEJ20089934122231 \n from Atlanta, is arriving today!',
        amount: '\$1400 USD',
        deliveryDate: 'Sep 20,2023'),
    Shipments(
        status: 'loading',
        title: 'Arriving today!',
        subTitle:
            'Your delivery #NEJ20089934122231 \n from Atlanta, is arriving today!',
        amount: '\$1400 USD',
        deliveryDate: 'Sep 20,2023'),
    Shipments(
        status: 'loading',
        title: 'Arriving today!',
        subTitle:
            'Your delivery #NEJ20089934122231 \n from Atlanta, is arriving today!',
        amount: '\$1400 USD',
        deliveryDate: 'Sep 20,2023'),
    Shipments(
        status: 'in-progress',
        title: 'Arriving today!',
        subTitle:
            'Your delivery #NEJ20089934122231 \n from Atlanta, is arriving today!',
        amount: '\$1400 USD',
        deliveryDate: 'Sep 20,2023'),
    Shipments(
        status: 'in-progress',
        title: 'Arriving today!',
        subTitle:
            'Your delivery #NEJ20089934122231 \n from Atlanta, is arriving today!',
        amount: '\$1400 USD',
        deliveryDate: 'Sep 20,2023'),
  ];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(_slideAnimation),
      child: Container(
        height: size.height,
        color: Color(0xffFBFAF),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Text(
                      "My Profile",
                      style: TextStyle(
                        color: Color(0xff00094B),
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 50),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(widget.telephone),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 50),
                      child: Text(
                        widget.fullname,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 2),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 50),
                      child: Text(
                        '',
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(top: 40),
              //   child: Row(
              //     children: [
              //       Padding(
              //         padding: EdgeInsets.only(left: 30),
              //         child: CircleAvatar(
              //           backgroundColor: Color(0xff90DDE8).withOpacity(.1),
              //           radius: 20,
              //           child: Center(child: Icon(Icons.edit_outlined)),
              //         ),
              //       ),
              //       Container(
              //         // height: 50,
              //         width: size.width / 1.5,
              //         child: Padding(
              //           padding: EdgeInsets.only(left: 10),
              //           child: Text('Edit Profile'),
              //         ),
              //       ),
              //       Text(
              //         '>',
              //         style: TextStyle(fontSize: 25),
              //       ),
              //     ],
              //   ),
              // ),

              // Padding(
              //   padding: EdgeInsets.only(top: 20),
              //   child: Row(
              //     children: [
              //       Padding(
              //         padding: EdgeInsets.only(left: 30),
              //         child: CircleAvatar(
              //           backgroundColor: Color(0xff90DDE8).withOpacity(.1),
              //           radius: 20,
              //           child: Center(
              //             child: Icon(
              //               Icons.lock,
              //             ),
              //           ),
              //         ),
              //       ),
              //       Container(
              //         // height: 50,
              //         width: size.width / 1.5,
              //         child: Padding(
              //           padding: EdgeInsets.only(left: 10),
              //           child: Text('Change Password'),
              //         ),
              //       ),
              //       Text(
              //         '>',
              //         style: TextStyle(fontSize: 25),
              //       ),
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.only(top: 20),
              //   child: Row(
              //     children: [
              //       Padding(
              //         padding: EdgeInsets.only(left: 30),
              //         child: CircleAvatar(
              //           backgroundColor: Color(0xff90DDE8).withOpacity(.1),
              //           radius: 20,
              //           child: Center(
              //             child: Icon(
              //               Icons.location_on,
              //             ),
              //           ),
              //         ),
              //       ),
              //       Container(
              //         // height: 50,
              //         width: size.width / 1.5,
              //         child: Padding(
              //           padding: EdgeInsets.only(left: 10),
              //           child: Text('Change Location'),
              //         ),
              //       ),
              //       Text(
              //         '>',
              //         style: TextStyle(fontSize: 25),
              //       ),
              //     ],
              //   ),
              // ),

              GestureDetector(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.clear();
                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (buildContext) => ContdPhone()));
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: CircleAvatar(
                          backgroundColor: Color(0xff90DDE8).withOpacity(.1),
                          radius: 20,
                          child: Center(
                            child: Icon(
                              Icons.logout,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        // height: 50,
                        width: size.width / 1.5,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text('Log Out'),
                        ),
                      ),
                      Text(
                        '>',
                        style: TextStyle(fontSize: 25),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
