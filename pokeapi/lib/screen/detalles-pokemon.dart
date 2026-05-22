import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

class DetallesPokemon extends StatefulWidget {
  final String pokemonName;

  const DetallesPokemon({super.key, required this.pokemonName});

  @override
  State<DetallesPokemon> createState() => _DetallesPokemonState();
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
    try {
      final resultado = await service.fetchPokemon(widget.pokemonName);

      setState(() {
        pokemon = resultado;
        cargando = false;
      });
    } catch (e) {
      setState(() {
        error = 'No se pudo cargar el Pokémon';
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text(error!)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon!.name.toUpperCase()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '#${pokemon!.id}',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Image.network(
              pokemon!.imageUrl,
              height: 230,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image_not_supported, size: 120);
              },
            ),

            const SizedBox(height: 20),

            Text(
              pokemon!.name.toUpperCase(),
              style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: _InfoCard(
                    titulo: 'Altura',
                    valor: '${pokemon!.height}',
                    icono: Icons.height,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoCard(
                    titulo: 'Peso',
                    valor: '${pokemon!.weight}',
                    icono: Icons.monitor_weight,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;

  const _InfoCard({
    required this.titulo,
    required this.valor,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Icon(icono, size: 34),
            const SizedBox(height: 8),
            Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(valor, style: const TextStyle(fontSize: 22)),
          ],
        ),
      ),
    );
  }
}
