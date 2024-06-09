import 'package:bookcycle/pages/fileter_results_page.dart';
import 'package:flutter/cupertino.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Book.dart';
import '../models/User.dart';
import '../service/get_filtered_books.dart';
import '../widgets/bottomnavbar.dart';
import '../widgets/filtering_widget.dart';
import '../service/get_all_books.dart';
import '../service/get_book_by_id.dart';
import '../service/get_user_by_id.dart';
import 'bookDetails_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Book> _books;
  late List<Book> _filteredBooks;
  bool? _isAskidaCheckboxValue = false;

  @override
  void initState() {
    super.initState();
    _books = [];
    _filteredBooks = [];
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    try {
      final List<Book> fetchedBooks = await getAllBooks();
      setState(() {
        _books = fetchedBooks;
        _filteredBooks = fetchedBooks;
      });
    } catch (e) {
      // Handle error
      print('Error fetching books: $e');
    }
  }

  final List<List<Color>> colorPairs = [
    [Colors.deepOrange.shade300, Colors.deepOrange.shade300],
  ];

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: BoxDecoration(
                color: Color(0xFFFDFDFD),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              padding: EdgeInsets.all(16.0),
              height: MediaQuery.of(context).size.height * 0.8,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Filtreleme',
                      style: TextStyle(
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    FilterWidget(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _filterBooks(String query) {
    setState(() {
      _filteredBooks = _books
          .where((book) =>
      book.name.toLowerCase().contains(query.toLowerCase()) ||
          book.author.toLowerCase().contains(query.toLowerCase()) ||
          book.genre.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange.shade300,
      body: ListView(
        children: [
          SizedBox(height: 20),
          Column(
            children: [
              Text(
                'Bookcycle',
                style: TextStyle(fontFamily:'LexendExa', fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Kitap Ara...',
                              contentPadding: EdgeInsets.all(10),
                              border: InputBorder.none,
                            ),
                            onChanged: _filterBooks,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.search, color: Colors.black),
                        onPressed: () {},
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.filter_list,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            _showFilterDialog(context);
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
          headerTopCategories(context),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Text(
              'Tüm Kitaplar',
              style: TextStyle(
                  fontFamily: 'LexendExa',
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _filteredBooks.length,
              itemBuilder: (BuildContext context, int index) {
                final Book book = _filteredBooks[index];
                final gradientColors = colorPairs[index % colorPairs.length];
                final gradient = LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors,
                );

                return FutureBuilder<User>(
                  future: getUserInfo(book.createdBy),
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
                                bookFuture: getBookById(book.id),
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
                                      if (book.isAskida)
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
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: book.bookImage != null &&
                                      book.bookImage!.isNotEmpty
                                      ? Image.memory(
                                    base64Decode(
                                        base64.normalize(book.bookImage!)),
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

                                          Text("${book.name}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                      SizedBox(height: 10,),
                                      if(book.description.length<45)
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.comment_bank_outlined,
                                              size: 20,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(width: 5,),
                                            Text("${book.description}"),
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
                                            Text("${book.description.substring(0,45)}..."),
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
      bottomNavigationBar: BottomNavBar(selectedIndex: 0),
    );
  }
}

Widget sectionHeader(String headerTitle, {onViewMore}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(left: 15, top: 10),
        child: Text(headerTitle),
      ),
    ],
  );
}

Widget headerTopCategories(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      sectionHeader('Tüm Kategoriler', onViewMore: () {}),
      SizedBox(
        height: 100,
        child: ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: <Widget>[
            headerCategoryItem('Tarih', Icons.history_rounded, onPressed: () {
              List<String> listTarih = ["Tarih"];
              Future<List<Book>> list = getFilteredBooks(listTarih, null, null, null, null, null);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FilterResultsPage(books2: list),
                ),
              );
            }),
            headerCategoryItem('Şiir', Icons.history_edu, onPressed: () {
              List<String> listTarih = ["Şiir"];
              Future<List<Book>> list = getFilteredBooks(listTarih, true, null, null, null, null);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FilterResultsPage(books2: list),
                ),
              );
            }),
            headerCategoryItem('Kurgu', Icons.movie, onPressed: () {
              List<String> listTarih = ["Kurgu"];
              Future<List<Book>> list = getFilteredBooks(listTarih, true, null, null, null, null);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FilterResultsPage(books2: list),
                ),
              );
            }),
            headerCategoryItem('Eğitim', Icons.book, onPressed: () {
              List<String> listTarih = ["Eğitim"];
              Future<List<Book>> list = getFilteredBooks(listTarih, true, null, null, null, null);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FilterResultsPage(books2: list),
                ),
              );
            }),
            headerCategoryItem('Biyografi', Icons.account_circle, onPressed: () {
              List<String> listTarih = ["Biyografi"];
              Future<List<Book>> list = getFilteredBooks(listTarih, true, null, null, null, null);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FilterResultsPage(books2: list),
                ),
              );
            }),
            headerCategoryItem('Bilim Kurgu', Icons.science_rounded, onPressed: () {
              List<String> listTarih = ["Bilim Kurgu"];
              Future<List<Book>> list = getFilteredBooks(listTarih, true, null, null, null, null);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FilterResultsPage(books2: list),
                ),
              );
            }),
            headerCategoryItem('Polisiye', Icons.policy_rounded, onPressed: () {
              List<String> listTarih = ["Polisiye"];
              Future<List<Book>> list = getFilteredBooks(listTarih, true, null, null, null, null);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FilterResultsPage(books2: list),
                ),
              );
            }),
            headerCategoryItem('Felsefe-Dini', Icons.mosque_rounded, onPressed: () {
              List<String> listTarih = ["Felsefe-Dini"];
              Future<List<Book>> list = getFilteredBooks(listTarih, true, null, null, null, null);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FilterResultsPage(books2: list),
                ),
              );
            }),
            headerCategoryItem('Bilim-Teknoloji', Icons.computer_rounded, onPressed: () {
              List<String> listTarih = ["Bilim-Teknoloji"];
              Future<List<Book>> list = getFilteredBooks(listTarih, true, null, null, null, null);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FilterResultsPage(books2: list),
                ),
              );
            }),
          ],
        ),
      )
    ],
  );
}

Widget headerCategoryItem(String name, IconData icon, {onPressed}) {
  return Container(
    margin: EdgeInsets.only(left: 15),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(bottom: 10),
            width: 60,
            height: 60,
            child: FloatingActionButton(
              shape: CircleBorder(),
              heroTag: name,
              onPressed: onPressed,
              backgroundColor: Colors.white,
              child: Icon(icon, size: 35, color: Colors.deepOrange),
            )),
        Text(name + ' ›')
      ],
    ),
  );
}
