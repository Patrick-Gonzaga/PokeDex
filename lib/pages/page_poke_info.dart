import 'package:flutter/material.dart';

class PokeInfoPage extends StatelessWidget {
  final Map<String, dynamic> pokemon;

  const PokeInfoPage({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${pokemon['name'].toString()[0].toUpperCase() + pokemon['name'].toString().substring(1).toLowerCase()}',
        ),
        backgroundColor: Color(0xFFC3FF68),
        shadowColor: Colors.black,
        elevation: 10,
      ),
      backgroundColor: Color(0xFF171F25),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 40),
                      height: 290,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: BoxBorder.fromBorderSide(
                          BorderSide(color: Color(0xFFC3FF68), width: 2),
                        ),
                      ),
                      child: Image.network(
                        height: 300,
                        width: 300,
                        pokemon['sprites']['other']['home']['front_default'],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      left: 0,
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          color: Color(0xFFC3FF68),
                        ),
                        child: Center(
                          child: Text(
                            pokemon['name'].toString()[0].toUpperCase() +
                                pokemon['name']
                                    .toString()
                                    .substring(1)
                                    .toLowerCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF171F25),
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                pokeTypeRow(pokemon['types']),
                for (int i = 0; i < pokemon['stats'].length; i++)
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: pokeInfoRow(
                      pokemon['stats'][i]['stat']['name']
                              .toString()[0]
                              .toUpperCase() +
                          pokemon['stats'][i]['stat']['name']
                              .toString()
                              .substring(1),
                      pokemon['stats'][i]['base_stat'].toString(),
                    ),
                  ),

                /*List.generate(pokemon['stats'].length, (i){
                  return pokeInfoRow(
                  pokemon['stats'][i]['stat']['name']
                      .toString()[0]
                      .toUpperCase() +
                  pokemon['stats'][1]['stat']['name'].toString().substring(
                  1,
                  ),
                  pokemon['stats'][1]['base_stat'].toString(),
                  )
                })*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget pokeInfoRow(String info, String value) {
    return Row(
      spacing: 0,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              color: Color(0xFFC3FF68),
            ),
            child: Center(child: Text(info)),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              border: Border.fromBorderSide(
                BorderSide(color: Color(0xFFC3FF68), width: 2),
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Center(
              child: Text(
                value,
                style: TextStyle(fontSize: 18, color: Color(0xFFC3FF68)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget pokeTypeRow(List<dynamic> pokeTypes) {
    print(pokemon['stats'].length);
    return Row(
      spacing: 0,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              color: Color(0xFFC3FF68),
            ),
            child: Center(child: Text('Pokémon-Type')),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              border: Border.fromBorderSide(
                BorderSide(color: Color(0xFFC3FF68), width: 2),
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: pokeTypes.length > 1
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 4,
                    children: [
                      Image.asset(
                        'assets/type_badges/${pokeTypes[0]['type']['name']}.png',
                        scale: 0.6,
                      ),
                      Image.asset(
                        'assets/type_badges/${pokeTypes[1]['type']['name']}.png',
                        scale: 0.6,
                      ),
                    ],
                  )
                : Center(
                    child: Image.asset(
                      'assets/type_badges/${pokeTypes[0]['type']['name']}.png',
                      scale: 0.6,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
