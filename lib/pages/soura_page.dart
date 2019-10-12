import 'dart:async';
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
  List<PurchaseDetails> _purchases = [];
  StreamSubscription _subscription;

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
      _verifyPurchase();
      _subscription = _iap.purchaseUpdatedStream.listen(
        (data) => setState(() {
          _purchases.addAll(data);
        }),
      );
    }
  }

  Future<void> _getProducts() async {
    Set<String> ids = Set.from(['elements']);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    setState(() {
      _products = response.productDetails;
    });
  }

  PurchaseDetails _hasPurchased(String productId) {
    return _purchases.firstWhere((purchase) => purchase.productID == productId,
        orElse: () => null);
  }

  void _verifyPurchase() {
    PurchaseDetails purchase = _hasPurchased('');
    if (purchase != null && purchase.status == PurchaseStatus.purchased) {}
  }

  void buyProduct(ProductDetails prod) {
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
                  ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Card(
                                child: Container(
                                  height: 200,
                                  width: 150,
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        // '${_products[0].title}',
                                        'Price',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        // '${_products[0].price}',
                                        '500',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      RaisedButton(
                                        onPressed: () =>
                                            buyProduct(_products[0]),
                                        child: Text(
                                          'Buy Now',
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
                                child: Container(
                                  height: 200,
                                  width: 150,
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        // '${_products[0].title}',
                                        'Price',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        // '${_products[0].price}',
                                        '500',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      RaisedButton(
                                        onPressed: () =>
                                            buyProduct(_products[0]),
                                        child: Text(
                                          'Buy Now',
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
                          )
                        ],
                      ),
                    ),
                  )
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
