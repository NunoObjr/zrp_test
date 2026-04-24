import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final textController = TextEditingController();
  late final HomeController homeController;
  String episodeNumber = '';

  @override
  void initState() {
    super.initState();
    homeController = getIt<HomeController>();
    textController.addListener(() {
      setState(() {
        episodeNumber = textController.text;
      });
    });
  }

  void _showSnackbarError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
        backgroundColor: Colors.red,
        content: Text(message),
      ),
    );
  }

  Future<void> loadEpisodes() async {
    await homeController.searchEpisode(textController.text);
    if (mounted && homeController.episode != null) {
      textController.clear();
      if (homeController.characters.isEmpty) {
        _showSnackbarError('Nenhum personagem encontrado para este episódio.');
        return;
      }
      context.push('/episode-detail', extra: homeController.characters);
    } else {
      _showSnackbarError(
          'Episódio não encontrado. Verifique o número e tente novamente.');
    }
  }

  @override
  void dispose() {
    textController.dispose();
    homeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personagens de Rick and Morty'),
      ),
      body: ListenableBuilder(
        listenable: homeController,
        builder: (context, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: textController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Insira o número do episódio',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                ),
                const SizedBox(height: 20),
                if (homeController.isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed:
                        episodeNumber.isEmpty ? null : () => loadEpisodes(),
                    child: const Text('Buscar episódio'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
