import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:readmitpredictor/ui/constants/index.dart';
import 'package:readmitpredictor/ui/user-taskbar/wallets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class LocationDetails2 extends StatefulWidget {
  final String vendorName, vendorId, productName, productDescription, location;
  final double price;
  final List<String> productImage;
  const LocationDetails2(
      {super.key,
      required this.vendorName,
      required this.vendorId,
      required this.productName,
      required this.productDescription,
      required this.productImage,
      required this.price,
      required this.location});

  @override
  State<LocationDetails2> createState() => _LocationDetails2State();
}

class _LocationDetails2State extends State<LocationDetails2> {
  List<Map<String, dynamic>> cart = [];
  int _quantity = 1;
  int _currentPage = 0;
  double _totalPrice = 0.0;

  void _updateTotalPrice() {
    _totalPrice = widget.price * _quantity;
  }

  void _increaseQuantity() {
    setState(() {
      _quantity++;
      _updateTotalPrice();
    });
  }

  void _decreaseQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        _updateTotalPrice();
      });
    }
  }

  Future<List<Map<String, dynamic>>> _addToCart() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('user');

    SharedPreferences pref = await SharedPreferences.getInstance();
    String _email = pref.getString('email').toString();
  var uuid = Uuid();
    Map<String, dynamic> updatedData = {
      'trips': FieldValue.arrayUnion([
        {
          'vendorName': widget.vendorName,
          'vendorId': widget.vendorId,
          'productName': widget.productName,
          'productDescription': widget.productDescription,
          'productImage': widget.productImage,
          'price': _totalPrice>0?_totalPrice: widget.price,
          'quantity': _quantity,
          'orderId': uuid.v4()
        }
      ]),
    };

    try {
      // Update the document
      await collection.doc(_email).update(updatedData);
      print('Document updated successfully!');
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Wallets(
                selectedTab: '0',
                fullname: widget.vendorName,
                telephone: 'telephone',
                emil: _email)),
      );
    } catch (e) {
      print('Error updating document: $e');
    }
    return (cart); // Just for debugging, you can remove this
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index
            ? Colors.white
            : Colors.white.withOpacity(0.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Color(0xff737491),
        child: Stack(
          children: [
            // Container(
            //   height: size.height / 2.1,
            //   decoration: BoxDecoration(
            //     color: Color(0xffe8f4f8),
            //     image: DecorationImage(
            //       image: AssetImage('assets/vectors/imag2.jpg'),
            //       fit: BoxFit.fill,
            //     ),
            //   ),
            // ),

            Container(
              height: size.height / 2.1,
              child: PageView.builder(
                itemCount: widget.productImage.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Image.network(
                    widget.productImage[index],
                    fit: BoxFit.cover,
                    width: size.width,
                  );
                },
              ),
            ),
            Positioned(
              bottom: 500,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.productImage.length,
                    (index) => buildDot(index, context)),
              ),
            ),

            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Container(
                  height:
                      size.height / 1.8, // 20% of the image container's height
                  decoration: BoxDecoration(
                    color: Colors
                        .black, // Optional: add some transparency if needed
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
                              child: Text(
                                widget.productName,
                                style: TextStyle(
                                    color: Color(0xff737491),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(30, 40, 0, 0),
                              child: Container(
                                width: size.width / 2.8,
                                child: Text(
                                  "\$${_totalPrice > 0 ? _totalPrice : widget.price}",
                                  style: TextStyle(
                                      color: Color(0xff737491),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                              child: Icon(
                                Icons.location_on,
                                color: Color(0xff737491),
                                size: 20,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text(
                                widget.location,
                                style: TextStyle(
                                    color: Color(0xff737491),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 20,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 20,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 20,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 20,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 20,
                                    ),
                                  ],
                                )),
                            Padding(
                              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: Text(
                                '4.5',
                                style: TextStyle(
                                    color: Color(0xff737491),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.fromLTRB(40, 30, 0, 0),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: _decreaseQuantity,
                                      child: CustomPaint(
                                        size: Size(20, 20),
                                        painter: LinePainter(),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      '$_quantity',
                                      style: TextStyle(
                                          color: Color(0xff737491),
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    GestureDetector(
                                      onTap: _increaseQuantity,
                                      child: Text(
                                        '+',
                                        style: TextStyle(
                                            color: Color(0xff737491),
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Image.asset(
                                      'assets/vectors/stopwatch.png',
                                      height: 40,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      '$_quantity Days',
                                      style: TextStyle(
                                          color: Color(0xff737491),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
                              child: Text(
                                'Description',
                                style: TextStyle(
                                    color: Color(0xff737491),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 05, 0, 0),
                              child: Container(
                                width: size.width / 1.1,
                                child: Text(
                                  widget.productDescription,
                                  style: TextStyle(
                                      color: Color(0xff737491),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                              child: GestureDetector(
                                  onTap: () async {
                                    print('yes');
                                    _addToCart();
                                    // prefs.setBool('isLoggedIn', true);
                                  },
                                  child: Container(
                                    width: size.width / 1.1,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Color(0xff964B00),
                                    ),
                                    child: Center(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.favorite,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Add to WishList",
                                          style: TextStyle(
                                              color: ColorStyles.screenColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )),
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                    // Optional: add some transparency if needed
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xff737491) // Set the color of the line
      ..strokeWidth = 3; // Set the thickness of the line

    // Draw a line from top-left to bottom-right
    canvas.drawLine(
      Offset(0, size.height / 2), // Starting point (left-center)
      Offset(size.width, size.height / 2), // Ending point (right-center)
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
