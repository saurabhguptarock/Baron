import 'package:Baron/model/user_model.dart';
import 'package:Baron/shared/shared_UI.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CollectiblesPage extends StatefulWidget {
  @override
  _CollectiblesPageState createState() => _CollectiblesPageState();
}

class _CollectiblesPageState extends State<CollectiblesPage> {
  @override
  Widget build(BuildContext context) {
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
            itemBuilder: (ctx, i) => collectibleCard(collectibles[i]),
          ),
        ),
      ),
    );
  }

  Widget collectibleCard(Collectible collectible) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => Scaffold(
            appBar: AppBar(),
            body: Column(
              children: <Widget>[
                Container(
                  height: 100,
                  width: 100,
                  child: Hero(
                    tag: collectible.name,
                    child: Image(
                      image: NetworkImage(collectible.img),
                    ),
                  ),
                ),
                Center(
                  child: Text(collectible.name),
                ),
              ],
            ),
          ),
        ),
      ),
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
                    child: CircleAvatar(
                      backgroundColor: Color.fromRGBO(27, 36, 48, 1),
                      radius: 45,
                      child: Hero(
                        tag: collectible.name,
                        child: Image(
                          image: NetworkImage(collectible.img),
                        ),
                      ),
                    )),
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
