import 'dart:convert';

import 'package:dkatalis/Utils.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

String tableTodo = 'users',
    columngender = 'gender',
    columnname = 'name',
    columnlocation = 'location',
    columnemail = 'email',
    columnusername = 'username',
    columnpassword = 'password',
    columnsalt = 'salt',
    columnmd5 = 'md5',
    columnsha1 = 'sha1',
    columnsha256 = 'sha256',
    columnregistered = 'registered',
    columndob = 'dob',
    columnphone = 'phone',
    columncell = 'cell',
    columnssn = 'ssn',
    columnpicture = 'picture',
    columnseed = 'seed',
    columnversion = 'version',
    columntimeCreated = 'createdTime',
    columntitle = 'title',
    columnfirst = 'first',
    columnlast = 'last',
    columnstreet = 'street',
    columncity = 'city',
    columnstate = 'state',
    columnzip = 'zip',
    createUsers = "CREATE TABLE IF NOT EXISTS $tableTodo (" +
        '$columngender TEXT  , ' +
        '$columnname  TEXT   , ' +
        '$columnlocation  TEXT   , ' +
        '$columnemail  TEXT   , ' +
        '$columnusername  TEXT PRIMARY KEY  , ' +
        '$columnpassword  TEXT   , ' +
        '$columnsalt  TEXT   , ' +
        '$columnmd5  TEXT   , ' +
        '$columnsha1  TEXT   , ' +
        '$columnsha256  TEXT   , ' +
        '$columnregistered  INTEGER   , ' +
        '$columndob  INTEGER   , ' +
        '$columnphone  TEXT   , ' +
        '$columncell  TEXT   , ' +
        '$columnssn  TEXT   , ' +
        '$columnseed  TEXT   , ' +
        '$columnversion  TEXT   , ' +
        '$columntimeCreated  INTEGER   , ' +
        '$columnpicture  TEXT    ' +
        ')';
Utils utils = Utils.instance;

class User {
  Name name;
  String gender,
      email,
      username,
      password,
      salt,
      md5,
      sha1,
      sha256,
      phone,
      cell,
      ssn,
      picture,
      seed,
      version;
  Location location;
  int dob, registered, timeStampNow;
  toMap() => {
        columngender: gender,
        columnname: name.toString(),
        columnlocation: location.toString(),
        columnemail: email,
        columnusername: username,
        columnpassword: password,
        columnsalt: salt,
        columnmd5: md5,
        columnsha1: sha1,
        columnsha256: sha256,
        columnregistered: registered,
        columndob: dob,
        columnphone: phone,
        columncell: cell,
        columnssn: ssn,
        columnpicture: picture,
        columnseed: seed,
        columnversion: version,
        columntimeCreated:
            timeStampNow ?? DateTime.now().millisecondsSinceEpoch,
      };
  User.fromMap(dynamic map) {
    gender = map[columngender];
    name = Name.fromStringOrMap(map[columnname]);
    location = Location.fromStringOrMap(map[columnlocation]);
    email = map[columnemail];
    username = map[columnusername];
    password = map[columnpassword];
    salt = map[columnsalt];
    md5 = map[columnmd5];
    sha1 = map[columnsha1];
    sha256 = map[columnsha256];
    registered = utils.getInt(map[columnregistered]);
    dob = utils.getInt(map[columndob]);
    phone = map[columnphone];
    cell = map[columncell];
    ssn = map[columnssn];
    picture = map[columnpicture];
    seed = map[columnseed];
    version = map[columnversion];
    timeStampNow = map[columntimeCreated];
  }

  save() => UserDatabase.db.insertR(this);
  delete() => UserDatabase.db.delete(username);
}

class Name {
  String title, first, last;
  Name.fromStringOrMap(dynamic map) {
    if (map is String) map = json.decode(map);
    title = map[columntitle];
    first = map[columnfirst];
    last = map[columnlast];
  }
  @override
  String toString() => json.encode({
        columntitle: title,
        columnfirst: first,
        columnlast: last,
      });

  /// to get name as Mr Firstname Lastname
  String get name {
    String s = '';
    void addString(String p) {
      if (utils.isNotNullEmptyFalseOrZero(p)) s.isEmpty ? s = p : s += ' $p';
    }

    addString(title);
    addString(first);
    addString(last);
    return s.toUpperCase();
  }
}

class Location {
  String street, city, state, zip;
  Location.fromStringOrMap(dynamic map) {
    if (map is String) map = json.decode(map);
    street = map[columnstreet];
    city = map[columncity];
    state = map[columnstate];
    zip = map[columnzip];
  }
  @override
  String toString() => json.encode({
        columnstreet: street,
        columncity: city,
        columnstate: state,
        columnzip: zip,
      });

  /// to get addredd as street, city, state ,zip
  String get location {
    String s = '';
    void addString(String p) {
      if (utils.isNotNullEmptyFalseOrZero(p)) s.isEmpty ? s = p : s += ', $p';
    }

    addString(street);
    addString(city);
    addString(state);
    addString(zip);
    return s.toUpperCase();
  }
}

class UserDatabase {
  UserDatabase._();

  static final UserDatabase db = UserDatabase._();
  Database dbase;

