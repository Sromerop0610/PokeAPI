import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../screen/detalles-pokemon.dart';
import '../screen/team_screen.dart';

class PokemonMenuScreen extends StatefulWidget {
  const PokemonMenuScreen({super.key});

  @override
  State<PokemonMenuScreen> createState() => _PokemonMenuScreenState();
}

class _PokemonMenuScreenState extends State<PokemonMenuScreen> {

  List<dynamic> _pokemonList = [];
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _obtenerListaPokemon();
  }

  Future<void> _obtenerListaPokemon() async {

    try {

      final url = Uri.parse(
        'https://pokeapi.co/api/v2/pokemon?limit=151',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        setState(() {
          _pokemonList = data['results'];
          _cargando = false;
        });

      } else {
        setState(() {
          _error = "Error al cargar Pokémon";
          _cargando = false;
        });
      }

    } catch (e) {
      setState(() {
        _error = "Error de conexión";
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if (_cargando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(child: Text(_error!)),
      );
    }

    return Scaffold(

      appBar: AppBar(
        title: const Text("Pokédex"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,

        actions: [
          IconButton(
            icon: const Icon(Icons.groups),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TeamScreen(),
                ),
              );
            },
          )
        ],
      ),

      body: ListView.builder(
        itemCount: _pokemonList.length,

        itemBuilder: (context, index) {

          final pokemon = _pokemonList[index];

          final name = pokemon['name'];
          final url = pokemon['url'];

          final id = url.split('/')[url.split('/').length - 2];

          final imageUrl =
              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

          return Card(

            child: ListTile(

              leading: Image.network(imageUrl),

              title: Text(name.toUpperCase()),

              subtitle: Text("#$id"),

              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        DetallesPokemon(pokemonName: name),
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