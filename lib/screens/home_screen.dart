import 'dart:convert';
import 'dart:async';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var characters;
  bool? isLoading;

  Future getCharList() async {
    setState(() {
      isLoading = true;
    });
    var data = await getCharsJSON();
    setState(() {
      isLoading = false;
      characters = data['results'];
    });
  }

  Future<Map> getCharsJSON() async {
    var url = Uri.parse("https://api.disneyapi.dev/character");
    var response = await http.get(url);

    return jsonDecode(response.body);
  }

  @override
  void initState() {
    super.initState();
    getCharList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Unit 7 - API Calls"),
      ),
      body: ListView(padding: const EdgeInsets.all(16.0), children: [
        Column(children: [
          FutureBuilder(
            // setup the URL for your API here
            future: getCharsJSON(),
            builder: (BuildContext ctx, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {}

              // Consider 3 cases here
              // when the process is ongoing
              if (snapshot.connectionState != ConnectionState.done) {
                  return CircularProgressIndicator();
              }
              // when the process is completed:

              // successful
              if (snapshot.hasData) {
                var data = snapshot.data as Map;
                var result = data['data'];
                print(result);
                               
                // Use the library here
                return ExpandedTileList.builder(
                    itemCount: result.length,
                    itemBuilder: (context, index, con) {
                      return ExpandedTile(
                          title: Text(result[index]['name']),
                          content: Column(
                            children: [
                              Text("Name: " + result[index]['name']),
                              Container(
                                padding: EdgeInsets.all(5.0),
                                child: Image.network(result[index]['imageUrl']),
                              )
                            ],
                          ),
                          controller: con);
                    });
              }
              // error
              if (snapshot.hasError) {
                return Text('There seems to be a problem. ${snapshot.error}');
              }
              
              return Container();
            },
          ),
        ])
      ]),
    );
  }
}
