import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'detalles-pokemon.dart'; // <-- Cambia esto por la ruta real del archivo de tu compañero

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

  // 1. Petición HTTP para traer los primeros 20 Pokémon
  Future<void> _obtenerListaPokemon() async {
    try {
      final url = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=20');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          _pokemonList = data['results'];
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

  @override
  Widget build(BuildContext context) {
    // Pantalla de carga
    if (_cargando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Pantalla de error por si falla el internet o la API
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text(_error!)),
      );
    }

    // 2. El menú principal con la lista de Pokémon
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex - Menú'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _pokemonList.length,
        itemBuilder: (context, index) {
          final pokemonItem = _pokemonList[index];
          final String name = pokemonItem['name'];
          
          // Extraemos el ID desde la URL para no sobrecargar la API con más peticiones
          final String url = pokemonItem['url'];
          final id = url.split('/')[url.split('/').length - 2];

          // URL directa de la imagen oficial en alta calidad
          final String imageUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            elevation: 2,
            child: ListTile(
              leading: Image.network(
                imageUrl,
                width: 55,
                height: 55,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.catching_pokemon, size: 40, color: Colors.grey),
              ),
              title: Text(
                name.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text('Número: #$id'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                // 3. CONEXIÓN: Al pulsar, vamos a la pantalla de tu compañero
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetallesPokemon(pokemonName: name),
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