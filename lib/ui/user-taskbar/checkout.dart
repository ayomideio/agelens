import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Checkout extends StatefulWidget {
  final Set<String> items;
  const Checkout({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  Set<String> selectedItems = Set<String>(); // Track selected item IDs

  // Add TextEditingController for each form field
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController stateController = TextEditingController();

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
        .doc('test@gmail.com')
        .get();

    if (docSnapshot.exists) {
      List cart = docSnapshot['cart'];
      cart.removeWhere((item) => item['orderId'] == orderId);

      await FirebaseFirestore.instance
          .collection('user')
          .doc('test@gmail.com')
          .update({'cart': cart});
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    address1Controller.dispose();
    address2Controller.dispose();
    stateController.dispose();
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
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
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
                padding: EdgeInsets.fromLTRB(30, 30, 0, 0),
                child: Row(
                  children: [
                    Text(
                      "Delivery Address",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),
              buildFormField("Full Name", fullNameController, size),
              buildFormField("Email Address", emailController, size),
              buildFormField("Phone", phoneController, size),
              buildFormField("Delivery Address 1", address1Controller, size),
              buildFormField("Delivery Address 2", address2Controller, size),
              buildFormField("State", stateController, size),
              InkWell(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => OrderSummary(
                  //       items: selectedItems,
                  //       fullName: fullNameController.text,
                  //       email: emailController.text,
                  //       phone: phoneController.text,
                  //       address1: address1Controller.text,
                  //       address2: address2Controller.text,
                  //       state: stateController.text,
                  //     ),
                  //   ),
                  // );
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 35, 0, 5),
                  child: Container(
                    width: size.width / 1.15,
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Color(0xffD8541B),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Proceed',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )),
        ),
      ),
    );
  }

  Widget buildFormField(
      String label, TextEditingController controller, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(5, 20, 0, 0),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 5),
        Container(
          width: size.width / 1.1,
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: Color(0xff9CA3AF)),
            color: Colors.transparent,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
