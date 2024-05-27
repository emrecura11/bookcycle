import 'dart:convert';

import 'package:bookcycle/service/delete_favorites.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Book.dart';
import '../models/User.dart';
import '../service/get_favorites.dart';
import '../service/get_book_by_id.dart';
import '../service/get_user_by_id.dart';
import '../widgets/bottomnavbar.dart';
import 'bookDetails_page.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<int> bookIds = [];
  final List<Book> books = [];
  User currentUser = User(id: "", email: "", userName: "");
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadFavorites();
  }


  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    currentUser = await getUserInfo(userId!);

    print(userId);
    try {
      List<int> favoriteBookIds = await getFavorites(userId!,bookIds);
      for (int bookId in favoriteBookIds) {
        Book? book = await getBookById(bookId);
        setState(() {
          books.add(book);
          print(book.name);
        });
            }
    } catch (error) {
      print('Error fetching favorites: $error');
    }
  }

  final List<List<Color>> colorPairs = [
    [Color(0xFFee8959), Colors.white],
    [Color(0xFFf4a261), Colors.white],
    [Color(0xFFdda15e), Colors.white],
    [Color(0xFFf26b21), Colors.white],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back, size: 24.0),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Favorilerim",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: books.length,
                  itemBuilder: (BuildContext context, int index) {
                    final gradientColors = colorPairs[index % colorPairs.length];
                    final gradient = LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradientColors,
                    );
                    return FutureBuilder<User>(
                      future: getUserInfo(books[index].createdBy),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          User user = snapshot.data!;
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
                                              right: Radius.circular(8),
                                            ),
                                            child: books[index].bookImage != null &&
                                                books[index].bookImage!.isNotEmpty
                                                ? Image.memory(
                                              base64Decode(base64.normalize(
                                                  books[index].bookImage!)),
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                  stackTrace) {
                                                return Image.asset(
                                                    "images/book1.jpg",
                                                    fit: BoxFit.cover);
                                              },
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
                                                  Row(
                                                    children: [
                                                      if (books[index].isAskida)
                                                        Icon(
                                                          Icons.volunteer_activism,
                                                          color: Color(0xFF76C893),
                                                        )
                                                      else
                                                        Icon(
                                                          Icons.volunteer_activism_outlined,
                                                          color: Color(0xFF76C893),
                                                        ),
                                                      IconButton(
                                                        onPressed: () {
                                                          deleteFavorite(currentUser.id,books[index].id).then((_) {
                                                            setState(() {
                                                              books.removeAt(index);
                                                            });
                                                          });                                                          },
                                                        icon: Icon(Icons.delete),
                                                        color: Colors.black,
                                                      ),
                                                    ],
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
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 3,),
    );
  }
}
