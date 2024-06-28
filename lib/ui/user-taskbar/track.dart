import 'models/products.dart';
import 'package:flutter/material.dart';

class Track extends StatefulWidget {
  final String shippingNumber;
  const Track({super.key, required this.shippingNumber});

  @override
  State<Track> createState() => _TrackState();
}

class _TrackState extends State<Track>  with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  final List<Products> productList = [
    Products(
        productName: 'Macbook pro M2',
        shippingNumber: '#NE43857340857904',
        location: ' • Paris -> Morocco'),
    Products(
        productName: 'Summer linen jacket',
        shippingNumber: '#NEJ20089934122231',
        location: ' • Barcelona -> Paris'),
    Products(
        productName: 'Tapered-fit jeans AW',
        shippingNumber: '#NEJ35870264978659',
        location: ' • Colombia -> Paris'),
    Products(
        productName: 'Slim fit jeans AW',
        shippingNumber: '#NEJ35870264978659',
        location: ' • Bogota -> Dhaka'),
    Products(
        productName: 'Office setup desk',
        shippingNumber: '#NEJ23481570754963',
        location: ' • France -> German'),
   
  ];
List<Products> sortedProductList = [];

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
    sortedProductList = sortProductsByShippingNumber(widget.shippingNumber);
  }
 @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  @override
  void didUpdateWidget(Track oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.shippingNumber != widget.shippingNumber) {
       _animationController.reset();
      _animationController.forward();
      sortedProductList = sortProductsByShippingNumber(widget.shippingNumber);

    }
  }

  List<Products> sortProductsByShippingNumber(String shippingNumber) {
    List<Products> matchedList = [];
    List<Products> remainingList = [];

    for (var product in productList) {
      if (product.shippingNumber.contains(shippingNumber)) {
        matchedList.add(product);
      } else {
        remainingList.add(product);
      }
    }

    return [...matchedList, ...remainingList];
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(_slideAnimation),
      child:
    Container(
      color: Color(0xffFBFAF),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
           
          ],
        ),
      ),
    ),);
  }
}
