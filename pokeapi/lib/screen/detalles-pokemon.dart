import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PokemonDetailScreen extends StatefulWidget {
  final String pokemonName;

  const PokemonDetailScreen({super.key, required this.pokemonName});

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  Map<String, dynamic>? pokemon;
  bool cargando = true;
  String? error;

  @override
  void initState() {
    super.initState();
    cargarPokemon();
  }

  Future<void> cargarPokemon() async {
    try {
      final url = Uri.parse(
        'https://pokeapi.co/api/v2/pokemon/${widget.pokemonName.toLowerCase()}',
      );

      final respuesta = await http.get(url);

      if (respuesta.statusCode == 200) {
        setState(() {
          pokemon = jsonDecode(respuesta.body);
          cargando = false;
        });
      } else {
        setState(() {
          error = 'No se pudo cargar el Pokémon';
          cargando = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error de conexión';
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

    final nombre = pokemon!['name'];
    final id = pokemon!['id'];
    final altura = pokemon!['height'];
    final peso = pokemon!['weight'];
    final imagen =
        pokemon!['sprites']['other']['official-artwork']['front_default'];
    final tipos = pokemon!['types'] as List;
    final habilidades = pokemon!['abilities'] as List;
    final stats = pokemon!['stats'] as List;

    return Scaffold(
      appBar: AppBar(
        title: Text(nombre.toString().toUpperCase()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '#$id',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Image.network(imagen, height: 220),

            const SizedBox(height: 10),

            Text(
              nombre.toString().toUpperCase(),
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Wrap(
              spacing: 8,
              children: tipos.map((tipo) {
                final nombreTipo = tipo['type']['name'];

                return Chip(
                  label: Text(nombreTipo.toString().toUpperCase()),
                  backgroundColor: Colors.red.shade100,
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: InfoCard(
                    titulo: 'Altura',
                    valor: '$altura',
                    icono: Icons.height,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InfoCard(
                    titulo: 'Peso',
                    valor: '$peso',
                    icono: Icons.monitor_weight,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const SectionTitle(titulo: 'Habilidades'),

            Column(
              children: habilidades.map((habilidad) {
                final nombreHabilidad = habilidad['ability']['name'];

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.flash_on),
                    title: Text(nombreHabilidad.toString().toUpperCase()),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            const SectionTitle(titulo: 'Estadísticas'),

            Column(
              children: stats.map((stat) {
                final nombreStat = stat['stat']['name'];
                final valorStat = stat['base_stat'];

                return StatBar(nombre: nombreStat, valor: valorStat);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;

  const InfoCard({
    super.key,
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
            Icon(icono, size: 32),
            const SizedBox(height: 8),
            Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(valor, style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String titulo;

  const SectionTitle({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        titulo,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class StatBar extends StatelessWidget {
  final String nombre;
  final int valor;

  const StatBar({super.key, required this.nombre, required this.valor});

  @override
  Widget build(BuildContext context) {
    final porcentaje = valor / 150;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${nombre.toUpperCase()} - $valor',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: porcentaje > 1 ? 1 : porcentaje,
              minHeight: 10,
            ),
          ],
        ),
      ),
    );
  }
}
