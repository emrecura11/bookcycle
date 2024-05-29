import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserReportWidget extends StatefulWidget {
  final String reportingUserId;
  final String reportedUserId;

  UserReportWidget({required this.reportingUserId, required this.reportedUserId});

  @override
  _UserReportWidgetState createState() => _UserReportWidgetState();
}

class _UserReportWidgetState extends State<UserReportWidget> {
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedReportType = 'Hakaret'; // Default report type
  bool _isLoading = false;
  // List of report types can be expanded as needed
  final List<String> _reportTypes = ['Hakaret', 'Spam', 'Sahte Hesap','Uygusuz İçerik', 'Diğer'];

  Future<void> sendReport() async {
    DateTime now = DateTime.now();
    String formattedDate = now.toIso8601String();
    setState(() {
      _isLoading = true;
    });
    try {
    var url = Uri.parse('https://bookcycle.azurewebsites.net/api/Report/user');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'reportType': _selectedReportType,
        'reportingUserId': widget.reportingUserId,
        'reportedUserId': widget.reportedUserId,
        'description': _descriptionController.text,
        'reportDate': formattedDate,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.of(context).pop(); // Close the dialog on success
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Şikayetiniz bize ulaştı!"))
      );
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Şikayetiniz iletilemedi!"))
      );
    }}catch (e) {
      // Handle errors or show an error message
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
@override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey.shade200,  // Explicitly setting background color to white
      shape: RoundedRectangleBorder(  // Optional: to provide shape to AlertDialog
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      title: Text('Kullanıcıyı Şikayet Et'),
      titleTextStyle: TextStyle(  // Optional: setting title text style
          color: Colors.blue[900],
          fontSize: 20,
          fontWeight: FontWeight.bold
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Şikayet Türü:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900])),
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedReportType,
              underline: Container(
                height: 2,
                color: Colors.orange,
              ),
              icon: const Icon(Icons.arrow_drop_down_circle),
              iconEnabledColor: Colors.orange,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedReportType = newValue!;
                });
              },
              items: _reportTypes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(color: Colors.blue[900])),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text('Şikayet Detayı:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900])),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Şikayetinizi açıklayın',
                border: OutlineInputBorder(),
                fillColor: Color(0xFFFFFFFF),
                filled: true,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('İptal', style: TextStyle(color: Colors.orange)),
        ),
        TextButton(
          onPressed: _isLoading ? null : sendReport,
          child: Text('Gönder', style: TextStyle(color: Colors.blue[900])),
        ),
      ],
    );
  }
}
