import 'package:cloud_firestore/cloud_firestore.dart';
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
  Map<String, Map<String, String>> _localizedStrings = {
    'en': {
      'history': 'History',
      'status': 'The green checkmark indicates the you already \n toured the location,while the yellow icon indicates \nthe recipient is yet to receive.',
      'you_want_to_go': 'You Want To Go?',
      'search_destinations': 'Search Destinations',
      'recommended': 'Recommended',
      'view_all': 'View All',
    },
    'es': {
  'history': 'Historia',
      'status': 'La marca de verificación verde indica que \n ya recorriste la ubicación, mientras que el ícono amarillo indica \nque el destinatario aún no lo ha recibido.',
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
                  padding: EdgeInsets.fromLTRB(30, 50, 0, 0),
                  child: Row(
                    children: [
                      Text(
                   _localizedStrings[_selectedLanguage]!['history']!,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),

                      SizedBox(width: size.width/3,),
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
                  )),
              Padding(
                padding: EdgeInsets.only(top: 2),
                child: Text(
                  _localizedStrings[_selectedLanguage]!['status']!,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              Container(
                height: size.height / 2,
                width: size.width / 1.2,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('orders')
                      .where('drankeeemail', isEqualTo: widget.phone)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final orderDocs = snapshot.data!.docs;

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: orderDocs.length,
                      itemBuilder: (context, index) {
                        final orderData =
                            orderDocs[index].data() as Map<String, dynamic>;

                        final order = Order(
                          amount: orderData["amount"] as String? ?? '',
                          location: 'uk',
                          datecreated:
                              orderData["datecreated"] as String? ?? '',
                          drankeename:
                              orderData["productName"] as String? ?? '',
                          drankeeemail:
                              orderData["email"] as String? ?? '',
                          ordersecret:
                              orderData["ordersecret"] as String? ?? '',
                          drinkname: orderData["drinkname"] as String? ?? '',
                          fullname: orderData["productImage"] as String? ?? '',
                          status: orderData["status"] as String? ?? '',
                        );

                        return Padding(
                          padding: EdgeInsets.fromLTRB(15, 20, 0, 0),
                          child: Container(
                            height: 90,
                            width: 2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(5, 10, 30, 0),
                              child: GestureDetector(
                                onTap: () {
                                  // Navigate to the ClubDrink page with club information
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => ClubDrink(
                                  //       clubname: club.name,

                                  //     ),
                                  //   ),
                                  // );
                                },
                                child: ListTile(
                                  leading: Container(
                                    height: 100,
                                    width: 20,
                                    child:order.status=="Pending"?
                                    
                                    Icon(Icons.history,
                                    color: Colors.yellow[900],
                                    size: 30,
                                    )
:
Icon(Icons.check,
                                    color: Colors.green,
                                    size: 30,
                                    )
                                    // decoration: BoxDecoration(
                                    //   borderRadius: BorderRadius.circular(10.0),
                                    //   image: DecorationImage(
                                    //     image: AssetImage(
                                    //         'assets/vectors/clubi.jpg'),
                                    //     fit: BoxFit.fitHeight,
                                    //   ),
                                    // ),
                                  ),
                                  title: Text(
                                    order.drinkname,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700,
                                        fontSize: 12
                                        ),
                                  ),
                                  subtitle: Padding(
                                    padding: EdgeInsets.only(top: 8),
                                    child: Text(
                                     ' Ticket ID -' + order.ordersecret
                                          
                                        ,
                                        
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  trailing: Column(children: [
                                    Text('\$'+order.amount,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                     
               
                                  ],)
                                  
                                  
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          )),
        ));
  }
}

class Order {
  final String amount;
  final String location;
  final String datecreated;
  final String drankeename;
  final String drankeeemail;
  final String drinkname;
  final String fullname;
  final String status;
  final String ordersecret;

  Order(
      {required this.amount,
      required this.location,
      required this.datecreated,
      required this.drankeename,
      required this.drankeeemail,
      required this.drinkname,
      required this.ordersecret,
      required this.fullname,
      required this.status});
}
