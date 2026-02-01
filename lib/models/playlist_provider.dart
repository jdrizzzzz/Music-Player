import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:minimal_music_player/models/song.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//repeat mode
enum RepeatMode { off, one, all }

class PlaylistProvider extends ChangeNotifier{
  //playlist of songs
  final List<Song> _playlist = [

  ];

  //current song playing index
  int? _currentSongIndex;


  /*A U D I O    P L A Y E R*/

  //audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  //durations
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  //constructor
  PlaylistProvider() {
    listenToDuration();
    _loadPlaylist(); // load saved playlist on startup
  }

  //initially not playing
  bool _isPlaying = false;

  //shuffle + repeat
  bool _isShuffleOn = false;
  RepeatMode _repeatMode = RepeatMode.off;

  //random for shuffle
  final Random _random = Random();

  //persistence key
  static const String _playlistKey = 'saved_playlist_v1';

  // load playlist from SharedPreferences
  Future<void> _loadPlaylist() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_playlistKey);

    if (jsonString == null || jsonString.isEmpty) {
      // first run: keep default asset songs, but save them once
      await _savePlaylist();
      return;
    }

    try {
      final List decoded = jsonDecode(jsonString) as List;
      final loaded = decoded
          .map((e) => Song.fromMap(Map<String, dynamic>.from(e)))
          .toList();

      _playlist
        ..clear()
        ..addAll(loaded);

      // keep index safe
      if (_playlist.isEmpty) {
        _currentSongIndex = null;
      } else if (_currentSongIndex == null || _currentSongIndex! >= _playlist.length) {
        _currentSongIndex = 0;
      }

      notifyListeners();
    } catch (_) {
      // if parsing fails, keep defaults
    }
  }

  // save playlist to SharedPreferences
  Future<void> _savePlaylist() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_playlist.map((s) => s.toMap()).toList());
    await prefs.setString(_playlistKey, jsonString);
  }

  //play the song
  void play() async {
    if (_currentSongIndex == null) return;

    final Song song = _playlist[_currentSongIndex!];
    final String path = song.audioPath;

    await _audioPlayer.stop(); // stop current song

    if (song.isAssetAudio) {
      final fixedPath = path.replaceFirst('assets/', '');
      await _audioPlayer.play(AssetSource(fixedPath)); // play new song
    } else {
      // if file is missing, don't crash
      if (!File(path).existsSync()) {
        _isPlaying = false;
        notifyListeners();
        return;
      }
      await _audioPlayer.play(DeviceFileSource(path)); // play device song
    }

    _isPlaying = true;
    notifyListeners();
  }

  //pause the song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  //resume playing
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  //pause or resume
  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
  }

  //seek to a specific position in the current song
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  //toggle shuffle
  void toggleShuffle() {
    _isShuffleOn = !_isShuffleOn;
    notifyListeners();
  }

  //cycle repeat mode: off -> all -> one -> off
  void cycleRepeatMode() {
    if (_repeatMode == RepeatMode.off) {
      _repeatMode = RepeatMode.all;
    } else if (_repeatMode == RepeatMode.all) {
      _repeatMode = RepeatMode.one;
    } else {
      _repeatMode = RepeatMode.off;
    }
    notifyListeners();
  }

  // select song WITHOUT playing (for tapping the card)
  void selectSong(int index) {
    if (index < 0 || index >= _playlist.length) return;
    _currentSongIndex = index;
    notifyListeners();
  }

  // play a specific song index (for play button)
  void playSongAtIndex(int index) {
    if (index < 0 || index >= _playlist.length) return;
    _currentSongIndex = index;
    play();
    notifyListeners();
  }

  //play next song
  void playNextSong() {
    if (_currentSongIndex == null) return;

    //shuffle mode
    if (_isShuffleOn) {
      if (_playlist.length <= 1) return;

      int newIndex = _currentSongIndex!;
      while (newIndex == _currentSongIndex) {
        newIndex = _random.nextInt(_playlist.length);
      }

      _currentSongIndex = newIndex;
      play();
      notifyListeners();
      return;
    }

    //normal next
    if (_currentSongIndex! < _playlist.length - 1) {
      //go to the next song if its not the last song
      _currentSongIndex = _currentSongIndex! + 1;
      play();
    } else {
      //if its the last song
      if (_repeatMode == RepeatMode.all) {
        //loop back to the top
        _currentSongIndex = 0;
        play();
      } else {
        //repeat is off: stop playing
        _isPlaying = false;
      }
    }

    notifyListeners();
  }

  //play previous song
  void playPreviousSong() async {
    // if more than 2 seconds have passed, restart the current song
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    }
    //if its within the first 2 seconds of the song, go to the previous song
    else {
      if (_currentSongIndex! > 0) {
        _currentSongIndex = _currentSongIndex! -1;
        play();
      } else {
        // if its the first song, loop back tot he last song
        _currentSongIndex = _playlist.length - 1 ;
        play();
      }
    }

    notifyListeners();
  }

  //listen to duration
  void listenToDuration() {
    //listen for the total duration
    _audioPlayer.onDurationChanged.listen((newDuration){
      _totalDuration = newDuration;
      notifyListeners();
    });

    //listen for current duration
    _audioPlayer.onPositionChanged.listen((newPosition){
      _currentDuration = newPosition;
      notifyListeners();
    });

    //listen for song completion
    _audioPlayer.onPlayerComplete.listen((event){
      //repeat one: restart same song
      if (_repeatMode == RepeatMode.one) {
        seek(Duration.zero);
        play();
      } else {
        playNextSong();
      }
    });

  }

  //dispose audio player
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // add a song
  void addSong(Song song) {
    _playlist.add(song);
    _savePlaylist();
    notifyListeners();
  }

  // remove a song
  void removeSong(int index) {
    if (index < 0 || index >= _playlist.length) return;

    // if you remove the currently playing song, stop playback
    if (_currentSongIndex == index) {
      _audioPlayer.stop();
      _isPlaying = false;
      _currentSongIndex = null;
    }

    // if you remove something before the current index, shift index left
    if (_currentSongIndex != null && index < _currentSongIndex!) {
      _currentSongIndex = _currentSongIndex! - 1;
    }

    _playlist.removeAt(index);
    _savePlaylist();
    notifyListeners();
  }

  //update song details (name/artist/image)
  void updateSongDetails({
    required int index,
    required String songName,
    required String artistName,
    String? albumArtImagePath,
    bool? isAssetImage,
  }) {
    if (index < 0 || index >= _playlist.length) return;

    _playlist[index] = _playlist[index].copyWith(
      songName: songName,
      artistName: artistName,
      albumArtImagePath: albumArtImagePath,
      isAssetImage: isAssetImage ?? _playlist[index].isAssetImage,
    );

    _savePlaylist();
    notifyListeners();
  }

  // move songs (reorder)
  void moveSong(int oldIndex, int newIndex) {
    if (oldIndex < 0 || oldIndex >= _playlist.length) return;
    if (newIndex < 0 || newIndex >= _playlist.length) return;

    final song = _playlist.removeAt(oldIndex);
    _playlist.insert(newIndex, song);

    // keep current index correct after reorder
    if (_currentSongIndex != null) {
      if (_currentSongIndex == oldIndex) {
        _currentSongIndex = newIndex;
      } else if (oldIndex < _currentSongIndex! && newIndex >= _currentSongIndex!) {
        _currentSongIndex = _currentSongIndex! - 1;
      } else if (oldIndex > _currentSongIndex! && newIndex <= _currentSongIndex!) {
        _currentSongIndex = _currentSongIndex! + 1;
      }
    }

    _savePlaylist();
    notifyListeners();
  }

  // create a safe filename
  String _safeName(String input) {
    final cleaned = input.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_').trim();
    return cleaned.isEmpty ? 'untitled' : cleaned;
  }

  // Save copy of playlist to app folder (recommended) or external app folder on Android
  //
  // IMPORTANT:
  // - You cannot write to assets/ at runtime.
  // - This copies ONLY device-picked files (not your bundled asset songs).
  //
  // Returns the folder path where it saved everything.
  Future<String> saveCopyOfPlaylist({required bool saveToExternalFolder}) async {
    Directory baseDir;

    if (saveToExternalFolder) {
      final ext = await getExternalStorageDirectory();
      baseDir = ext ?? await getApplicationDocumentsDirectory();
    } else {
      baseDir = await getApplicationDocumentsDirectory();
    }

    final libraryDir = Directory(p.join(baseDir.path, 'MinimalMusicPlayer', 'Library'));
    final audioDir = Directory(p.join(libraryDir.path, 'audio'));
    final imagesDir = Directory(p.join(libraryDir.path, 'images'));

    if (!libraryDir.existsSync()) libraryDir.createSync(recursive: true);
    if (!audioDir.existsSync()) audioDir.createSync(recursive: true);
    if (!imagesDir.existsSync()) imagesDir.createSync(recursive: true);

    for (int i = 0; i < _playlist.length; i++) {
      final song = _playlist[i];

      if (song.isAssetAudio) continue;

      final srcAudio = File(song.audioPath);
      if (srcAudio.existsSync()) {
        final audioExt = p.extension(srcAudio.path).isNotEmpty ? p.extension(srcAudio.path) : '.mp3';
        final audioFileName = "${_safeName(song.artistName)} - ${_safeName(song.songName)}$audioExt";
        final destAudioPath = p.join(audioDir.path, audioFileName);

        if (!File(destAudioPath).existsSync()) {
          await srcAudio.copy(destAudioPath);
        }

        String? destImagePath;

        if (song.albumArtImagePath != null && song.albumArtImagePath!.isNotEmpty && !song.isAssetImage) {
          final srcImg = File(song.albumArtImagePath!);
          if (srcImg.existsSync()) {
            final imgExt = p.extension(srcImg.path).isNotEmpty ? p.extension(srcImg.path) : '.jpg';
            final imgFileName = "${_safeName(song.artistName)} - ${_safeName(song.songName)}$imgExt";
            destImagePath = p.join(imagesDir.path, imgFileName);

            if (!File(destImagePath).existsSync()) {
              await srcImg.copy(destImagePath);
            }
          }
        }

        _playlist[i] = song.copyWith(
          audioPath: destAudioPath,
          isAssetAudio: false,
          albumArtImagePath: destImagePath ?? song.albumArtImagePath,
          isAssetImage: false,
        );
      }
    }

    await _savePlaylist();
    notifyListeners();

    return libraryDir.path;
  }

  /*GETTERS*/

  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  bool get isShuffleOn => _isShuffleOn;
  RepeatMode get repeatMode => _repeatMode;

  /*SETTERS*/

  set currentSongIndex(int? newIndex){
    //update current song index
    _currentSongIndex = newIndex;

    if (newIndex != null) {
      play(); // play the song at the new index
    }

    //update UI
    notifyListeners();
  }
}
