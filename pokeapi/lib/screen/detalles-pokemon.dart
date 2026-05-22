import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import '../services/pokemon_service.dart';
import '../services/team_service.dart';

class DetallesPokemon extends StatefulWidget {

  final String pokemonName;

  const DetallesPokemon({
    super.key,
    required this.pokemonName,
  });

  @override
  State<DetallesPokemon> createState() =>
      _DetallesPokemonState();
}

class _DetallesPokemonState extends State<DetallesPokemon> {

  final PokemonService service = PokemonService();

  Pokemon? pokemon;

  bool cargando = true;
  String? error;

  @override
  void initState() {
    super.initState();
    cargarPokemon();
  }

  Future<void> cargarPokemon() async {

    final resultado =
        await service.fetchPokemon(widget.pokemonName);

    setState(() {
      pokemon = resultado;
      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (cargando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (pokemon == null) {
      return const Scaffold(
        body: Center(child: Text("Error Pokémon")),
      );
    }

    return Scaffold(

      appBar: AppBar(
        title: Text(pokemon!.name.toUpperCase()),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            Text(
              "#${pokemon!.id}",
              style: const TextStyle(fontSize: 26),
            ),

            Image.network(pokemon!.imageUrl, height: 200),

            const SizedBox(height: 10),

            Wrap(
              spacing: 8,

              children: pokemon!.types.map((t) {
                return Chip(label: Text(t.toUpperCase()));
              }).toList(),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(

              icon: const Icon(Icons.add),

              label: const Text("Añadir al equipo"),

              onPressed: () {

                final team = TeamService();

                final ok = team.addPokemon(pokemon!);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      ok
                          ? "Añadido al equipo"
                          : "Equipo lleno o duplicado",
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            Text("Altura: ${pokemon!.height}"),
            Text("Peso: ${pokemon!.weight}"),
          ],
        ),
      ),
    );
  }
}