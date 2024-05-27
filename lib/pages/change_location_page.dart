

import 'package:bookcycle/widgets/bottomnavbar.dart';
import 'package:flutter/material.dart';

import '../widgets/basic_button.dart';
import '../widgets/basic_textfield.dart';

class ChangeLocation extends StatefulWidget {
  ChangeLocation({Key? key}) : super(key: key);

  @override
  _ChangeLocationState createState() => _ChangeLocationState();
}

class _ChangeLocationState extends State<ChangeLocation> {
  final addressDescriptionController = TextEditingController();
  final newPasswordController = TextEditingController();
  final newPasswordController2 = TextEditingController();
  String selectedCity = "City";

  List<String> items = ["Adana", "Adıyaman", "Afyonkarahisar", "Ağrı", "Amasya", "Ankara", "Antalya", "Artvin", "Aydın", "Balıkesir",
    "Bilecik", "Bingöl", "Bitlis", "Bolu", "Burdur", "Bursa", "Çanakkale", "Çankırı", "Çorum", "Denizli", "Diyarbakır", "Edirne",
    "Elazığ", "Erzincan", "Erzurum", "Eskişehir", "Gaziantep", "Giresun", "Gümüşhane", "Hakkari", "Hatay", "Isparta", "Mersin",
    "İstanbul", "İzmir", "Kars", "Kastamonu", "Kayseri", "Kırklareli", "Kırşehir", "Kocaeli", "Konya", "Kütahya", "Malatya", "Manisa",
    "Kahramanmaraş", "Mardin", "Muğla", "Muş", "Nevşehir", "Niğde", "Ordu", "Rize", "Sakarya", "Samsun", "Siirt", "Sinop", "Sivas",
    "Tekirdağ", "Tokat", "Trabzon", "Tunceli", "Şanlıurfa", "Uşak", "Van", "Yozgat", "Zonguldak", "Aksaray", "Bayburt", "Karaman",
    "Kırıkkale", "Batman", "Şırnak", "Bartın", "Ardahan", "Iğdır", "Yalova", "Karabük", "Kilis", "Osmaniye", "Düzce"];

  String selectedNeighborhood = "Neighborhood";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                const Text(
                  "Change Location",
                  style: TextStyle(
                    fontFamily: 'Kurale',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                BasicButton(
                  onTap: () {
                    showSnackBar(context, "Location");
                  },
                  buttonText: "Get Location",
                ),
                const SizedBox(height: 20),
                BasicTextfield(
                  controller: addressDescriptionController,
                  hintText: 'Address Description',
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                DropdownButton<String>(
                  items: items.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCity = value!;
                    });
                  },
                  hint: Text(selectedCity),
                  dropdownColor: const Color(0xFFEFECDC),


                ),
                const SizedBox(height: 20),
                DropdownButton<String>(
                  items: items.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedNeighborhood=value!;
                    });
                  },
                  hint: Text(selectedNeighborhood),

                  dropdownColor: const Color(0xFFEFECDC),

                ),

                const SizedBox(height: 30),

                BasicButton(
                  onTap: () {
                    if (addressDescriptionController.text.isNotEmpty) {
                      showSnackBar(context, "Location change successfully");
                    } else {
                      showSnackBar(
                          context, "Address Description can not be empty");
                    }
                  },
                  buttonText: "Confirm",
                ),
              ],
            ),
          ),
        ),
      ),

    );

  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
