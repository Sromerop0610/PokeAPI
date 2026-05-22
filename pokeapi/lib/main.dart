import 'package:flutter/material.dart';
import 'screen/pokemon_menu.dart'; // <--- O la ruta exacta donde guardaste tu menú

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),
      home: const PokemonMenuScreen(), // <--- Tu pantalla principal
    );
  }
}