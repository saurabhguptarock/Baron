import 'package:flutter/material.dart';

class CollectiblesPage extends StatefulWidget {
  @override
  _CollectiblesPageState createState() => _CollectiblesPageState();
}

class _CollectiblesPageState extends State<CollectiblesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Text(
              'Epic Items',
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                collectibleCard('Epic/Amnesia'),
                collectibleCard('Epic/Ancient Sphere'),
                collectibleCard('Epic/Blackfire'),
                collectibleCard('Epic/Brilliance'),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                collectibleCard('Epic/C-3PO'),
                collectibleCard('Epic/Cataclysm Fan'),
                collectibleCard('Epic/Chuck1'),
                collectibleCard('Epic/Cold-Forged Trinket'),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                collectibleCard('Epic/Covergence'),
                collectibleCard('Epic/Crescent'),
                collectibleCard('Epic/Curved Bauble'),
                collectibleCard('Epic/Dawnlight'),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                collectibleCard('Epic/Dragonbane'),
                collectibleCard('Epic/Emberling'),
                collectibleCard('Epic/Engraved Cage'),
                collectibleCard('Epic/Fiery Glaive'),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                collectibleCard('Epic/Fireguard Cudgel'),
                collectibleCard('Epic/Hopeless Cane'),
                collectibleCard('Epic/KyloRen'),
                collectibleCard('Epic/Limbo'),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                collectibleCard('Epic/Lustful Wand'),
                collectibleCard('Epic/Malady Circlet'),
                collectibleCard('Epic/Malignant Ornament'),
                collectibleCard('Epic/Moonshard'),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                collectibleCard('Epic/Nightfall'),
                collectibleCard('Epic/Nightmare'),
                collectibleCard('Epic/PoeDameron'),
                collectibleCard('Epic/Red1'),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                collectibleCard('Epic/Shadowfall'),
                collectibleCard('Epic/Shield of Contagion'),
                collectibleCard('Epic/Singed Fetish'),
                collectibleCard('Epic/Venom Eye'),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                collectibleCard('Epic/Windweaver'),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Text(
              'Legendary Items',
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                collectibleCard('Legendary/Celestial Ichor'),
                collectibleCard('Legendary/Crown of the Scourge'),
                collectibleCard('Legendary/Duskshadow'),
                collectibleCard('Legendary/Exiled Globule'),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                collectibleCard('Legendary/Featherfall'),
                collectibleCard('Legendary/Insanity'),
                collectibleCard('Legendary/Malificent Cudgel'),
                collectibleCard('Legendary/Military Paragon'),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                collectibleCard('Legendary/Prudence'),
                collectibleCard('Legendary/Restored Paragon'),
                collectibleCard('Legendary/Yoda'),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Text(
              'Rare Items',
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                collectibleCard('Rare/City'),
                collectibleCard('Rare/DarthVader'),
                collectibleCard('Rare/Dementia'),
                collectibleCard('Rare/Fleece of Contagion'),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                collectibleCard('Rare/Genesis Staff'),
                collectibleCard('Rare/Heinous Focus'),
                collectibleCard('Rare/Persuasion'),
                collectibleCard('Rare/Phantomlight'),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                collectibleCard('Rare/PremiumBomb'),
                collectibleCard('Rare/PremiumChuck'),
                collectibleCard('Rare/PremiumJake'),
                collectibleCard('Rare/PremiumRed'),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                collectibleCard('Rare/Silverglow'),
                collectibleCard('Rare/Slab of Blessings'),
                collectibleCard('Rare/Starlight'),
                collectibleCard('Rare/Storm Arch'),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                collectibleCard('Rare/Stormtrooper'),
                collectibleCard('Rare/Timeworn Glaive'),
                collectibleCard('Rare/Vengeful Jewel'),
                collectibleCard('Rare/Wretched Skull'),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Text(
              'Mythic Items',
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                collectibleCard('Mythic/DeathNote'),
                collectibleCard('Mythic/Illumina'),
                collectibleCard('Mythic/Potion'),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Text(
              'Classic Items',
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                collectibleCard('Classic/2x'),
                collectibleCard('Classic/Fluke'),
                collectibleCard('Classic/Blue'),
                collectibleCard('Classic/Bomb'),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                collectibleCard('Classic/BlackPanther'),
                collectibleCard('Classic/Bonecarvin Urn'),
                collectibleCard('Classic/CaptainAmerica'),
                collectibleCard('Classic/Chuck'),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                collectibleCard('Classic/Dreamshadow'),
                collectibleCard('Classic/Flash'),
                collectibleCard('Classic/Frenzy'),
                collectibleCard('Classic/Frostguard'),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                collectibleCard('Classic/IronMan'),
                collectibleCard('Classic/Matilda'),
                collectibleCard('Classic/MightyEagle'),
                collectibleCard('Classic/Netherbane'),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                collectibleCard('Classic/Warped Bauble'),
                collectibleCard('Classic/Nova'),
                collectibleCard('Classic/Phobia'),
                collectibleCard('Classic/Pig1'),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                collectibleCard('Classic/PigKing'),
                collectibleCard('Classic/PigOld'),
                collectibleCard('Classic/PigSoldier'),
                collectibleCard('Classic/Plush'),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                collectibleCard('Classic/Rage'),
                collectibleCard('Classic/Red'),
                collectibleCard('Classic/Runed Chalice'),
                collectibleCard("Classic/Sorrow's Goblet"),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                collectibleCard('Classic/SpiderMan'),
                collectibleCard('Classic/Stella'),
                collectibleCard('Classic/Stella1'),
                collectibleCard('Classic/Supinity'),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                collectibleCard('Classic/Terence'),
                collectibleCard('Classic/Unholy Gem'),
                collectibleCard('Classic/WarMachine'),
                collectibleCard('Classic/Vowed Wand'),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                collectibleCard('Classic/Thunderstrike'),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget collectibleCard(String name) {
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => Scaffold(
                appBar: AppBar(),
                body: Column(
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 100,
                      child: Hero(
                        tag: name,
                        child: Image(
                          image: AssetImage('assets/collectibles/$name.png'),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(name.split('/')[1]),
                    ),
                  ],
                ),
              ))),
      child: Card(
        elevation: 10,
        child: Container(
          height: 80,
          width: MediaQuery.of(context).size.width / 5,
          child: Hero(
            tag: name,
            child: Image(
              image: AssetImage('assets/collectibles/$name.png'),
            ),
          ),
        ),
      ),
    );
  }
}
