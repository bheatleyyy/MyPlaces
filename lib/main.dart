import 'package:flutter/material.dart';
import 'place.dart';
import 'splashpage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashPage(),
    );
  }
}

class PlacePage extends StatefulWidget {
  const PlacePage({super.key});

  @override
  State<PlacePage> createState() => _PlacePageState();
}

class _PlacePageState extends State<PlacePage> {
  List<Place> placeList = [];
  bool loading = true;
  String errorMsg = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }
  void loadData() async {
    const String url =
        "https://slumberjer.com/teaching/a251/locations.php?state=&category=&name=";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        setState(() {
          placeList = data.map((e) => Place.fromJson(e)).toList();
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
          errorMsg = "Failed to load data. Please try again later.";
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
        errorMsg = "Unable to connect. Please check your internet connection.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interesting Places in Malaysia',
        style: TextStyle(fontSize: 24)
        ),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : errorMsg.isNotEmpty
              ? Center(child: Text(errorMsg))
              : placeList.isEmpty
                  ? const Center(
                      child: Text(
                        "No data found. Try again later!",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: placeList.length,
                      itemBuilder: (context, index) {
                        Place p = placeList[index];
                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            leading: Image.network(
                              p.image_url,
                              width: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) =>
                                  const Icon(Icons.broken_image),
                            ),
                            title: Text(p.name),
                            subtitle: Row(
                              children: [
                                Text("${p.state} • "),
                                Text("Rating: ${p.rating}"),
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                              ],
                            ),
                                onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(p.name),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.network(
                                          p.image_url,
                                          fit: BoxFit.cover,
                                          errorBuilder: (c, e, s) =>
                                              const Icon(Icons.broken_image),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(p.description),
                                        const SizedBox(height: 10),
                                        Text(
                                            "Contact: ${p.contact.isEmpty ? 'N/A' : p.contact}"),
                                        Text(
                                            "Category: ${p.category}"),
                                        Text(
                                            "Latitude: ${p.latitude}"),
                                        Text(
                                            "Longitude: ${p.longitude}"),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context),
                                      child: const Text("Close"),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}
