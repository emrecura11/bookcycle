import 'dart:convert';

import 'package:bookcycle/pages/update_book_page.dart';
import 'package:bookcycle/service/delete_favorites.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Book.dart';
import '../models/User.dart';
import '../service/add_favorite.dart';
import '../service/get_favorites.dart';
import '../service/get_user_by_id.dart';
import '../widgets/book_report_widget.dart';
import 'profile_page.dart';

class BookDetailsPage extends StatefulWidget {
  final Future<Book> bookFuture;

  BookDetailsPage({required this.bookFuture});

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  late Future<User> _userFuture;
  String? userId; // Class-level variable

  @override
  void initState() {
    super.initState();
    _loadUserId().then((_) {
      // Ensure user ID is loaded
      setState(() {}); // Rebuild the widget once user ID is loaded
    });
  }

  Future<bool> isBookFavorite(int bookId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    List<int> bookIds = [];
    try {
      List<int> favoriteBookIds = await getFavorites(userId!, bookIds);
      for (int item in favoriteBookIds) {
        if (item == bookId) {
          return true;
        }
      }
    } catch (error) {
      print('Error fetching favorites: $error');
    }
    return false;
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
  }

  Future<void> onBookmarkPressed(BuildContext context) async {
    Book book = await widget.bookFuture;
    if (userId != null) {
      if (await isBookFavorite(book.id) == false) {
        addFavorite(context, userId!, book.id);
      } else {
        deleteFavorite(userId!, book.id);
      }
    }
  }

  Future<void> onReportPressed(BuildContext context, int bookId) async {
    if (userId != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ReportBook(reportedBookId: bookId, reportingUserId: userId!);
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("You need to be logged in to report an issue.")));
    }
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
                    backgroundColor: Colors.deepOrange.shade300,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    actions: <Widget>[
                      if (userId != book.createdBy)
                        IconButton(
                          icon: FutureBuilder<bool>(
                            future: isBookFavorite(book.id),
                            builder: (context, isFavoriteSnapshot) {
                              if (isFavoriteSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Icon(Icons.favorite_border,
                                    color: Colors.black);
                              } else {
                                return Icon(
                                  isFavoriteSnapshot.data == true
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavoriteSnapshot.data == true
                                      ? Colors.red
                                      : Colors.black,
                                );
                              }
                            },
                          ),
                          onPressed: () async {
                            await onBookmarkPressed(context);
                            setState(
                                () {}); // Widget'ın yeniden çizilmesini sağlamak için setState kullanın
                          },
                        ),
                      if (userId != book.createdBy)
                        IconButton(
                          icon: Icon(Icons.report_problem, color: Colors.amber),
                          onPressed: () => onReportPressed(context, book.id),
                        )
                      else
                        IconButton(
                          icon: Icon(Icons.more_vert),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateBookPage(
                                  book: book,
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                    elevation: 0,
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 4,
                            right: MediaQuery.of(context).size.width / 4,
                            bottom: 5,
                            top: 5,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(8),
                              right: Radius.circular(8),
                            ),
                            child: book.bookImage != null &&
                                    book.bookImage!.isNotEmpty
                                ? Image.memory(
                                    base64Decode(
                                        base64.normalize(book.bookImage!)),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset("images/book1.jpg",
                                          fit: BoxFit.cover);
                                    },
                                  )
                                : Image.asset("images/book1.jpg",
                                    fit: BoxFit.cover),
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
                                      fontSize: 20.0,
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
                                  Text(book.location),
                                  Spacer(),
                                  Text(
                                      "Tarih: ${book.created.substring(0, 7)}"),
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
                                        Text(book.stateOfBook),
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  child: Text(
                                    book.description,
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
                                          userFuture:
                                              getUserInfo(book.createdBy)),
                                    ),
                                  );
                                },
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: user.userImage != null
                                      ? (user.userImage!.startsWith('http')
                                          ? NetworkImage(user.userImage!)
                                          : MemoryImage(
                                                  base64Decode(user.userImage!))
                                              as ImageProvider<
                                                  Object>) // Base64 string
                                      : const AssetImage(
                                          'images/logo_bookcycle.jpeg'),
                                ),
                                title: Text(user.userName),
                                trailing: Icon(Icons.arrow_forward),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              const Divider(
                                color: Colors.black,
                                height: 2,
                                thickness: 1,
                              ),
                              SizedBox(height: 16.0),
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
