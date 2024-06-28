import 'package:flutter/material.dart';

class VendorScreen extends StatefulWidget {
  const VendorScreen({super.key});

  @override
  State<VendorScreen> createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: Center(
        child: Container(
          color: Color(0xffFFFFFF),
          height: size.height,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/vectors/vector.png'),
              Text('Vendor Category'),
              Text('ALl events vendors and services'),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Row(
                  children: [
                    Container(
                      width: size.width / 1.4,
                      height: 45,
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Color(0xffEEEEEE)),
                        color: Color(0xffEEEEEE),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Image.asset(
                              'assets/vectors/search.png',
                              height: 24,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 6),
                              child: TextField(
                                // obscureText: _obscureText,
                                decoration: InputDecoration(
                                    hintText: 'Catering, decoration etc',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(fontSize: 12)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Image.asset(
                      'assets/vectors/filter.png',
                      height: 36,
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
                    child: Text(
                      'Set location',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(90, 20, 0, 0),
                    child: Container(
                      width: size.width / 2.6,
                      height: 48,
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Color(0xffEEEEEE)),
                        color: Color(0xffEEEEEE),
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(5, 0, 20, 0),
                              child: Image.asset(
                                'assets/vectors/location.png',
                                height: 15,
                              ),
                            ),
                            Text(
                              'Lagos',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                              child: Image.asset(
                                'assets/vectors/arrowup.png',
                                height: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: GridView.count(
                  crossAxisCount: 2, // 2 items per row
                  shrinkWrap: true,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  physics: NeverScrollableScrollPhysics(), // Disable scrolling
                  children: [
                    buildVendorItem(size, 'FOOD VENDOR'),
                    buildVendorItem(size, 'EVENTS DECORATION'),
                    buildVendorItem(size, 'DEE-JAY'),
                    buildVendorItem(size, 'RENTAL'),
                    buildVendorItem(size, 'PHOTOGRAPHER'),
                    buildVendorItem(size, 'BAKERS'),
                    // Add more items if needed
                    // buildVendorItem('EM-CEE'),
                    // buildVendorItem('LIVE BAND'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildVendorItem(size, String itemName) {
    return Container(
      height: 50, // Adjust height as needed
      width: size.width / 3, // Adjust width as needed
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xffF7F4F4),
      ),
      // Add your content for each item here
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset(
          'assets/vectors/catering.png',
          height: 30,
        ),
        // SizedBox(
        //   height: 10,
        // ),
        Text(
          '$itemName',
          style: TextStyle(fontSize: 16),
        ),
      ]),
    );
  }
}
