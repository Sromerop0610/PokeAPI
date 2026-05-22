import 'package:flutter/material.dart';

import 'screen/pokemon_menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'Pokédex',

      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),

      home: const PokemonMenuScreen(),
    );
  }
}