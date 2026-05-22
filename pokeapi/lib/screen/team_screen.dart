import 'package:flutter/material.dart';

import '../services/team_service.dart';

class TeamScreen extends StatefulWidget {

  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {

  final teamService = TeamService();

  @override
  Widget build(BuildContext context) {

    final team = teamService.team;

    return Scaffold(

      appBar: AppBar(
        title: const Text("Tu equipo"),
      ),

      body: team.isEmpty

          ? const Center(
              child: Text("No hay Pokémon"),
            )

          : Column(

              children: [

                Expanded(

                  child: ListView.builder(

                    itemCount: team.length,

                    itemBuilder: (context, index) {

                      final p = team[index];

                      return ListTile(

                        leading: Image.network(p.imageUrl),

                        title: Text(p.name.toUpperCase()),

                        subtitle: Text(p.types.join(", ")),

                        trailing: IconButton(

                          icon: const Icon(Icons.delete),

                          onPressed: () {
                            setState(() {
                              teamService.removePokemon(p.id);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),

                Container(

                  padding: const EdgeInsets.all(12),

                  child: Text(
                    "Tipos en equipo: ${team.expand((p) => p.types).toSet().join(", ")}",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
    );
  }
}