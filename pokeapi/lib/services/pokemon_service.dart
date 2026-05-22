import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/pokemon.dart';

class PokemonService {

  final String baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  Future<Pokemon?> fetchPokemon(String name) async {

    final url = Uri.parse('$baseUrl/${name.toLowerCase()}');

    try {

      final response = await http.get(url);

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        return Pokemon.fromJson(data);

      } else {
        return null;
      }

    } catch (e) {
      print("Error API: $e");
      return null;
    }
  }
}