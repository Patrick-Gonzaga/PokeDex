import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

import 'package:transparent_image/transparent_image.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Home());
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }
  List<Map<String, dynamic>> pokeList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF171F25),
      appBar: AppBar(
        title: Text('Pokédex', style: TextStyle(color: Color(0xFF171F25))),
        backgroundColor: Color(0xFFC3FF68),
        actions: [
          ElevatedButton(onPressed: _deleteCache, child: Icon(Icons.delete)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Pokémon',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFC3FF68)),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFC3FF68)),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFC3FF68)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFC3FF68)),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _getInfos(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: AlignmentGeometry.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                          strokeWidth: 5,
                        ),
                      );
                    default:
                      List<Map<String, dynamic>> dataMap = snapshot.data!;

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemCount: dataMap.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: Stack(
                              children: [
                                FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image:
                                      dataMap[index]['sprites']['other']['home']['front_default'],
                                  height: double.maxFinite,
                                  fit: BoxFit.cover,
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey,
                                          child: Icon(
                                            Icons.error,
                                            color: Colors.white,
                                          ),
                                        );
                                      },
                                ),
                                Positioned(
                                  bottom: 4,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    color: Colors.black54,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 2,
                                    ),
                                    child: Text(
                                      dataMap[index]["id"].toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<File> _getFileDirectory() async {
    final directory = await getApplicationDocumentsDirectory();

    return File('${directory.path}/data.json');
  }

  Future<List<Map<String, dynamic>>> _getInfos() async {

    File file = await _getFileDirectory();
    if (await file.exists()) {
      String fileContent = await file.readAsString();
      if (fileContent.isNotEmpty) {
        List<dynamic> decodedList = jsonDecode(fileContent);
        pokeList = decodedList.cast<Map<String, dynamic>>().toList();
        return pokeList;
      }
    }
    http.Response responseCount = await http.get(
      Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=1&offset=0'),
    );
    int pokeCount = json.decode(responseCount.body)["count"];

    print('$pokeCount / ${pokeCount.runtimeType}');

    int batch = 50;

    for (int start = 1; start <= pokeCount; start += batch) {
      int end = (start + batch - 1) > pokeCount
          ? pokeCount
          : (start + batch - 1);

      List<Future<http.Response>> requests = [];
      for (var i = start; i <= end; i++) {
        requests.add(
          http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$i/')),
        );
      }

      List<http.Response> responses = await Future.wait(requests);

      for (var response in responses) {
        if (response.statusCode == 200) {
          try {
            pokeList.add(json.decode(response.body));
          } catch (e) {
            print(e);
          }
        } else {
          print('Erro na requisição: ${response.statusCode}');
        }
      }
    }

    print(pokeList);

    await file.writeAsString(jsonEncode(pokeList));

    return pokeList;
  }

  Future<void> _deleteCache() async {
    File file = await _getFileDirectory();
    if (await file.exists()) {
      await file.delete();
      print('🗑️ Arquivo cache deletado!');
    } else {
      print('📁 Arquivo não existe');
    }
  }
}
