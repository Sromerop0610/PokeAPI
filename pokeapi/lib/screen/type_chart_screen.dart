import 'package:flutter/material.dart';

class TypeChartScreen extends StatelessWidget {
  const TypeChartScreen({super.key});

  final List<Map<String, dynamic>> types = const [

    {
      "name": "Fuego",
      "color": Colors.red,
      "strong": ["Planta", "Hielo", "Bicho", "Acero"],
      "weak": ["Agua", "Tierra", "Roca"],
    },

    {
      "name": "Agua",
      "color": Colors.blue,
      "strong": ["Fuego", "Roca", "Tierra"],
      "weak": ["Planta", "Eléctrico"],
    },

    {
      "name": "Planta",
      "color": Colors.green,
      "strong": ["Agua", "Tierra", "Roca"],
      "weak": ["Fuego", "Hielo", "Veneno", "Volador", "Bicho"],
    },

    {
      "name": "Eléctrico",
      "color": Colors.yellow,
      "strong": ["Agua", "Volador"],
      "weak": ["Tierra"],
    },

    {
      "name": "Hielo",
      "color": Colors.cyan,
      "strong": ["Planta", "Tierra", "Volador", "Dragón"],
      "weak": ["Fuego", "Lucha", "Roca", "Acero"],
    },
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Tabla de tipos"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      body: ListView.builder(

        itemCount: types.length,

        itemBuilder: (context, index) {

          final type = types[index];

          return Card(

            margin: const EdgeInsets.all(10),

            child: Padding(

              padding: const EdgeInsets.all(16),

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Row(

                    children: [

                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: type["color"],
                          shape: BoxShape.circle,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        type["name"],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Fuerte contra:",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  Text(type["strong"].join(", ")),

                  const SizedBox(height: 10),

                  Text(
                    "Débil contra:",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  Text(type["weak"].join(", ")),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}