import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import '../services/pokemon_service.dart';
import '../utils/pokemon_type_colors.dart';

class DetallesPokemon extends StatefulWidget {
  final String pokemonName;

  const DetallesPokemon({
    super.key,
    required this.pokemonName,
  });

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
      final resultado =
          await service.fetchPokemon(widget.pokemonName);

      if (resultado == null) {
        setState(() {
          error = "Pokémon no encontrado";
          cargando = false;
        });
        return;
      }

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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null || pokemon == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Text(error ?? 'Error desconocido'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon!.name.toUpperCase()),
        centerTitle: true,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            // 📌 ID
            Text(
              '#${pokemon!.id}',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // 🖼 IMAGEN
            Image.network(
              pokemon!.imageUrl,
              height: 230,
              errorBuilder: (_, __, ___) {
                return const Icon(
                  Icons.image_not_supported,
                  size: 120,
                );
              },
            ),

            const SizedBox(height: 20),

            // 🧾 NOMBRE
            Text(
              pokemon!.name.toUpperCase(),
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // 🏷 TIPOS CON COLORES
            Wrap(
              spacing: 8,
              children: pokemon!.types.map((type) {
                final color =
                    PokemonTypeColors.getColor(type);

                return Chip(
                  backgroundColor: color.withOpacity(0.15),
                  side: BorderSide(color: color),
                  label: Text(
                    type.toUpperCase(),
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            // 📊 ESTADÍSTICAS
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
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Icon(icono, size: 34),
            const SizedBox(height: 8),
            Text(
              titulo,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              valor,
              style: const TextStyle(fontSize: 22),
            ),
          ],
        ),
      ),
    );
  }
}