import 'package:Baron/model/user_model.dart';
import 'package:Baron/shared/shared_UI.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
      appBar: AppBar(),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView.builder(
          itemCount: collectibles.length,
          itemBuilder: (ctx, i) => collectibleCard(collectibles[i]),
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
                CachedNetworkImage(
                  imageUrl: collectible.img,
                  imageBuilder: (ctx, imageProvider) => Container(
                    height: 100,
                    width: 100,
                    child: Hero(
                      tag: collectible.name,
                      child: Image(
                        image: imageProvider,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                Center(
                  child: Text(collectible.name),
                ),
              ],
            ),
          ),
        ),
      ),
      child: Card(
        elevation: 10,
        child: Container(
          height: 90,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: CachedNetworkImage(
                  imageUrl: collectible.img,
                  imageBuilder: (ctx, imageProvider) => CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 45,
                    child: Hero(
                      tag: collectible.name,
                      child: Image(
                        image: imageProvider,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(
                    strokeWidth: 2,
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
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Quality : ${collectible.quality}',
                      style: TextStyle(fontFamily: 'OpenSans', fontSize: 16),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
