import 'dart:convert';
import 'dart:io';

import 'package:code_hero/models/Character.dart';
import 'package:code_hero/services/marvel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class HomePage extends StatefulWidget {
  // const HomePage({super.key });

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  // final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String characterName = '';
  List<int> indexPages = [1, 2, 3];
  int currentPage = 1;
  int totalPages = 3;
  int itemsPerPage = 4;
  int totalCharacters = 0;
  int totalItensPages = 0;

  Services services = Services();
  // List<Widget> _characters = [];
  List<Character> characters = [];

  Future<Map<String, dynamic>> carregarArquivoJson() async {
    // Carrega o arquivo JSON do diretório de ativos
    String jsonString = await rootBundle.loadString('data.json');

    // Converte a string JSON em um mapa ou lista, dependendo do formato do JSON
    var data = jsonDecode(jsonString) as Map<String, dynamic>;

    // Use os dados carregados conforme necessário
    return data;
  }

  processCharacters() async {
    final offset = (currentPage - 1) * 4;
    final charactersResponse =
        await services.getCharacters(name: characterName, offset: offset);

    totalCharacters = charactersResponse['data']['total'];
    print(totalCharacters);
    totalItensPages = (totalCharacters / 4).ceil();
    print(totalItensPages);

    List<Character> charactersResult =
        (charactersResponse['data']['results'] as List)
            .map((character) => Character.fromJson(character))
            .toList();

    setState(() {
      characters = charactersResult;
    });

    // ARQUIVO

    // Map<String, dynamic> jsonData = await carregarArquivoJson();

    // setState(() {
    //   characters = (jsonData['data']['results'] as List)
    //     .map((character) => Character.fromJson(character))
    //     .toList();
    // });

    // return characters;
  }

  getListData(List<Character> characters) {
    List<Widget> widgets = [];

    for (final character in characters) {
      widgets.add(ListView.builder(itemBuilder: (context, index) {
        return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(character.thumbnailUrl),
              // child: Text(character.name),
            ),
            title: Text(character.name));
      }));
    }

    print(widgets);
    // setState(() {
    //   _characters = widgets;
    // });
  }

  handleTextChanged(String character) async {
    // Voltar para 1, resetar os campos e setar o valor total
    setPage(1);
    int index = 0;
    totalPages = 3;

    for (int i = 1; i <= totalPages; i++) {
      indexPages[index] = i;
      index++;
    }

    setCharacterName(character);
    await processCharacters();
  }

  setPage(int page) {
    setState(() {
      currentPage = page;
    });

    print(currentPage);
  }

  setCharacterName(String name) {
    setState(() {
      characterName = name;
    });
  }

  @override
  void initState() {
    super.initState();
    processCharacters();
    // .then((characters) => getListData(characters));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.black,
      //   title: Padding(
      //     padding: EdgeInsets.fromLTRB(20, 12, 0, 0),
      //     child: Row(
      //       crossAxisAlignment: CrossAxisAlignment.end,
      //       children: [
      //         Container(
      //           decoration: BoxDecoration(
      //             border: Border(
      //               bottom: BorderSide(width: 0.8, color: HexColor('#D42026')),
      //             ),
      //           ),
      //           child: Text(
      //             'BUSCA',
      //             style: TextStyle(
      //               fontSize: 16,
      //               fontWeight: FontWeight.bold,
      //               color: HexColor('#D42026'),
      //             ),
      //           ),
      //         ),
      //         Text(
      //           ' MARVEL ',
      //           style: TextStyle(
      //             fontSize: 16,
      //             fontWeight: FontWeight.bold,
      //             color: HexColor('#D42026'),
      //           ),
      //         ),
      //         Text(
      //           'TESTE FRONT-END',
      //           style: TextStyle(
      //             fontSize: 16,
      //             color: HexColor('#D42026'),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(30, 12, 0, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Stack(
                    children: [
                      Text(
                        'BUSCA',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: HexColor('#D42026'),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 2, color: HexColor('#D42026'))),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    ' MARVEL ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: HexColor('#D42026'),
                    ),
                  ),
                  Text(
                    'TESTE FRONT-END',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w200,
                      color: HexColor('#D42026'),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 25, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Text(
                        'Nome do Personagem',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: HexColor('#D42026'), fontFamily: 'Roboto'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 12),
                      child: SizedBox(
                        height: 30.0,
                        child: TextField(
                          onChanged: handleTextChanged,
                          // controller: _textController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10.0),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
            Container(
              width: double.infinity,
              height: 35,
              color: HexColor('#D42026'),
              alignment: Alignment.center,
              padding: EdgeInsets.only(right: 150),
              child: Text(
                'Nome',
                style: TextStyle(
                    fontSize: 14, fontFamily: 'Roboto', color: Colors.white),
              ),
            ),
            Expanded(
              child: ListView.separated(
                // physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => Divider(
                  color: HexColor('#D42026'),
                  thickness: 1,
                  height: 0,
                ),
                itemCount: characters.length,
                itemBuilder: (context, index) {
                  Character character = characters[index];

                  if (index == characters.length - 1) {
                    return Column(
                      children: [
                        ListTile(
                          onTap: () => {
                            Navigator.pushNamed(context, '/details',
                                arguments: character)
                          },
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 18),
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage:
                                NetworkImage(character.thumbnailUrl),
                          ),
                          title: Text(character.name),
                        ),
                        Divider(
                          color: HexColor('#D42026'),
                          thickness: 1,
                          height: 0,
                        ),
                      ],
                    );
                  }

                  return ListTile(
                    onTap: () => {
                      Navigator.pushNamed(context, '/details',
                          arguments: character)
                    },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(character.thumbnailUrl),
                    ),
                    title: Text(character.name),
                  );
                },
              ),
            ),
            Container(
              // padding: EdgeInsets.fromLTRB(0, 18, 0, 24),
              height: 80, // Altura do container
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: HexColor(
                        '#D42026'), // Define a cor vermelha para a borda inferior
                    width: 6, // Define a largura da borda
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: currentPage > 1
                        ? () async {
                            if (currentPage - 1 < indexPages[0]) {
                              int index = 0;

                              for (int i = indexPages[0] - 3;
                                  i <= totalPages - 3;
                                  i++) {
                                indexPages[index] = i;
                                index++;
                              }

                              totalPages = totalPages - 3;
                            }

                            setState(() {
                              currentPage--;
                            });

                            await processCharacters();
                          }
                        : null,
                    icon: Icon(Icons.arrow_left,
                        size: 60, // Tamanho do ícone
                        color: currentPage > 1
                            ? HexColor('#D42026')
                            : Colors.grey),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          setPage(indexPages[0]);
                          await processCharacters();
                        },
                        child: Container(
                          width: 30,
                          height: 40,
                          decoration: BoxDecoration(
                            color: indexPages[0] == currentPage
                                ? HexColor('#D42026')
                                : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: HexColor('#D42026'),
                              width: 1,
                            ),
                          ),
                          padding: EdgeInsets.all(5),
                          child: Center(
                            child: Text(
                              indexPages[0].toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: indexPages[0] == currentPage
                                    ? Colors.white
                                    : HexColor('#D42026'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if(indexPages[1] <= totalItensPages)
                      SizedBox(
                          width:
                              15), // Adiciona um espaço de 8 pixels entre os botões
                      if (indexPages[1] <= totalItensPages)
                        GestureDetector(
                          onTap: () async {
                            setPage(indexPages[1]);
                            await processCharacters();
                          },
                          child: Container(
                            width: 30,
                            height: 40,
                            decoration: BoxDecoration(
                              color: indexPages[1] == currentPage
                                  ? HexColor('#D42026')
                                  : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: HexColor('#D42026'),
                                width: 1,
                              ),
                            ),
                            padding: EdgeInsets.all(5),
                            child: Center(
                              child: Text(
                                indexPages[1].toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: indexPages[1] == currentPage
                                      ? Colors.white
                                      : HexColor('#D42026'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if(indexPages[2] <= totalItensPages)
                      SizedBox(
                          width:
                              15),
                      if (indexPages[2] <= totalItensPages)
                        GestureDetector(
                          onTap: () async {
                            setPage(indexPages[2]);
                            await processCharacters();
                          },
                          child: Container(
                            width: 30,
                            height: 40,
                            decoration: BoxDecoration(
                              color: indexPages[2] == currentPage
                                  ? HexColor('#D42026')
                                  : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: HexColor('#D42026'),
                                width: 1,
                              ),
                            ),
                            padding: EdgeInsets.all(5),
                            child: Center(
                              child: Text(
                                indexPages[2].toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: indexPages[2] == currentPage
                                      ? Colors.white
                                      : HexColor('#D42026'),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  IconButton(
                    onPressed: currentPage <= totalPages &&
                            currentPage < totalItensPages
                        ? () async {
                            if (currentPage + 1 > totalPages) {
                              int index = 0;

                              for (int i = totalPages + 1;
                                  i <= totalPages + 3;
                                  i++) {
                                indexPages[index] = i;
                                index++;
                              }

                              totalPages = totalPages + 3;
                            }

                            setState(() {
                              currentPage++;
                            });

                            print(currentPage);
                            await processCharacters();
                          }
                        : null,
                    icon: Icon(Icons.arrow_right,
                        size: 60,
                        color: currentPage >= totalItensPages
                            ? Colors.grey
                            : HexColor('#D42026')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}