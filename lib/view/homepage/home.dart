import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/model.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyHomePage> {
  List<CountryList> countriesInfoList = [];
  bool isLoading = true;

  Future<void> fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });

      var url = Uri.parse("https://portal.crowdafrik.com/api/get-countries");
      var response = await http.get(url);

      if (response.statusCode == 200) {
        print('Response code: ${response.statusCode}');
        print('Response body: ${response.body}');

        List<dynamic> responseData = jsonDecode(response.body);
        countriesInfoList =
            responseData.map((data) => CountryList.fromJson(data)).toList();
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during data fetching: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("COUNTRIES LIST"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await fetchData();
        },
        child: Icon(Icons.add),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: countriesInfoList.length,
              itemBuilder: (context, index) {
                CountryList country = countriesInfoList[index];
                return Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network("Image: ${country.image}"),
                      Text("Country Name: ${country.title}"),
                      Text("Price: ${country.price}"),
                      Text("Description: ${country.description}"),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
