import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  final String fullname;
  final String phone;
  const Home({Key? key, required this.fullname, required this.phone})
      : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  Map<String, Map<String, String>> _localizedStrings = {
    'en': {
      'hi': 'Hi,',
      'where_do': 'Where Do',
      'you_want_to_go': 'You Want To Go?',
      'search_destinations': 'Search Destinations',
      'recommended': 'Recommended',
      'view_all': 'View All',
    },
    'es': {
      'hi': 'Hola,',
      'where_do': 'Dónde',
      'you_want_to_go': 'Quieres Ir?',
      'search_destinations': 'Buscar Destinos',
      'recommended': 'Recomendado',
      'view_all': 'Ver Todo',
    },
  };

  String _selectedLanguage = 'en';

  void _switchLanguage(String languageCode) {
    setState(() {
      _selectedLanguage = languageCode;
    });
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    final startPosition = Offset(1.0, 0.0);
    final endPosition = Offset.zero;

    _animation = Tween<Offset>(
      begin: startPosition,
      end: endPosition,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildTextFormField(
    TextEditingController controller,
    String labelText, {
    int maxLines = 1,
  }) {
    return Container(
      width: 300,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.grey),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
        keyboardType: TextInputType.text,
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $labelText';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(''),
          actions: [
            DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _switchLanguage(newValue);
                }
              },
              items: [
                DropdownMenuItem(
                  value: 'en',
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: 'es',
                  child: Text('Español'),
                ),
              ],
            ),
          ],
        ),
        body: Container(
          color: Colors.black,
          height: size.height,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 70,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        _localizedStrings[_selectedLanguage]!['hi']!,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff737491),
                        ),
                      ),
                      Text(
                        widget.fullname,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffF3C204),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        _localizedStrings[_selectedLanguage]!['where_do']!,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff737491),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        _localizedStrings[_selectedLanguage]![
                            'you_want_to_go']!,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Color(0xff737491),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: 300,
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.blueAccent,
                      ),
                      decoration: InputDecoration(
                        hintText: _localizedStrings[_selectedLanguage]![
                            'search_destinations']!,
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(color: Colors.white, width: 50.0),
                        ),
                        suffixIcon: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.search),
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        _localizedStrings[_selectedLanguage]!['recommended']!,
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            color: Color(0xff737491),
                            fontStyle: FontStyle.normal),
                      ),
                      SizedBox(
                        width: size.width / 3.5,
                      ),
                      InkWell(onTap: () {
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                      child: Text(
                        _localizedStrings[_selectedLanguage]!['view_all']!,
                        style:
                            TextStyle(fontSize: 14, color: Color(0xff737491)),
                      ) ,
                      ),
                     
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('triplocale')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }

                        final locations = snapshot.data!.docs;

                        final filteredLocations = locations.where((doc) {
                          var data = doc.data() as Map<String, dynamic>;
                          String productName = data['productName'] ?? '';
                          return productName
                              .toLowerCase()
                              .contains(_searchQuery);
                        }).toList();

                        if (filteredLocations.isEmpty) {
                          return Center(child: Text('No results found'));
                        }

                        return Row(
                          children: filteredLocations.map((doc) {
                            var data = doc.data() as Map<String, dynamic>;

                            String productName =
                                data['productName'] ?? 'Unknown Location';
                            String productDescription =
                                data['productDescription'] ?? 'No Description';
                            String productImage = data['productImage'][0] ?? '';
                            List<String> productImages =
                                List<String>.from(data['productImage'] ?? []);
                            String price = data['price']?.toString() ?? '0';
                            String vendorId = data['vendorId'] ?? '';
                            String vendorName =
                                data['vendorName'] ?? 'Unknown Vendor';
                            String location = data['location'] ?? 'Unknown';

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LocationDetails(
                                      price: double.parse(price),
                                      productDescription: productDescription,
                                      productImage: productImages,
                                      productName: productName,
                                      vendorId: vendorId,
                                      vendorName: vendorName,
                                      location: location,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 220,
                                width: 300,
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: NetworkImage(productImage),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  alignment: Alignment.bottomLeft,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.7)
                                      ],
                                    ),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        productName,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        '\$$price',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LocationDetails extends StatelessWidget {
  final String productName;
  final String productDescription;
  final List<String> productImage;
  final double price;
  final String vendorId;
  final String vendorName;
  final String location;

  const LocationDetails({
    required this.productName,
    required this.productDescription,
    required this.productImage,
    required this.price,
    required this.vendorId,
    required this.vendorName,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              options: CarouselOptions(height: 400.0),
              items: productImage.map((image) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(color: Colors.amber),
                      child: Image.network(image, fit: BoxFit.cover),
                    );
                  },
                );
              }).toList(),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                productName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                productDescription,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '\$$price',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Vendor: $vendorName',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Location: $location',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
