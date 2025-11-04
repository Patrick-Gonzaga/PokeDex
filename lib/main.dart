import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_a_pokemon/pages/page_poke_info.dart';
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
    return MaterialApp(home: Home(), theme: ThemeData(fontFamily: 'pokemon'),);
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Map<String, dynamic>>> _future;
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> pokeList = [];
  List<Map<String, dynamic>> originalPokeList = [];

  @override
  void initState() {
    super.initState();
    _future = _getInfos();
  }

  late int pokeCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF171F25),
      appBar: AppBar(
        title: Text('Pokédex', style: TextStyle(color: Color(0xFF171F25))),
        backgroundColor: Color(0xFFC3FF68),
        actions: [
          ElevatedButton(
            onPressed: _deleteCache,
            child: Icon(Icons.delete),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Color(0xFF171F25)),
              foregroundColor: WidgetStatePropertyAll(Color(0xFFC3FF68)),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              setState(() {
                pokeList = [...originalPokeList];
              });
            },
            child: Icon(Icons.refresh),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Color(0xFF171F25)),
              foregroundColor: WidgetStatePropertyAll(Color(0xFFC3FF68)),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
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
                ),
                Container(
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () => searchPokemons(searchController.text),
                    child: Icon(Icons.search),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Color(0xFFC3FF68),
                      ),
                      foregroundColor: WidgetStatePropertyAll(
                        Color(0xFF171F25),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _future,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200,
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                              strokeWidth: 5,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Loading Pokémon\n(may take a while on first launch)',
                              textAlign: TextAlign.center,
                              // ✅ ADICIONADO: centraliza texto
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    default:
                      List<Map<String, dynamic>> dataMap = pokeList;

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,

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
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    color: Colors.black54,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 2,
                                    ),
                                    child: Text(
                                      "${dataMap[index]['name'].toString()[0].toUpperCase() +
                                          dataMap[index]['name']
                                            .toString()
                                            .substring(1)
                                            .toLowerCase()
                                          .toString()} #${dataMap[index]["id"]}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) =>
                                      PokeInfoPage(pokemon: dataMap[index])));
                            },
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
    http.Response responseCount = await http.get(
      Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=1&offset=0'),
    );
    pokeCount = json.decode(responseCount.body)["count"];


    if (await file.exists()) {
      String fileContent = await file.readAsString();
      if (fileContent.isNotEmpty) {
        List<dynamic> decodedList = jsonDecode(fileContent);
        pokeList = decodedList.cast<Map<String, dynamic>>().toList();
        return pokeList;
      }
    }

    print('$pokeCount / ${pokeCount.runtimeType}');

    await getPokemonApi(1, pokeCount);

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

  Future<void> getPokemonApi(int start, int pokeCount) async {
    int batch = 20;

    for (start; start <= pokeCount; start += batch) {
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
          print(json.decode(response.body)['name']);
          try {
            setState(() {
              pokeList.add(json.decode(response.body));
            });
          } catch (e) {
            print(e);
          }
        } else {
          print('Erro na requisição: ${response.statusCode}');
        }
      }
      await Future.delayed(Duration(milliseconds: 200));
    }
  }

  void searchPokemons(String searchText) {
    if (originalPokeList.isNotEmpty) {
      pokeList = [...originalPokeList];
    }
    originalPokeList = [...pokeList];
    List<Map<String, dynamic>> filterList = [];
    for (var pokemon in pokeList) {
      if (pokemon['name'].toString().contains(searchText.toLowerCase())) {
        filterList.add(pokemon);
      }
    }
    setState(() {
      pokeList = [...filterList];
    });
  }
}
