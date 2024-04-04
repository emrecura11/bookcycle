import 'package:flutter/material.dart';

import '../widgets/bottomnavbar.dart';

class BookDetailsPage extends StatelessWidget {
  // Bu sadece bir placeholder fonksiyon.
  // Gerçek uygulamada, gerekli işlevselliği eklemeniz gerekecek.
  void onBookmarkPressed() {
    // İşaretleme işlevselliğini buraya ekleyin
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite_border),
            color: Colors.black,
            onPressed: onBookmarkPressed,
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Placeholder for image carousel
            Container(
              height: 250,
              color: Colors.grey, // Placeholder color
              child: Center(child: Text('Image Carousel Placeholder')),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Row(
                    children: <Widget>[
                      Text(
                        'Book1',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Row(
                            children: <Widget>[
                              Icon(Icons.volunteer_activism,color: Colors.deepOrange.shade300, ),
                              SizedBox(width: 4),
                              Text(
                                'Askıda Kitap',
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),

                            ],
                          ),

                    ],
                  ),
                  SizedBox(height: 8.0),

                  Row(
                    children: <Widget>[
                      Icon(Icons.location_on, color: Colors.grey),
                      SizedBox(width: 4.0),
                      Text('Antalya'),
                      Spacer(),
                      Text('02/04/2024'),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Bilgi',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),


                  SizedBox(height: 8.0),// Spacing after the section title
                  Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Yazar:',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('John Doe'), // Replace with actual author name
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Durum:',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('Yeni gibi'), // Replace with actual condition
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Tür:',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('Roman'), // Replace with actual genre
                            ],
                          ),
                        ),
                      ],
                    ),

                  SizedBox(height: 16.0),
                  Text(
                    'Açıklama',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 8.0),
              SingleChildScrollView(
                child:Container(
                    padding: EdgeInsets.all(16.0),
                    color: Colors.grey[200],
                    width: MediaQuery.of(context).size.width*0.9, // Sabit genişlik
                    height: MediaQuery.of(context).size.height*0.2, // Sabit yükseklik
                    child: Text(
                      'Farabi’ye göre, felsefenin dört klasik sorusundan “ne yapmalı?”, “neyi bilebiliriz?” ve “insan nedir?” soruları, “varlık nedir?” sorusuna bağımlıdır. Varlık nedir sorusu cevaplandırıldığı zaman diğer soruların cevabı da belirlenmiş olur. Farabi’nin felsefesi, ahlak ve metafizik anlayışını birbirinden bağımsız olarak değerlendirmek yanlış olacaktır.',
                      overflow: TextOverflow.clip, // Uzun metin kesilir
                    ),
                  ),
              ),
                  SizedBox(height: 16.0),
                  const Divider(
                    color: Colors.black,
                    height: 2,
                    thickness: 1,
                  ),

                  ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('images/logo_bookcycle.jpeg'),
                    ),
                    title: Text('Dilara Aksoy'),
                    trailing: Icon(Icons.arrow_forward),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.deepOrange.shade300,
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        ),
                        child: Text('İletişim Kur',
                          style: TextStyle(
                            fontSize: 11.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),),
                        onPressed: () {


                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.deepOrange.shade300,
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        ),
                        child: Text('İstek Listesi',
                          style: TextStyle(
                            fontSize: 11.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),),
                        onPressed: () {


                        },
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.black,
                    height: 2,
                    thickness: 1,
                  ),
                  SizedBox(height: 16.0),
                  Text('İlan no:3782368'),

                ],
              ),
            ),
          ],
        ),
      ),


    );
  }
}
