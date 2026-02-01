import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minimal_music_player/models/playlist_provider.dart';
import 'package:minimal_music_player/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  bool isEnabled = false;

  SettingsPage({super.key});

  Future<void> _saveCopy(BuildContext context) async {
    final provider = Provider.of<PlaylistProvider>(context, listen: false);

    final choice = await showDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Save copy of all added songs"),
          content: const Text(
            "This will copy your added songs into a folder created by the app.\n\n"
                "Choose where to save:",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("App storage"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("External folder"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );

    if (choice == null) return;

    final folderPath = await provider.saveCopyOfPlaylist(
      saveToExternalFolder: choice,
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Saved playlist copy to:\n$folderPath"),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("S E T T I N G S"),
      ),
      body: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //dark mode
                  const Text("Dark Mode", style: TextStyle(fontWeight: FontWeight.bold)),

                  //switch
                  Switch.adaptive(
                    value:
                    Provider.of<ThemeProvider>(context,listen: false).isDarkMode,
                    onChanged:
                        (value) => Provider.of<ThemeProvider>(context,listen: false).toggleTheme(),
                  ),
                ],
              )
          ),

          // Save copy of playlist
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Save copy of playlist", style: TextStyle(fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: () => _saveCopy(context),
                  child: const Text("Save"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
