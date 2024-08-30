import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterwave_standard/core/flutterwave.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:readmitpredictor/ui/constants/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:readmitpredictor/ui/user-taskbar/orders.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:readmitpredictor/ui/user-taskbar/checkout.dart';

class Wallets extends StatefulWidget {
  final String selectedTab;
  final String fullname;
  final String telephone;
  final String emil;
  const Wallets(
      {Key? key,
      required this.selectedTab,
      required this.fullname,
      required this.telephone,
      required this.emil})
      : super(key: key);

  @override
  _WalletsState createState() => _WalletsState();
}

class _WalletsState extends State<Wallets> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  bool isLoading=false;
  Set<String> selectedItems = Set<String>();
  List selectedi = [];
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Track selected item IDs

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _slideAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  Future<void> deleteCartItem(String orderId) async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.emil)
        .get();

    if (docSnapshot.exists) {
      List cart = docSnapshot['trips'];
      cart.removeWhere((item) => item['orderId'] == orderId);

      await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.emil)
          .update({'trips': cart});
    }
  }

  // Future<List<Map<String, dynamic>>> orderIte(cartItem) async {
  //   print("locy"+selectedi.toString());
  //   CollectionReference collection =
  //       FirebaseFirestore.instance.collection('user');

  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   String _email = pref.getString('email').toString();
  //   var locit = selectedi[0]['price'];

  //   Map<String, dynamic> updatedData = {
  //     'trips': FieldValue.arrayUnion([
  //       {
  //         'amount': locit,
  //         // 'location': selectedi[0]['location'] + 'jhjj',
  //         // 'datecreated': FieldValue.serverTimestamp(),
  //         // 'drankeename': selectedi[0]['email'] + '',
  //         // 'drankeeemail': selectedi[0]['email'] + '',
  //         // 'ordersecret': selectedi[0]['orderId'] + '',
  //         // 'drinkname': selectedi[0]['productName'] + '',
  //         // 'fullname': selectedi[0]['productName'] + '',
  //         // 'status': 'Pending',
  //       }
  //     ]),
  //   };

  //   try {
  //     // Update the document
  //     await collection.doc(_email).update(updatedData);
  //     print('Document updated successfully!');
  //   } catch (e) {
  //     print('Error updating document: $e');
  //   }
  //   return []; // Just for debugging, you can remove this
  // }

  Future<void> orderIte(cartItem) async {
    print('Selected items: $selectedItems');
    print('Selected orders: ${selectedi[0]['price']}');
    DateTime now = DateTime.now();

    // Extract the day, month, and year
    String day = now.day.toString().padLeft(2, '0');
    String month = now.month.toString().padLeft(2, '0');
    String year = now.year.toString();

    // Format the date as DD-MM-YYYY
    String formattedDate = '$day-$month-$year';
    await _firestore.collection('orders').doc().set({
      'amount': '${selectedi[0]['price']}',
      // 'location': selectedi[0]['location'] + '',
      'datecreated': formattedDate,
      'drankeename': widget.emil + '',
      'drankeeemail': widget.emil + '',
      'ordersecret': selectedi[0]['orderId'] + '',
      'drinkname': selectedi[0]['productName'] + '',
      'fullname': selectedi[0]['productName'] + '',
      'status': 'Pending',
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(_slideAnimation),
        child: Container(
          height: size.height,
          color: Colors.white,
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('user')
                .doc(widget.emil)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Container(
                  height: size.height,
                  width: size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Image.asset(
                        'assets/vectors/emptycart.png',
                        height: 300,
                      ),
                      Text(
                        'Your Wishlist is Empty',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )
                    ],
                  ),
                );
              }

              List cartItems = snapshot.data!['trips'];

              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 50, 0, 20),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/vectors/vector.png',
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(30, 20, 0, 20),
                      child: Row(
                        children: [
                          Text(
                            "Wishlist",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (cartItems.length > 0)
                      ...cartItems.map((item) {
                        bool isSelected = selectedItems.contains(
                            item['orderId']); // Check if item is selected
                        return Padding(
                          padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 70),
                                child: Checkbox(
                                  value: isSelected,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value!) {
                                        selectedi.add(item);
                                        selectedItems.add(item[
                                            'orderId']); // Add item to selected items
                                      } else {
                                        selectedItems.remove(item[
                                            'orderId']); // Remove item from selected items
                                      }
                                    });
                                  },
                                ),
                              ),
                              Container(
                                height: 120,
                                width: size.width / 3.5,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(item['productImage'][0]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    item['vendorName'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '\$${item['price']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '${item['quantity']} Day(s)',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Color(0xffDA8015),
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        '5.0',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        '2 Reviews',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Expanded(child: SizedBox()),
                              Column(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      deleteCartItem(item['orderId']);
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                                    child: Icon(Icons.more_vert),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    if (cartItems.length < 1)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Image.asset(
                            'assets/vectors/emptycart.png',
                            height: 300,
                          ),
                          Text(
                            'Your Wishlist is Empty',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          )
                        ],
                      ),

                    // Add UI for selected items or further actions here
                    if (selectedItems.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(20),
                        color: Colors.grey.withOpacity(0.2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${selectedItems.length} items selected',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            isLoading ? CircularProgressIndicator():
                            ElevatedButton(
                              onPressed: () async {
                                print("selected items  ${selectedItems}");
                                // Handle action for selected items (e.g., proceed to checkout)
                                // final Customer customer = Customer(
                                //     name: "Flutterwave Developer",
                                //     phoneNumber: "1234566677777",
                                //     email: "customer@customer.com");
                                // final Flutterwave flutterwave = Flutterwave(
                                //     context: context,
                                //     publicKey: "FLWPUBK_TEST-38c151bd4006168353f90aa25ffd52dd-X",
                                //     currency: "USD",
                                //     redirectUrl: "./",
                                //     txRef: "${selectedItems.first}",
                                //     amount: "3000",
                                //     customer: customer,
                                //     customization: Customization(title: "My Payment"),
                                //     paymentOptions:
                                //         "card",
                                //     isTestMode: true);

                                setState((){
                                  isLoading=true;
                                });
                                 final Customer customer = Customer(email: widget.emil);

    final Flutterwave flutterwave = await Flutterwave(
        context: context,
        publicKey: 'FLWPUBK_TEST-38c151bd4006168353f90aa25ffd52dd-X',
        currency: 'USD',
        redirectUrl: 'https://facebook.com',
        txRef: "${selectedItems.first}",
        amount:'500',
        customer: customer,
        paymentOptions: "card",
        customization: Customization(title: "Payment"),
        isTestMode: true);
    final ChargeResponse response = await flutterwave.charge();
    // this.showLoading(response.toString());
    
    print("${response.toJson()}");
    if (response != null && response.status == "success") {
    print("Payment was successful: ${response.toJson()}");

    // Proceed with deleting the cart item
    deleteCartItem(selectedItems.first);
 setState((){
                                  isLoading=false;
                                });
                                
    // Proceed with ordering the item
    await orderIte(cartItems);
Navigator.pop(context);
  } else {
    print("Payment failed or was canceled: ${response?.toJson()}");
    setState((){
                                  isLoading=false;
                                });
                                Navigator.pop(context);
    // Handle failure or cancellation
    // You can show a message to the user or take other appropriate actions
  }
                                
                                // deleteCartItem(selectedItems.first);
                                // await orderIte(cartItems);
                                //        amount: orderData["amount"] as String? ?? '',
                                // location: orderData["location"] as String? ?? '',
                                // datecreated:
                                //     orderData["datecreated"] as String? ?? '',
                                // drankeename:
                                //     orderData["productName"] as String? ?? '',
                                // drankeeemail:
                                //     orderData["email"] as String? ?? '',
                                // ordersecret:
                                //     orderData["orderId"] as String? ?? '',
                                // drinkname: orderData["productName"] as String? ?? '',
                                // fullname: orderData["productImage"] as String? ?? '',
                                // status: orderData["status"] as String? ?? '',

                              },
                              child: Text('Proceed to Checkout'),
                            ),
                          ],
                        ),
                      ),
                    // Padding(
                    //   padding: EdgeInsets.fromLTRB(0, 150, 0, 0),
                    //   child: Container(
                    //     height: 200,
                    //     width: size.width / 1.2,
                    //     decoration: BoxDecoration(color: Color(0xffF6F6F6)),
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Row(
                    //           children: [
                    //             Expanded(
                    //               child: Padding(
                    //                 padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    //                 child: Text(
                    //                   'Total: ${cartItems.length} items',
                    //                   style: TextStyle(
                    //                       fontWeight: FontWeight.bold,
                    //                       fontSize: 20),
                    //                 ),
                    //               ),
                    //             ),
                    //             Text(
                    //               '#0.00',
                    //               style: TextStyle(
                    //                   decoration: TextDecoration.lineThrough,
                    //                   decorationColor: Color(
                    //                       0xff6B6B6B), // Change the color here
                    //                   decorationThickness: 2,
                    //                   color: Color(0xffBDBEBF),
                    //                   fontSize: 16),
                    //             ),
                    //             SizedBox(
                    //               width: 20,
                    //             ),
                    //           ],
                    //         ),
                    //         SizedBox(
                    //           height: 5,
                    //         ),
                    //         Row(
                    //           children: [
                    //             Expanded(
                    //               child: Padding(
                    //                 padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    //                 child: Text(
                    //                   '10% Discount',
                    //                   style: TextStyle(
                    //                     color: Color(0xffBDBEBF),
                    //                     fontWeight: FontWeight.bold,
                    //                     fontSize: 16,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //             Text(
                    //               '#0.00',
                    //               style: TextStyle(
                    //                   fontWeight: FontWeight.bold,
                    //                   fontSize: 18),
                    //             ),
                    //             SizedBox(
                    //               width: 20,
                    //             ),
                    //           ],
                    //         ),
                    //         InkWell(
                    //           onTap: () async {},
                    //           child: Padding(
                    //             padding: EdgeInsets.fromLTRB(0, 30, 0, 5),
                    //             child: Container(
                    //               width: size.width / 1.5,
                    //               height: 60,
                    //               padding:
                    //                   EdgeInsets.symmetric(horizontal: 12.0),
                    //               decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(12.0),
                    //                 color: Color(0xffD8541B),
                    //               ),
                    //               child: Row(
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.center,
                    //                   children: [
                    //                     Text(
                    //                       'Next',
                    //                       style: TextStyle(
                    //                           fontSize: 16,
                    //                           color: Colors.white,
                    //                           fontWeight: FontWeight.bold),
                    //                     ),
                    //                   ]),
                    //             ),
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
