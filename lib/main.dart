import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Temos que Pegar',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const PokemonPage(),
    );
  }
}

class PokemonPage extends StatefulWidget {
  const PokemonPage({super.key});

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  String pokemonName = "";
  String pokemonImage = "";
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchRandomPokemon();
  }

  Future<void> fetchRandomPokemon() async {
    setState(() {
      loading = true;
    });

    int id = Random().nextInt(151) + 1; // entre 1 e 151
    String url = "https://pokeapi.co/api/v2/pokemon/$id";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          pokemonName = data["name"];
          pokemonImage = data["sprites"]["other"]["official-artwork"]["front_default"];
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
        throw Exception("Erro ao carregar Pokémon");
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      debugPrint("Erro: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: loading
            ? const CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFF4A148C),
                  width: 3,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Pokémon Aleatório',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: Color(0xFF4A148C)
                ),
              ),
            ),

            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(
                  color: Color(0xFF4A148C),
                  width: 3,
                ),
              ),
              margin:const EdgeInsets.all(45),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    if (pokemonImage.isNotEmpty)
                      Image.network(
                        pokemonImage,
                        height: 160,
                        width: 160,
                      ),

                    const SizedBox(height: 12),

                    Text(
                      pokemonName.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A148C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: fetchRandomPokemon,
              child: const Text(
                "Buscar Pokémon",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
