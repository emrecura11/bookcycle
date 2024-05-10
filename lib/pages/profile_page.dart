import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bookcycle/service/get_all_books.dart';
import 'package:bookcycle/service/get_book_by_id.dart';
import 'package:bookcycle/service/get_user_by_id.dart';
import 'package:bookcycle/widgets/basic_button.dart';
import 'package:bookcycle/widgets/drawer_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Book.dart';
import '../models/User.dart';
import '../widgets/bottomnavbar.dart';
import 'bookDetails_page.dart';

class ProfilePage extends StatefulWidget {
  final Future<User> userFuture;

  ProfilePage({required this.userFuture});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

   User user = User(id: '', userName: '', email: '');
  bool _userIsCurrent = false;

  final List<Book> books = [];

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() {
    getInfo().then((userIsLoggedIn) {
      setState(() {
        _userIsCurrent = userIsLoggedIn ?? false;
      });
    });
  }

  Future<bool> getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    var books2 = await getAllBooks();
    user = await widget.userFuture;

    books2.forEach((element) {
      if(element.createdBy == user.id){
        books.add(element);
      }
    });

    if (userId != null) {
      if (userId == user.id) {
        return true;
      } else {
        return false;
      }
    }
    return false; // Varsayılan olarak false döndür
  }



  final List<List<Color>> colorPairs = [
    /*[Color(0xFFFFBA78), Colors.white],
    [Color(0xFFFFCC84), Colors.white],
    [Color(0xFFFFD991), Colors.white],
    [Color(0xFFFFE69E), Colors.white],*/

    [Color(0xFFee8959), Colors.white],
    [Color(0xFFf4a261), Colors.white],
    [Color(0xFFdda15e), Colors.white],
    [Color(0xFFf26b21), Colors.white],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: ProfileDrawer(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                visible: _userIsCurrent,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.menu, color: Colors.black),
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    ),
                  ),
                ),
              ),


               Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage:user.userImage != null
                        ? (user.userImage!.startsWith('http')
                        ? NetworkImage(user.userImage!) // URL olarak kullan
                        : MemoryImage(base64Decode(user.userImage!)) as ImageProvider<Object>) // Base64 string
                        : const AssetImage('images/logo_bookcycle.jpeg'),
                  ),
                ),
              ),
              const SizedBox(height: 16),
               Align(
                alignment: Alignment.topCenter,
                child: Text(
                  user.userName,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Icon(
                    Icons.location_on,
                    color: Color(0xFF88C4A8),
                  ),
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Visibility(
                visible: !_userIsCurrent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.messenger,
                      color: Color(0xFF88C4A8),
                    ),
                    BasicButton(
                        onTap: () {

                        },
                        buttonText: "Get Contact"),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              const Divider(
                color: Colors.black,
                height: 1,
                thickness: 0.5,
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Advertisements",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // ListView
              SizedBox(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: books.length,
                  itemBuilder: (BuildContext context, int index) {
                    final gradientColors = colorPairs[index % colorPairs.length];
                    final Book book = books[index];

                    final gradient = LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradientColors,
                    );
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookDetailsPage(
                              bookFuture: getBookById(books[index].id),
                            ),
                          ),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: gradient,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(8),
                                          right: Radius.circular(8)),
                                      child: books[index].bookImage != null
                                          ? Image.asset(
                                        books[index].bookImage!,
                                        fit: BoxFit.cover,
                                      )
                                          : Image.asset(
                                        "images/book1.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  flex: 1,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              books[index].name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            if (books[index].isAskida)
                                              Icon(
                                                Icons.volunteer_activism,
                                                color: Color(0xFF76C893),
                                              )
                                            else
                                              Icon(
                                                Icons.volunteer_activism_outlined,
                                                color: Color(0xFF76C893),
                                              )
                                          ],
                                        ),
                                        Text("Yazar: ${books[index].author}"),
                                        Text("Kategori: ${books[index].genre}"),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Kullanıcı: ${user.userName}"),
                                            Text("Tarih: ${books[index].created.substring(0,7)}"),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  flex: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
