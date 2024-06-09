import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dart:io';
import '../service/update_wishlist_detail.dart';
import 'package:bookcycle/pages/chatPage.dart';
import 'package:bookcycle/service/get_all_books.dart';
import 'package:bookcycle/service/get_book_by_id.dart';
import 'package:bookcycle/widgets/basic_button.dart';
import 'package:bookcycle/widgets/drawer_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Book.dart';
import '../models/User.dart';
import '../models/Wishlist.dart';
import '../widgets/bottomnavbar.dart';
import '../widgets/user_report_widget.dart';
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
  String userId = "";
  List<Wishlist> wishlists = [];
  final List<Book> books = [];
  bool _isShowingWishlist = false;

  @override
  void initState() {
    super.initState();
    initializeData();
    fetchWishlists();
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
    userId = prefs.getString('userId')!;
    var books2 = await getAllBooks();
    user = await widget.userFuture;

    books2.forEach((element) {
      if (element.createdBy == user.id) {
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

  Future<void> onReportPressed(
      BuildContext context, String reportedUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId'); // Get current user's ID
    if (userId != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // Assuming UserReportWidget takes the reporting user's ID and the reported user's ID
          return UserReportWidget(
              reportingUserId: userId, reportedUserId: reportedUserId);
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("You need to be logged in to report an issue.")));
    }
  }


  final List<String> wishlistImages = [
    "images/wishlist1.jpeg",
        "images/wishlist2.jpeg",
        "images/wishlist3.jpeg",
        "images/wishlist4.jpeg",
        "images/wishlist5.jpeg",
  ];
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
      drawer: ProfileDrawer(
        userId: userId,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: _userIsCurrent && _isShowingWishlist
          ? FloatingActionButton(
              onPressed: () {
                _showAddWishlistDialog(context);
              },
              child: Icon(Icons.add),
            )
          : null,
      body: FutureBuilder<User>(
          future: widget.userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (snapshot.hasData) {
                User user = snapshot.data!;
                return SingleChildScrollView(
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
                                  icon: const Icon(Icons.menu,
                                      color: Colors.black),
                                  onPressed: () =>
                                      _scaffoldKey.currentState?.openDrawer(),
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
                                backgroundImage: user.userImage != null
                                    ? (user.userImage!.startsWith('http')
                                        ? NetworkImage(user
                                            .userImage!) // URL olarak kullan
                                        : MemoryImage(
                                                base64Decode(user.userImage!))
                                            as ImageProvider<
                                                Object>) // Base64 string
                                    : const AssetImage(
                                        'images/logo_bookcycle.jpeg'),
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
                          Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              user.description ?? '', // Displaying description
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Color(0xFF88C4A8),
                              ),
                              Text(
                                user.location ?? 'Bilinmiyor',
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

                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                          senderId: userId,
                                          receiverId: user.id,
                                        ),
                                      ),
                                    );
                                  }, child: Text("Mesaj"),
                                ),
                                IconButton(
                                  icon: Icon(Icons.report_problem,
                                      color: Colors.amber),
                                  onPressed: () =>
                                      onReportPressed(context, user.id),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          
                          
                          Container(
                            decoration:  BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                              color: Colors.deepOrange.shade300
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 4.0, right: 4.0, top: 12.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isShowingWishlist = false;
                                          });
                                        },
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 8.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              color: _isShowingWishlist
                                                  ? Colors.deepOrange.shade300
                                                  : Colors.white,
                                            ),
                                            child: Text(
                                              "İlanlar",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isShowingWishlist = true;
                                          });
                                        },
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 16.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              color: _isShowingWishlist
                                                  ? Colors.white
                                                  : Colors.deepOrange.shade300
                                            ),
                                            child: Text(
                                              "İstek Listesi",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    child: _isShowingWishlist
                                        ? _buildWishlistListView()
                                        : _buildAdvertisementListView(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                  ),
                );
              }
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),

      bottomNavigationBar: Visibility(
        visible: _userIsCurrent,
        child: BottomNavBar(
          selectedIndex: 4,
        ),
      ),
    );
  }

  Widget _buildWishlistListView() {
    List<Wishlist> wishlist2 = [];
    wishlists.forEach((element) {
      if (element.createdBy == user.id) {
        wishlist2.add(element);
      }
    });
    return  SizedBox(
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: wishlist2.length,
          itemBuilder: (BuildContext context, int index) {
            final gradientColors = colorPairs[index % colorPairs.length];
            final gradient = LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            );
            return GestureDetector(
              onTap: () {},
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                                child: Image.asset(
                                  wishlistImages[index % wishlistImages.length],
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
                                        wishlist2[index].name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              deleteWishlist(
                                                      wishlist2[index].id)
                                                  .then((_) {
                                                setState(() {
                                                  wishlist2.removeAt(index);
                                                });
                                              });
                                            },
                                            icon: Icon(Icons.delete),
                                            color: Colors.grey,
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              _showUpdateWishlistDialog(context, wishlist2[index]);
                                            },
                                            icon: Icon(Icons.more_vert_outlined),
                                            color: Colors.black,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Text("Yazar: ${wishlist2[index].author}"),
                                  Text("Durum: ${wishlist2[index].stateOfBook}"),
                                  Text("Açıklama: ${wishlist2[index].description}"),

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
    );
  }

  Widget _buildAdvertisementListView() {
    return SizedBox(
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


              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BookDetailsPage(
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
                    margin: EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
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
                                  SizedBox(
                                    width: 5,
                                  ),
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
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            height: 200,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset("images/book1.jpg",
                                  fit: BoxFit.cover);
                            },
                          )
                              : Image.asset(
                            "images/book1.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "${books[index].name}",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              if (books[index].description.length < 45)
                                Row(
                                  children: [
                                    Icon(
                                      Icons.comment_bank_outlined,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
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
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                        "${books[index].description.substring(
                                            0, 45)}..."),
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
          },
        ),
    );
  }

  Future<void> fetchWishlists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtoken');
    final response = await http.get(
        Uri.parse('https://bookcycle.azurewebsites.net/api/v1/Wishlist'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });

    print(response.statusCode);

    if (response.statusCode == 200) {
      setState(() {
        wishlists = (json.decode(response.body) as List)
            .map((data) => Wishlist.fromJson(data))
            .toList();
      });
    } else {
      throw Exception('Failed to load wishlists ${response.statusCode}');
    }
  }

  Future<void> addWishlist(String name, String author, String stateOfBook,
      String description) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtoken');

    final response = await http.post(
      Uri.parse('https://bookcycle.azurewebsites.net/api/v1/wishlist'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        'name': name,
        'author': author,
        'stateOfBook': stateOfBook,
        'description': description,
      }),
    );
    print(response.statusCode);

    if (response.statusCode == 201) {
      fetchWishlists(); // Yeni bir wishlist ekledikten sonra listeyi güncelle
    } else {
      throw Exception('Wishlist eklenirken hata oluştu');
    }
  }

  Future<void> deleteWishlist(int wishlistId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtoken');

    final response = await http.delete(
      Uri.parse(
          'https://bookcycle.azurewebsites.net/api/v1/Wishlist/$wishlistId'),
      headers: {'accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 204) {
      fetchWishlists();
      // Wishlist başarıyla silindiğinde yapılacak işlemleri buraya ekleyin
      print('Wishlist başarıyla silindi');
    } else {
      throw Exception('Wishlist silinirken hata oluştu');
    }
  }

  Future<void> _showAddWishlistDialog(BuildContext context) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController authorController = TextEditingController();
    TextEditingController stateOfBookController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Yeni İstek Kitabı Ekle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'İsim'),
              ),
              TextField(
                controller: authorController,
                decoration: InputDecoration(labelText: 'Yazar'),
              ),
              TextField(
                controller: stateOfBookController,
                decoration: InputDecoration(labelText: 'Kitap Durumu'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Açıklama'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                String name = nameController.text.trim();
                String author = authorController.text.trim();
                String stateOfBook = stateOfBookController.text.trim();
                String description = descriptionController.text.trim();
                if (name.isNotEmpty &&
                    author.isNotEmpty &&
                    stateOfBook.isNotEmpty &&
                    description.isNotEmpty) {
                  addWishlist(name, author, stateOfBook, description);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Ekle'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showUpdateWishlistDialog(
      BuildContext context, Wishlist wishlist) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController authorController = TextEditingController();
    TextEditingController stateOfBookController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('İstek kitabı düzenle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration:
                    InputDecoration(labelText: 'İsim', hintText: wishlist.name),
              ),
              TextField(
                controller: authorController,
                decoration: InputDecoration(
                    labelText: 'Yazar', hintText: wishlist.author),
              ),
              TextField(
                controller: stateOfBookController,
                decoration: InputDecoration(
                    labelText: 'Kitap Durumu', hintText: wishlist.stateOfBook),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                    labelText: 'Açıklama', hintText: wishlist.description),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () async {
                String name = nameController.text.trim();
                String author = authorController.text.trim();
                String stateOfBook = stateOfBookController.text.trim();
                String description = descriptionController.text.trim();
                if (name.isNotEmpty &&
                    author.isNotEmpty &&
                    stateOfBook.isNotEmpty &&
                    description.isNotEmpty) {
                  Wishlist wishlist2 = Wishlist(
                      id: wishlist.id,
                      name: name,
                      author: author,
                      stateOfBook: stateOfBook,
                      description: description,
                      createdBy: wishlist.createdBy,
                      created: wishlist.created);
                  bool? result = await updateWishlist(wishlist2);
                  print(result);
                  if (result == true) {
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Güncelleme başarısız oldu. Lütfen tekrar deneyin.'),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Lütfen tüm alanları doldurun.'),
                    ),
                  );
                }
              },
              child: Text('Güncelle'),
            ),
          ],
        );
      },
    );
  }
}
