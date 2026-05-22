import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pokemon.dart';

class PokemonService {

  final String baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  Future<Pokemon?> fetchPokemon(String pokemonName) async {

    final url = Uri.parse(
      '$baseUrl/${pokemonName.toLowerCase()}',
    );

    try {

      final response = await http.get(url);

      if (response.statusCode == 200) {

        final Map<String, dynamic> data =
            jsonDecode(response.body);

        return Pokemon.fromJson(data);

      } else {

        return null;

      }

    } catch (e) {

      print('Error al obtener Pokémon: $e');

      return null;
    }
  }
}