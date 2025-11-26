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
      title: 'Pokémon Random App',
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
          pokemonImage = data["sprites"]["front_default"];
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
      appBar: AppBar(
        title: const Text("Pokémon Aleatório"),
        centerTitle: true,
      ),
      body: Center(
        child: loading
            ? const CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (pokemonImage.isNotEmpty)
              Image.network(
                pokemonImage,
                height: 800,
                width: 800,
              ),
            const SizedBox(height: 20),
            Text(
              pokemonName.toUpperCase(),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: fetchRandomPokemon,
              child: const Text("Buscar Pokémon"),
            ),
          ],
        ),
      ),
    );
  }
}
