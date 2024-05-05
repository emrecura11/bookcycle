import 'package:bookcycle/widgets/basic_button.dart';
import 'package:bookcycle/widgets/drawer_profile.dart';
import 'package:flutter/material.dart';

import '../models/Book.dart';
import '../widgets/bottomnavbar.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyAdvertisements(),
    );
  }
}

class MyAdvertisements extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Book> books = [

  ];

  final List<List<Color>> colorPairs = [
    /*[Color(0xFFFFBA78), Colors.white],
    [Color(0xFFFFCC84), Colors.white],
    [Color(0xFFFFD991), Colors.white],
    [Color(0xFFFFE69E), Colors.white],*/

    [Color(0xFFee8959), Colors.white],
    [Color(0xFFf4a261), Colors.white],
    [Color(0xFFdda15e), Colors.white],
    [Color(0xFFf26b21), Colors.white],
  ];

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
              const SizedBox(height: 50,),

                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, size: 24.0),
                  ),

                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "My Advertisements",
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

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Horizontal ve vertical margin
                      elevation: 5, // gölge efekti
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: gradient,
                          borderRadius: BorderRadius.circular(10), // Köşe yarıçapı
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.horizontal(left: Radius.circular(8), right:Radius.circular(8)),
                                    child: books[index].bookImage != null
                                        ? Image.asset(
                                      books[index].bookImage!,
                                      fit: BoxFit.cover,
                                    ):Placeholder(),
                                  ),
                                ),
                                flex: 1, // Görselin genişlik payını ayarla
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
                                          if(books[index].isAskida)
                                            Icon(Icons.volunteer_activism, color: Color(0xFF76C893),)
                                          else
                                            Icon(Icons.volunteer_activism_outlined, color: Color(0xFF76C893),)
                                        ],
                                      ),
                                      Text("Yazar: ${books[index].author}"),
                                      Text("Kategori: ${books[index].genre}"),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Kullanıcı: ${books[index].createdBy}"),
                                          Text("Tarih: ${books[index].created}"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                flex: 3, // Metinlerin genişlik payı
                              ),
                            ],
                          ),
                        ),
                      ),
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
