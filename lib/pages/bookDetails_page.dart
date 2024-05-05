import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Book.dart';
import '../models/User.dart';
import '../service/add_favorite.dart';
import '../service/get_user_by_id.dart';
import 'profile_page.dart';

class BookDetailsPage extends StatefulWidget {
  final Future<Book> bookFuture;

  BookDetailsPage({required this.bookFuture});

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  late Future<User> _userFuture;

  Future<void> onBookmarkPressed(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    Book book = await widget.bookFuture;

    addFavorite(context, email!, book.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Book>(
      future: widget.bookFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            child: Center(
              child: CircularProgressIndicator(),
            ),
            height: 50.0,
            width: 50.0,
          ); // Placeholder for loading state
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Book book = snapshot.data!;
          _userFuture = getUserInfo(book.createdBy);
          return FutureBuilder<User>(
            future: _userFuture,
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                  height: 50.0,
                  width: 50.0,
                ); // Placeholder for loading state
              } else if (userSnapshot.hasError) {
                return Text('Error: ${userSnapshot.error}');
              } else {
                User user = userSnapshot.data!;
                return Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.favorite_border),
                        color: Colors.black,
                        onPressed: () {
                          onBookmarkPressed(context);
                        },
                      ),
                    ],
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        // Placeholder for image carousel
                        Container(
                          margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 3,
                            right: MediaQuery.of(context).size.width / 3,
                            bottom: 5,
                            top: 5,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(8),
                              right: Radius.circular(8),
                            ),
                            child: book.bookImage != null
                                ? Image.asset(
                              book.bookImage!,
                              fit: BoxFit.cover,
                            )
                                : Placeholder(),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Divider(
                            color: Colors.black,
                            height: 2,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    book.name,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                  Row(
                                    children: <Widget>[
                                      if (book.isAskida)
                                        Icon(
                                          Icons.volunteer_activism,
                                          color: Color(0xFF76C893),
                                        )
                                      else
                                        Icon(
                                          Icons.volunteer_activism_outlined,
                                          color: Color(0xFF76C893),
                                        ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Askıda Kitap',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.location_on, color: Colors.grey),
                                  SizedBox(width: 4.0),
                                  Text('Antalya'),
                                  Spacer(),
                                  Text("Tarih: ${book.created.substring(0,7)}"),
                                ],
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'Bilgi',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Yazar:',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(book.author),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Durum:',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text('Yeni gibi'),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Tür:',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(book.genre),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                'Açıklama',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              SizedBox(height: 8.0),
                              SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.all(16.0),
                                  color: Colors.grey[200],
                                  width:
                                  MediaQuery.of(context).size.width * 0.9,
                                  height: MediaQuery.of(context).size.height *
                                      0.2,
                                  child: Text(
                                    'Farabi’ye göre, felsefenin dört klasik sorusundan “ne yapmalı?”, “neyi bilebiliriz?” ve “insan nedir?” soruları, “varlık nedir?” sorusuna bağımlıdır. Varlık nedir sorusu cevaplandırıldığı zaman diğer soruların cevabı da belirlenmiş olur. Farabi’nin felsefesi, ahlak ve metafizik anlayışını birbirinden bağımsız olarak değerlendirmek yanlış olacaktır.',
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.0),
                              const Divider(
                                color: Colors.black,
                                height: 2,
                                thickness: 1,
                              ),
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfilePage(
                                          userFuture: getUserInfo(
                                              book.createdBy)),
                                    ),
                                  );
                                },
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage('images/logo_bookcycle.jpeg'),
                                ),
                                  title: Text(user.userName),
                                  trailing: Icon(Icons.arrow_forward),
                              ),
                              SizedBox(height: 5,),

                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor:
                                      Colors.deepOrange.shade300,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 20.0),
                                    ),
                                    child: Text(
                                      'İletişim Kur',
                                      style: TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () {},
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor:
                                      Colors.deepOrange.shade300,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 20.0),
                                    ),
                                    child: Text(
                                      'İstek Listesi',
                                      style: TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Colors.black,
                                height: 2,
                                thickness: 1,
                              ),
                              SizedBox(height: 16.0),
                              Text('İlan no:3782368'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          );
        }
      },
    );
  }
}