  Future<Database> get database async {
    if (dbase == null) {
      var databasesPath = await getDatabasesPath();
      String path = '$databasesPath/demo.db';
      // open the database
      dbase = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute(createUsers);
      });
    }
    return dbase;
  }

  // inserting user into database
  Future<int> insertR(User todo) async {
    if (!utils.isNotNullEmptyFalseOrZero(todo)) return 0;

    final db = await database;

    int f = await updateR(todo);
    if (f < 1) {
      f = await db.insert(tableTodo, todo.toMap());
    }
    return f;
  }

  Future<List<User>> showFavoriteUser() async {
    final db = await database;
    var map = await db.query(tableTodo, orderBy: '$columntimeCreated DESC');
    List<User> list =
        map.isEmpty ? null : map.map((e) => User.fromMap(e)).toList();
    return list;
  }

  //updating user into database
  Future<int> updateR(User todo) async {
    if (!utils.isNotNullEmptyFalseOrZero(todo)) return 0;
    final db = await database;

    var tu = await db.update(tableTodo, todo.toMap(),
        where: '$columnusername = ?', whereArgs: [todo.username]);
    return tu;
  }

  //updating user into database
  Future<int> delete(String username) async {
    if (!utils.isNotNullEmptyFalseOrZero(username)) return 0;
    final db = await database;

    var tu = await db
        .delete(tableTodo, where: '$columnusername = ?', whereArgs: [username]);
    return tu;
  }

  resetDB() async {
    final db = await database;
    db.execute('DROP TABLE IF EXISTS $tableTodo');
    db.execute(createUsers);
  }

  Future close() async => db.close();
}

class UserInfo extends StatefulWidget {
  final User user;

  /// default:false, true if you want to display whole information
  final bool showAsList;

  /// show how info of user to be shown
  const UserInfo(this.user, {this.showAsList: false, Key key})
      : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    /// show circular progreen if user is not fetched
    if (widget.user == null) return Center(child: CircularProgressIndicator());

    var cross = widget.showAsList
        ? CrossAxisAlignment.start
        : CrossAxisAlignment.center;
    List<Widget>  widgetList = [
        Column(
          crossAxisAlignment: cross,
          children: [
            Text(
              widget.user?.name?.name ?? '',
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
            ),
            Text(
              '(${widget.user?.username ?? ''})',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            getText('Gender : ', widget.user?.gender?.toUpperCase(),
                middle: false)
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.user.dob > 0)
              getText(
                'Birthday : ',
                utils.getDateString(widget.user.dob * 1000),
              ),
            if (widget.user.registered > 0)
              getText(
                'Since : ',
                utils.getDateString(widget.user.registered * 1000),
              ),
          ],
        ),
        Column(
          crossAxisAlignment: cross,
          children: [
            getText(
              'Address : ',
              widget.user?.location?.location,
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (utils.isNotNullEmptyFalseOrZero(widget.user?.email))
              getText(
                'Email : ',
                widget.user.email,
                middle: false,
              ),
            if (utils.isNotNullEmptyFalseOrZero(widget.user?.phone))
              getText(
                'Phone : ',
                widget.user.phone,
                middle: false,
              ),
            if (utils.isNotNullEmptyFalseOrZero(widget.user?.cell))
              getText(
                'Cell : ',
                widget.user.cell,
                middle: false,
              ),
            if (utils.isNotNullEmptyFalseOrZero(widget.user?.ssn))
              getText(
                'SSN : ',
                widget.user.ssn,
                middle: false,
              ),
          ],
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (utils.isNotNullEmptyFalseOrZero(widget.user?.password))
            getText(
              'Password : ',
              widget.user.password,
              middle: false,
            ),
          if (utils.isNotNullEmptyFalseOrZero(widget.user?.salt))
            getText(
              'Salt: ',
              widget.user.salt,
              middle: false,
            ),
          if (utils.isNotNullEmptyFalseOrZero(widget.user?.md5))
            getText(
              'MD5: ',
              widget.user.md5,
              middle: false,
            ),
          if (utils.isNotNullEmptyFalseOrZero(widget.user?.sha1))
            getText(
              'SHA1: ',
              widget.user.sha1,
              middle: false,
            ),
          if (utils.isNotNullEmptyFalseOrZero(widget.user?.sha256))
            getText(
              'SHA256: ',
              widget.user.sha256,
              middle: false,
            ),
        ]),
      ];

    Widget pic = Container(
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 100,
            child: Container(
              color: Color(0xfff9f9f9),
            ),
          ),

          ///Draw background line
          Positioned(
            top: 200,
            left: 0,
            right: 0,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          Center(
              child: Container(
            height: 220,
            width: 220,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: CircleAvatar(
                radius: 100,
                backgroundImage: NetworkImage(widget.user.picture),
              ),
            ),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: new Border.all(
                color: Colors.grey,
                width: 1,
              ),
            ),
          )),
        ],
      ),
    );
    if (widget.showAsList) {
      if (!widgetList.contains(pic)) widgetList.insert(0, pic);
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgetList,
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          pic,
          Expanded(
            child: SingleChildScrollView(child: widgetList[_current]),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _current,
        selectedItemColor: Color(0xffadc37b),
        unselectedItemColor: Colors.grey,
        onTap: (c) => setState(() => _current = c),
        items: [
          BottomNavigationBarItem(title: Offstage(), icon: Icon(Icons.person)),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Offstage(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Offstage(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            title: Offstage(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock),
            title: Offstage(),
          ),
        ],
      ),
    );
  }

  /// get text with subtitle and title
  Widget getText(String sub, String main, {bool middle = true}) => Text.rich(
        TextSpan(
          text: sub ?? '',
          style: TextStyle(fontSize: 15, color: Colors.grey),
          children: [
            TextSpan(
              text: main ?? '',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
        textAlign: middle ? TextAlign.center : null,
      );
}
