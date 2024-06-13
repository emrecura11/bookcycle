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
  String userId= "";
  User currentUser = User(id: "", email: "", userName: "");
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadFavorites();
  }


  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = (prefs.getString('userId'))!;

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
      backgroundColor: Colors.deepOrange.shade300,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),

              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Favorilerim",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "${books.length} tane sonuç bulundu.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,

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
                          return Center(
                            child: CircularProgressIndicator(),
                          );
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
                              color: Colors.white,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [

                                          Row(
                                            children: [
                                              CircleAvatar(
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
                                              SizedBox(width: 5,),
                                              Text(
                                                user.userName,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
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
                                                  deleteFavorite(userId, books[index].id).then((_) {
                                                    setState(() {
                                                      books.removeAt(index);
                                                    });
                                                  });                                                          },
                                                icon: Icon(Icons.delete),
                                                color: Colors.grey,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: books[index].bookImage != null &&
                                          books[index].bookImage!.isNotEmpty
                                          ? Image.memory(
                                        base64Decode(
                                            base64.normalize(books[index].bookImage!)),
                                        fit: BoxFit.cover,
                                        width: MediaQuery.of(context).size.width,
                                        height: 200,
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
                                    SizedBox(height: 10,),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[

                                          Text("${books[index].name}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 10,),
                                          if(books[index].description.length<45)
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.comment_bank_outlined,
                                                  size: 20,
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(width: 5,),
                                                Text("${books[index].description}"),
                                              ],
                                            )
                                          else
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.comment_bank_outlined,
                                                  size: 20,
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(width: 5,),
                                                Text("${books[index].description.substring(0,45)}..."),
                                              ],
                                            )



                                        ],
                                      ),
                                    ),
                                  ],
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
