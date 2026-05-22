import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'detalles-pokemon.dart';
import 'type_chart_screen.dart'; 
// import 'team_screen.dart';

class PokemonMenuScreen extends StatefulWidget {
  const PokemonMenuScreen({super.key});

  @override
  State<PokemonMenuScreen> createState() => _PokemonMenuScreenState();
}

class _PokemonMenuScreenState extends State<PokemonMenuScreen> {
  List<dynamic> _pokemonList = [];
  List<dynamic> _filteredList = [];

  bool _cargando = true;
  String? _error;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _obtenerListaPokemon();
  }

  Future<void> _obtenerListaPokemon() async {
    try {
      final url = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=151');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          _pokemonList = data['results'];
          _filteredList = _pokemonList;
          _cargando = false;
        });
      } else {
        setState(() {
          _error = 'Error al cargar el menú desde el servidor';
          _cargando = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error de red: No se pudo conectar a la PokéAPI';
        _cargando = false;
      });
    }
  }

  void _filtrarPokemon(String query) {
    final filtered = _pokemonList.where((pokemon) {
      final name = pokemon['name'].toString().toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredList = filtered;
    });
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
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text(_error!)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(Icons.table_chart),
            tooltip: "Tabla de tipos",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TypeChartScreen(),
                ),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.groups),
            tooltip: "Tu equipo",
            onPressed: () {
              // Aquí luego pondréis el TeamScreen
              // Navigator.push(context, MaterialPageRoute(builder: (_) => const TeamScreen()));
            },
          ),
        ],
      ),

      body: Column(
        children: [

          // 🔎 BUSCADOR
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              onChanged: _filtrarPokemon,
              decoration: InputDecoration(
                hintText: "Buscar Pokémon...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // 📋 LISTA
          Expanded(
            child: ListView.builder(
              itemCount: _filteredList.length,
              itemBuilder: (context, index) {
                final pokemonItem = _filteredList[index];
                final String name = pokemonItem['name'];

                final String url = pokemonItem['url'];
                final id = url.split('/')[url.split('/').length - 2];

                final String imageUrl =
                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: Image.network(
                      imageUrl,
                      width: 55,
                      height: 55,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.catching_pokemon),
                    ),
                    title: Text(
                      name.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Número: #$id'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),

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
          ),
        ],
      ),
    );
  }
}