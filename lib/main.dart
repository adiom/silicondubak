import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSON Table App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Replace the URL with the actual URL of your JSON file
      Uri url = Uri.parse('https://example.com/data.json');
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          data = json.decode(response.body);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JSON Table App'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            columns: [
              DataColumn(label: Text('Posting Number')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Shipment Date')),
              DataColumn(label: Text('Products')),
              DataColumn(label: Text('PDF')),
            ],
            sortColumnIndex: 0,
            sortAscending: true,
            columnSpacing: 20.0,
            rows: data.map((item) {
              return DataRow(
                cells: [
                  DataCell(Text(item['posting_number'])),
                  DataCell(Text(item['status'])),
                  DataCell(Text(item['shipment_date'])),
                  DataCell(
                    DataTable(
                      columns: [
                        DataColumn(label: Text('Price')),
                        DataColumn(label: Text('Offer ID')),
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('SKU')),
                        DataColumn(label: Text('Quantity')),
                        DataColumn(label: Text('Currency Code')),
                      ],
                      rows: (jsonDecode(item['products']) as List).map((product) {
                        return DataRow(
                          cells: [
                            DataCell(Text(product['price'])),
                            DataCell(Text(product['offer_id'])),
                            DataCell(Text(product['name'])),
                            DataCell(Text(product['sku'].toString())),
                            DataCell(Text(product['quantity'].toString())),
                            DataCell(Text(product['currency_code'])),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  DataCell(
                    ElevatedButton(
                      onPressed: () {
                        // Handle PDF button click
                        print('PDF URL: ${item['pdf']}');
                      },
                      child: Text('Open PDF'),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
