import 'dart:convert';

import 'package:bookcycle/service/delete_book_by_id.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Book.dart';
import '../models/User.dart';
import '../service/get_all_books.dart';
import '../service/get_favorites.dart';
import '../service/get_book_by_id.dart';
import '../service/get_user_by_id.dart';
import 'bookDetails_page.dart';

class MyAdvertisementsPage extends StatefulWidget {
  @override
  _MyAdvertisementsPageState createState() => _MyAdvertisementsPageState();
}

class _MyAdvertisementsPageState extends State<MyAdvertisementsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

   List<Book> books = [];
  String userId ="";
  @override
  void initState() {
    super.initState();
    getInfo();
  }

  Future<void> getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId')!;
    var books2 = await getAllBooks();

    books2.forEach((element) {
      if(element.createdBy == userId){
        setState(() {
          books.add(element);
        });
      }
    });
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
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back, size: 24.0),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "İlanlarım",
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
                                                showDeleteConfirmationDialog(context, books[index].id, index);
                                                                                                     },
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
    );
  }
  void showDeleteConfirmationDialog(BuildContext context, int bookId, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('İlan Silinecektir'),
          content: Text('Emin misiniz?'),
          actions: <Widget>[
            TextButton(
              child: Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop(); // Dialog'u kapat
              },
            ),
            TextButton(
              child: Text('Evet'),
              onPressed: () async {
                Navigator.of(context).pop(); // Dialog'u kapat
                await deleteBook(books[index].id).then((_) {
                  setState(() {
                    books.removeAt(index);
                  });
                });      // Kitabı sil
              },
            ),
          ],
        );
      },
    );
  }
}
