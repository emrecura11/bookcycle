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
    [Colors.white, Colors.white],
  ];

  void _applyFilters(String genre, bool? isAskida, String startDate, String endDate) async {
    try {
      final List<Book> filteredBooks = await getFilteredBooks(genre, isAskida, startDate, endDate);
      setState(() {
        _filteredBooks = filteredBooks;
      });
      Navigator.of(context).pop(); // Close the bottom sheet after applying filters
    } catch (e) {
      // Handle error
      print('Error applying filters: $e');
    }
  }

  void _showFilterDialog(BuildContext context) {
    double height=MediaQuery.of(context).size.height*0.04;
    FilterWidget filterWidget = FilterWidget();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {

        return Container(
          decoration: BoxDecoration(
            color: Color(0xFFFDFDFD),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          padding: EdgeInsets.all(16.0),
          height:  MediaQuery.of(context).size.height*0.8 ,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // İçerik boyutuna göre boyutlandır
              children: <Widget>[
                Text(
                  'Filtreleme',
                  style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SingleChildScrollView(
                  child: filterWidget,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.deepOrange.shade300,
                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      ),
                      child: Text(
                        'İptal',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(width: height),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.deepOrange.shade300,
                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      ),
                      child: Text(
                        'Uygula',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {

                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
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
                'bookcycle',
                style: TextStyle(
                    fontFamily: 'LexendExa',
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
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
                        onPressed: () => _showFilterDialog(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
                                bookFuture: getBookById(book.id),
                              ),
                            ),
                          );
                        },
                        child: Card(

                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.black, width: 1),),
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
                                        child: book.bookImage != null
                                            ? Image.asset(
                                                book.bookImage!,
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
                                                book.name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              if (book.isAskida)
                                                Icon(
                                                  Icons.volunteer_activism,
                                                  color: Color(0xFF76C893),
                                                )
                                              else
                                                Icon(
                                                  Icons
                                                      .volunteer_activism_outlined,
                                                  color: Color(0xFF76C893),
                                                )
                                            ],
                                          ),
                                          Text("Yazar: ${book.author}"),
                                          Text("Kategori: ${book.genre}"),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "Kullanıcı: ${user.userName}"),
                                              Text(
                                                  "Tarih: ${book.created.substring(0, 7)}"),
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
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
