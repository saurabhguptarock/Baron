import 'package:Baron/model/user_model.dart';
import 'package:Baron/pages/soura_page.dart';
import 'package:Baron/shared/shared_UI.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Baron/services/firebase_service.dart' as firebaseService;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CollectiblesPage extends StatefulWidget {
  @override
  _CollectiblesPageState createState() => _CollectiblesPageState();
}

class _CollectiblesPageState extends State<CollectiblesPage> {
  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<User>(context);
    final collectibles = Provider.of<List<Collectible>>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Color.fromRGBO(23, 31, 42, 1),
        title: Text(
          'Collectibles',
          style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: Container(
          color: Color.fromRGBO(23, 31, 42, 1),
          child: ListView.builder(
            itemCount: collectibles.length,
            itemBuilder: (ctx, i) =>
                collectibleCard(collectibles[i], userDetails),
          ),
        ),
      ),
    );
  }

  int collectiblePrice(Collectible collectible) {
    if (int.parse(collectible.quality) == 1)
      return 250;
    else if (int.parse(collectible.quality) == 2)
      return 400;
    else if (int.parse(collectible.quality) == 3)
      return 500;
    else if (int.parse(collectible.quality) == 4) return 650;
    return 800;
  }

  showError(String errorMessage, User user) {
    showDialog(
      context: context,
      builder: (ctx) => RichAlertDialog(
        alertTitle: Text(
          errorMessage,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
          ),
        ),
        alertType: RichAlertType.ERROR,
        actions: <Widget>[
          RaisedButton(
            color: Colors.redAccent,
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
          RaisedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) {
                  return StreamProvider<User>.value(
                    initialData: User.fromMap({}),
                    value: firebaseService.streamUser(user.uid),
                    child: SouraPage(),
                  );
                }),
              );
            },
            color: Colors.green,
            child: Text(
              'Ok',
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  buyCollectible(Collectible collectible, User userDetails, int price) {
    firebaseService.buyCollectible(collectible, userDetails, price);
    showDialog(
      context: context,
      builder: (ctx) => RichAlertDialog(
        alertTitle: Text(
          'Thanks for purchasing',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
          ),
        ),
        alertType: RichAlertType.SUCCESS,
      ),
    );
  }

  Widget collectibleCard(Collectible collectible, User userDetails) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (ctx) => Container(
            color: Color.fromRGBO(11, 14, 19, 1),
            height: 180,
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(27, 36, 48, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: collectible.img,
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        backgroundColor: Color.fromRGBO(27, 36, 48, 1),
                        radius: 15,
                        child: Image(
                          image: imageProvider,
                        ),
                      ),
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey,
                        highlightColor: Colors.white,
                        child: CircleAvatar(
                          radius: 15,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    onTap: () {
                      if (int.parse(collectible.quality) >= 4 &&
                          (userDetails.badge == 'Roar' ||
                              userDetails.tyre == 'Royal')) {
                      } else {
                        if (userDetails.soura > collectiblePrice(collectible)) {
                          buyCollectible(collectible, userDetails,
                              collectiblePrice(collectible));
                        } else {
                          showError(
                              "You don't have enough Soura. Please buy more.",
                              userDetails);
                        }
                      }
                    },
                    title: Text(
                      'Buy this item (${collectiblePrice(collectible)})',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color.fromRGBO(27, 36, 48, 1),
                      radius: 15,
                      child: Icon(
                        FontAwesomeIcons.coins,
                        color: Colors.yellowAccent,
                      ),
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) {
                        return StreamProvider<User>.value(
                          initialData: User.fromMap({}),
                          value: firebaseService.streamUser(userDetails.uid),
                          child: SouraPage(),
                        );
                      }),
                    ),
                    title: Text(
                      'Buy Soura',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color.fromRGBO(27, 36, 48, 1),
                      radius: 15,
                      child: Icon(
                        Icons.cancel,
                        color: Colors.red,
                        size: 28,
                      ),
                    ),
                    onTap: () => Navigator.of(context).pop(),
                    title: Text(
                      'Cancel',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Color.fromRGBO(27, 36, 48, 1),
          elevation: 10,
          child: Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(27, 36, 48, 1),
                borderRadius: BorderRadius.circular(20)),
            height: 90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: CachedNetworkImage(
                    imageUrl: collectible.img,
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      backgroundColor: Color.fromRGBO(27, 36, 48, 1),
                      radius: 45,
                      child: Image(
                        image: imageProvider,
                      ),
                    ),
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey,
                      highlightColor: Colors.white,
                      child: CircleAvatar(
                        radius: 45,
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        collectible.name,
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Quality : ${collectible.quality}',
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            color: Colors.white,
                            fontSize: 16),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
