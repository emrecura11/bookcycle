import 'dart:convert';

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
                    "${books.length} adet sonuç bulundu",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // If still loading, show progress indicator; otherwise, show results
              Center(
                child: isLoading
                    ? CircularProgressIndicator()
                    : books.isEmpty
                    ? Text('Kitap bulunamadı')
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
}
