import 'dart:async';
import 'dart:io';
import 'package:Baron/model/user_model.dart';
import 'package:Baron/shared/shared_UI.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

class SouraPage extends StatefulWidget {
  @override
  _SouraPageState createState() => _SouraPageState();
}

class _SouraPageState extends State<SouraPage> {
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  bool _isAvailable = true;
  List<ProductDetails> _products = [];
  StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  void _initialize() async {
    _isAvailable = await _iap.isAvailable();
    if (_isAvailable) {
      await _getProducts();
      _subscription = _iap.purchaseUpdatedStream.listen((data) {
        setState(() {
          if (data[0].status == PurchaseStatus.purchased) {
            var ed = _products.firstWhere(
                (prod) => prod.id == data[0].productID,
                orElse: null);
            print(ed);
          }
        });
      });
    }
  }

  Future<void> _getProducts() async {
    Set<String> ids = Set.from([
      '1_soura',
      '2_soura',
      '3_soura',
      '4_soura',
      '5_soura',
    ]);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    setState(() {
      _products = response.productDetails;
    });
  }

  void buyProduct(ProductDetails prod) async {
    final PurchaseParam param = PurchaseParam(productDetails: prod);
    _iap.buyConsumable(purchaseParam: param, autoConsume: true);
  }

  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<User>(context);
    return Scaffold(
      body: _isAvailable
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/souraPurchase.webp'),
                    fit: BoxFit.cover),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).padding.top + 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        'Soura Purchase',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans'),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            '${userDetails.soura}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans'),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Icon(
                            FontAwesomeIcons.coins,
                            color: Colors.yellowAccent,
                            size: 30,
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 100,
                    child: ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    height: 200,
                                    width: 150,
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                        ),
                                        Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/1.webp'),
                                                fit: BoxFit.contain),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        Text(
                                          '1,000 Soura',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueGrey,
                                              fontFamily: 'OpenSans'),
                                        ),
                                        RaisedButton(
                                          onPressed: () =>
                                              buyProduct(_products[0]),
                                          child: Text(
                                            '${_products[0].price}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'OpenSans'),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    height: 200,
                                    width: 150,
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                        ),
                                        Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/2.webp'),
                                                fit: BoxFit.contain),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        Text(
                                          '5,000 Soura',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueGrey,
                                              fontFamily: 'OpenSans'),
                                        ),
                                        RaisedButton(
                                          onPressed: () =>
                                              buyProduct(_products[1]),
                                          child: Text(
                                            '${_products[1].price}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'OpenSans'),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    height: 200,
                                    width: 150,
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                        ),
                                        Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/3.webp'),
                                                fit: BoxFit.contain),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        Text(
                                          '10,000 Soura',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueGrey,
                                              fontFamily: 'OpenSans'),
                                        ),
                                        RaisedButton(
                                          onPressed: () =>
                                              buyProduct(_products[2]),
                                          child: Text(
                                            '${_products[2].price}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'OpenSans'),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    height: 200,
                                    width: 150,
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                        ),
                                        Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/4.webp'),
                                                fit: BoxFit.contain),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        Text(
                                          '30,000 Soura',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueGrey,
                                              fontFamily: 'OpenSans'),
                                        ),
                                        RaisedButton(
                                          onPressed: () =>
                                              buyProduct(_products[3]),
                                          child: Text(
                                            '${_products[3].price}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'OpenSans'),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    height: 200,
                                    width: 150,
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                        ),
                                        Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/5.webp'),
                                                fit: BoxFit.contain),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        Text(
                                          '200,000 Soura',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueGrey,
                                              fontFamily: 'OpenSans'),
                                        ),
                                        RaisedButton(
                                          onPressed: () =>
                                              buyProduct(_products[4]),
                                          child: Text(
                                            '${_products[4].price}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'OpenSans'),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Text(
                'Purchase not Available',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans'),
              ),
            ),
    );
  }
}
