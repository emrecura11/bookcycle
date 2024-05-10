import 'package:flutter/material.dart';
import '../models/Book.dart';
import '../models/User.dart';
import '../service/get_user_by_id.dart';
import '../service/get_book_by_id.dart';
import 'bookDetails_page.dart';

class FilterResultsPage extends StatefulWidget {
  final Future<List<Book>> books2;

  FilterResultsPage({required this.books2});

  @override
  State<FilterResultsPage> createState() => _FilterResultsPageState();
}

class _FilterResultsPageState extends State<FilterResultsPage> {
  List<Book> books = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getBooks();
  }

  Future<void> getBooks() async {
    try {
      // Fetch books using the provided Future and log the result
      List<Book> fetchedBooks = await widget.books2;
      print('Fetched books: $fetchedBooks');

      setState(() {
        books = fetchedBooks;
        isLoading = false;
      });

      // Log the number of books fetched for debugging purposes
      print('Number of books fetched: ${books.length}');
    } catch (e) {
      // Log any errors that occur and set the loading state to false
      print('Error fetching books: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    "Filtre Sonuçları",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // If still loading, show progress indicator; otherwise, show results
              isLoading
                  ? CircularProgressIndicator()
                  : books.isEmpty
                  ? Text('No results found.')
                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: books.length,
                itemBuilder: (BuildContext context, int index) {
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
                            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              decoration: BoxDecoration(
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
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                                Text("Tarih: ${books[index].created.substring(0, 7)}"),
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
            ],
          ),
        ),
      ),
    );
  }
}
