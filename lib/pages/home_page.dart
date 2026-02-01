import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:minimal_music_player/components/my_drawer.dart';
import 'package:minimal_music_player/models/playlist_provider.dart';
import 'package:minimal_music_player/pages/song_page.dart';
import 'package:provider/provider.dart';

import '../models/song.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //get the playlist provider
  late final dynamic playlistProvider;

  @override
  void initState(){
    super.initState();

    //get playlist provider
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  // go to a song
  void goToSong(int songIndex){
    //update current song index
    // IMPORTANT: select song WITHOUT playing
    playlistProvider.selectSong(songIndex);

    //navigate to song page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SongPage(),),
    );
  }

  //show add song dialog
  Future<void> showAddSongDialog() async {
    final Song? resultSong = await showDialog<Song?>(
      context: context,
      builder: (context) {
        // create controllers INSIDE the dialog so they are not disposed too early
        final nameController = TextEditingController();
        final artistController = TextEditingController();

        String? pickedAudioPath;
        String? pickedImagePath;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Add Song"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: "Song name"),
                    ),
                    TextField(
                      controller: artistController,
                      decoration: const InputDecoration(labelText: "Artist name"),
                    ),
                    const SizedBox(height: 12),

                    ElevatedButton(
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['mp3', 'wav', 'm4a', 'aac', 'ogg'],
                        );
                        if (result != null && result.files.single.path != null) {
                          pickedAudioPath = result.files.single.path!;
                          setDialogState(() {});
                        }
                      },
                      child: const Text("Pick audio file"),
                    ),

                    if (pickedAudioPath != null)
                      const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Text("Audio picked", style: TextStyle(fontSize: 12)),
                      ),

                    const SizedBox(height: 8),

                    ElevatedButton(
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles(
                          type: FileType.image,
                        );
                        if (result != null && result.files.single.path != null) {
                          pickedImagePath = result.files.single.path!;
                          setDialogState(() {});
                        }
                      },
                      child: const Text("Pick album image (optional)"),
                    ),

                    if (pickedImagePath != null)
                      const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Text("Image picked", style: TextStyle(fontSize: 12)),
                      ),

                    const SizedBox(height: 8),
                    const Text(
                      "Tip: Audio is required. Image is optional.",
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    final songName = nameController.text.trim();
                    final artistName = artistController.text.trim();

                    if (pickedAudioPath == null || songName.isEmpty || artistName.isEmpty) {
                      // simple guard: don't close if missing required fields
                      return;
                    }

                    // if user doesn't pick an image, keep it as null (default to nothing)
                    final song = Song(
                      songName: songName,
                      artistName: artistName,
                      albumArtImagePath: pickedImagePath, // can be null
                      audioPath: pickedAudioPath!,
                      isAssetImage: false,
                      isAssetAudio: false,
                    );

                    Navigator.pop(context, song);
                  },
                  child: const Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );

    // dispose controllers AFTER dialog is gone

    // if user added a song, add it now
    if (resultSong != null) {
      playlistProvider.addSong(resultSong);
    }
  }

  //show update details dialog
  Future<void> showUpdateSongDialog({
    required int index,
    required Song song,
  }) async {
    final nameController = TextEditingController(text: song.songName);
    final artistController = TextEditingController(text: song.artistName);

    String? pickedImagePath = song.albumArtImagePath;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Update details"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Song name"),
                  ),
                  TextField(
                    controller: artistController,
                    decoration: const InputDecoration(labelText: "Artist name"),
                  ),
                  const SizedBox(height: 12),

                  ElevatedButton(
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles(type: FileType.image);
                      if (result != null && result.files.single.path != null) {
                        pickedImagePath = result.files.single.path!;
                        setDialogState(() {});
                      }
                    },
                    child: const Text("Change album image (optional)"),
                  ),

                  if (pickedImagePath == null || pickedImagePath!.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text("No image selected", style: TextStyle(fontSize: 12)),
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text("Image selected", style: TextStyle(fontSize: 12)),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == true) {
      final newName = nameController.text.trim();
      final newArtist = artistController.text.trim();

      if (newName.isEmpty || newArtist.isEmpty) return;

      playlistProvider.updateSongDetails(
        index: index,
        songName: newName,
        artistName: newArtist,
        albumArtImagePath: pickedImagePath, // can be null
        isAssetImage: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title: const Text("P L A Y L I S T")),
      drawer: const MyDrawer(),
      body: Consumer<PlaylistProvider>(
          builder: (context,value,child) {

            //get the playlist
            final List<Song> playlist = value.playlist;

            //return list view UI
            return ReorderableListView.builder(
              buildDefaultDragHandles: false,
              itemCount: playlist.length,
              onReorder: (oldIndex, newIndex) {
                // ReorderableListView gives "newIndex" with a small adjustment
                if (newIndex > oldIndex) newIndex -= 1;
                playlistProvider.moveSong(oldIndex, newIndex);
              },
              itemBuilder: (context, index) {
                //get individual song
                final Song song = playlist[index];

                // if user has no album image, show nothing
                Widget leadingWidget;
                final path = song.albumArtImagePath;

                if (path == null || path.isEmpty) {
                  leadingWidget = const SizedBox(width: 56, height: 56);
                } else if (song.isAssetImage) {
                  leadingWidget = Image.asset(path);
                } else {
                  leadingWidget = Image.file(File(path));
                }

                //return list tile UI
                return ListTile(
                  key: ValueKey("${song.songName}-$index"),
                  title: Text(song.songName),
                  subtitle: Text(song.artistName),
                  leading: leadingWidget,

                  // play button + 3 dots menu
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // play / pause button
                      IconButton(
                        icon: Icon(
                          (playlistProvider.currentSongIndex == index && playlistProvider.isPlaying)
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                        onPressed: () {
                          final isThisSongSelected =
                          (playlistProvider.currentSongIndex == index);

                          if (isThisSongSelected) {
                            playlistProvider.pauseOrResume();
                          } else {
                            playlistProvider.playSongAtIndex(index);
                          }
                        },
                      ),

                      // 3 dots menu
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (choice) async {
                          if (choice == 'update') {
                            await showUpdateSongDialog(index: index, song: song);
                          } else if (choice == 'delete') {
                            playlistProvider.removeSong(index);
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: 'update',
                            child: Text('Update details'),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete song'),
                          ),
                        ],
                      ),

                      // drag handle
                      ReorderableDragStartListener(
                        index: index,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Icon(Icons.drag_handle),
                        ),
                      ),
                    ],
                  ),


                  //tapping the row goes to song page WITHOUT playing
                  onTap: () => goToSong(index),
                );
              },
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        onPressed: showAddSongDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
