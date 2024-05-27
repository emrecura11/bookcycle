import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dart:io';

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
      drawer: ProfileDrawer(userId: userId,),
      backgroundColor: Colors.white,

      floatingActionButton: _userIsCurrent && _isShowingWishlist
          ? FloatingActionButton(
        onPressed: () {
          _showAddWishlistDialog(context);
        },
        child: Icon(Icons.add),
      ) : null,

   

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
                      icon: const Icon(Icons.menu, color: Colors.black),
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
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
                    backgroundImage:user.userImage != null
                        ? (user.userImage!.startsWith('http')
                        ? NetworkImage(user.userImage!) // URL olarak kullan
                        : MemoryImage(base64Decode(user.userImage!)) as ImageProvider<Object>) // Base64 string
                        : const AssetImage('images/logo_bookcycle.jpeg'),
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
                    user.location??'Bilinmiyor',
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
                    const Icon(
                      Icons.messenger,
                      color: Color(0xFF88C4A8),
                    ),
                    BasicButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(senderId: userId, receiverId: user.id,),
                          ),
                        );
                      },
                      buttonText: "Get Contact",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Divider(
                color: Colors.black,
                height: 1,
                thickness: 0.5,
              ),
              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isShowingWishlist = false;
                        });
                      },
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "İlanlarım",
                          style: TextStyle(
                            fontSize: 18,
                            color: _isShowingWishlist ? Colors.black : Colors.deepOrange.shade300,
                            fontWeight: FontWeight.bold,
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
                        child: Text(
                          "İstek Listesi",
                          style: TextStyle(
                            fontSize: 18,
                            color: _isShowingWishlist ? Colors.deepOrange.shade300 : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),

                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                child: _isShowingWishlist ? _buildWishlistListView() : _buildAdvertisementListView(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 4,),
    );
  }

  Widget _buildWishlistListView() {
    List<Wishlist> wishlist2 = [];
    wishlists.forEach((element) {
      if(element.createdBy == user.id){
        wishlist2.add(element);
      }
    });
    return SizedBox(
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
            onTap: () {

            },
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    wishlist2[index].name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,

                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Visibility(
                                    visible: _userIsCurrent,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.restore_from_trash,
                                        color: Colors.amber,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Wishlist'i sil"),
                                              content: Text("Bu wishlist öğesini silmek istediğinize emin misiniz?"),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text("İptal"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text("Sil"),
                                                  onPressed: () {
                                                    deleteWishlist(wishlist2[index].id);
                                                    setState(() {
                                                      wishlist2.remove(wishlist2[index]);
                                                    });// Wishlist'i sil
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),

                                ],
                              ),
                              Text("Yazar: ${wishlist2[index].author}"),
                              Text("Durum: ${wishlist2[index].stateOfBook}"),
                              Text("Açıklama\n ${wishlist2[index].description}"),

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
    // Burada reklam listview'i oluşturulacak
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
                  builder: (context) => BookDetailsPage(
                    bookFuture: getBookById(books[index].id),
                  ),
                ),
              );
            },
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                                      child: book.bookImage != null &&
                                          book.bookImage!.isNotEmpty
                                          ? Image.memory(
                                        base64Decode(base64.normalize(
                                            book.bookImage!)),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        },
      ),
    );
  }

  Future<void> fetchWishlists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtoken');
    final response = await http.get(Uri.parse('https://bookcycle.azurewebsites.net/api/v1/Wishlist'),
        headers: {'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'});

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

  Future<void> addWishlist(String name, String author, String stateOfBook, String description) async {
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
      Uri.parse('https://bookcycle.azurewebsites.net/api/v1/Wishlist/$wishlistId'),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
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
          title: Text('Yeni Wishlist Ekle'),
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
                if (name.isNotEmpty && author.isNotEmpty && stateOfBook.isNotEmpty && description.isNotEmpty) {
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

}
