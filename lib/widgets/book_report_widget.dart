import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReportBook extends StatefulWidget {
  final int reportedBookId;
  final String reportingUserId;

  ReportBook({required this.reportedBookId, required this.reportingUserId});

  @override
  _ReportBookState createState() => _ReportBookState();
}

class _ReportBookState extends State<ReportBook> {
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
  String _selectedReportType = 'Hakaret';

  final List<String> _reportTypes = [
    'Hakaret',
    'Uygunsuz İçerik',
    'Spam',
    'Diğer'  // Example of an additional type
  ];

  Future<void> sendReport() async {
    DateTime now = DateTime.now();
    String formattedDate = now.toIso8601String();
    setState(() {
      _isLoading = true;
    });
    try {
      var response = await http.post(
        Uri.parse('https://bookcycle.azurewebsites.net/api/Report/book'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'reportType': _selectedReportType,
          'reportingUserId': widget.reportingUserId,
          'reportedBookId': widget.reportedBookId,
          'description': _descriptionController.text,
          'reportDate': formattedDate
        }),
      );
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Şikayetiniz bize ulaştı!"))
        );// Dismiss the dialog on success
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Şikayetiniz iletilemedi!"))
        );
      }
    } catch (e) {
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
      title: Text('İlanı Şikayet Et'),
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
