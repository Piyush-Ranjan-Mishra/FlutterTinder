import 'package:bot_toast/bot_toast.dart';
import 'package:dkatalis/TinderCard/matches.dart';
import 'package:flutter/material.dart';

import 'TinderCard/cards.dart';
import 'model/user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Main());
}

class Main extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BotToastInit(
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Color(0xff282a2d),
          scaffoldBackgroundColor: Color(0xfff9f9f9),
          appBarTheme: AppBarTheme(elevation:0)
        ),
        navigatorObservers: [BotToastNavigatorObserver()],
        debugShowCheckedModeBanner: false,
        title: 'DKatalis',
        home: UserDetail(),
      ),
    );
  }
}

class UserDetail extends StatefulWidget {
  UserDetail({
    Key key,
  }) : super(key: key);
  @override
  _UserDetailState createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {

  UserFetchService matchEngine = UserFetchService();

  /// show tinderCard or not based on whether favourite user are showing or not otherwise card will be on top of showList too
  bool overlayOrNot = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          /// show heart button to show fav users
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.red),
            onPressed: () async {
              setState(() {
                overlayOrNot = false;
              });
              await Navigator.push(
                  context, MaterialPageRoute(builder: (c) => ShowFavUser()));
              setState(() {
                overlayOrNot = true;
              });
            },
          )
        ],
      ),
      body: Material(
              elevation: 10,
              child: Stack(
          children: [
            Container(
                height: 100,
                color: Color(0xff282a2d),
              ),
            CardStack(
              overlayOrNot: overlayOrNot,
              matchEngine: matchEngine,
            ),
          ],
        ),
      ),
    );
  }
}

class ShowFavUser extends StatefulWidget {
  ShowFavUser({Key key}) : super(key: key);

  @override
  _ShowFavUserState createState() => _ShowFavUserState();
}

class _ShowFavUserState extends State<ShowFavUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Favourite Users')),
      body: FutureBuilder(
        future: UserDatabase.db.showFavoriteUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (c, i) {
                    User model = snapshot.data[i];
                    return Card(
                        child: UserInfo(
                      model,
                      showAsList: true,
                    ));
                  },
                )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
