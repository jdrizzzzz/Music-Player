import 'dart:io';
import 'package:flutter/material.dart';
import 'package:minimal_music_player/components/neu_box.dart';
import 'package:minimal_music_player/models/playlist_provider.dart';
import 'package:provider/provider.dart';

class SongPage extends StatelessWidget {
  const SongPage({super.key});

  // convert duration into min:sec
  String formatTime(Duration duration) {
    String twoDigitSeconds = duration.inSeconds.remainder(60).toString().padLeft(2,'0');
    String formattedTime = "${duration.inMinutes}:$twoDigitSeconds";

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
        builder: (context,value,child) {
          //get playlist
          final playlist = value.playlist;

          //get current song index
          final currentSong = playlist[value.currentSongIndex ?? 0];

          //return scaffold UI
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //app bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //back button
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                        ),

                        //title
                        const Text(" P L A Y L I S T"),

                        //menu button
                        IconButton(
                          onPressed: (){},
                          icon: const Icon(Icons.menu),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    //album artwork
                    NeuBox(
                      child: Column(
                        children: [
                          // image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Builder(
                              builder: (context) {
                                final path = currentSong.albumArtImagePath;

                                // if user has no album image, show nothing
                                if (path == null || path.isEmpty) {
                                  return const SizedBox(height: 220);
                                }

                                if (currentSong.isAssetImage) {
                                  return Image.asset(path);
                                } else {
                                  return Image.file(File(path));
                                }
                              },
                            ),
                          ),

                          //Song and artist name and icon
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //song and artist name
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentSong.songName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(currentSong.artistName),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),


                    //song duration progress
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //start
                              Text(formatTime(value.currentDuration)),

                              //shuffle icon
                              GestureDetector(
                                onTap: value.toggleShuffle,
                                child: Icon(
                                  Icons.shuffle,
                                  color: value.isShuffleOn ? Colors.indigo : Colors.grey,
                                ),
                              ),

                              // repeat icon
                              GestureDetector(
                                onTap: value.cycleRepeatMode,
                                child: Icon(
                                  value.repeatMode == RepeatMode.one
                                      ? Icons.repeat_one
                                      : Icons.repeat,
                                  color: value.repeatMode == RepeatMode.off ? Colors.grey : Colors.indigo,
                                ),
                              ),

                              //end time
                              Text(formatTime(value.totalDuration)),
                            ],
                          ),
                        ),

                        //song duration slider
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                              thumbShape:
                              const RoundSliderThumbShape(enabledThumbRadius: 0)
                          ),
                          child: Slider(
                            min: 0,
                            max: value.totalDuration.inSeconds.toDouble(),
                            value: value.currentDuration.inSeconds
                                .toDouble()
                                .clamp(0, value.totalDuration.inSeconds.toDouble()),
                            activeColor: Colors.indigo,
                            onChanged: (double) {
                              //when the user is sliding around
                            },
                            onChangeEnd: (double) {
                              //sliding has finished, go to that position in song duration
                              value.seek(Duration(seconds: double.toInt()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    //playback controls
                    Row(
                      children: [
                        //skip previous
                        Expanded(
                          child: GestureDetector(
                            onTap: value.playPreviousSong,
                            child: const NeuBox(
                              child: Icon(Icons.skip_previous),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),

                        //play or pause
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: value.pauseOrResume,
                            child: NeuBox(
                              child: Icon(value.isPlaying ? Icons.pause: Icons.play_arrow),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),

                        //skip foward
                        Expanded(
                          child: GestureDetector(
                            onTap: value.playNextSong,
                            child: const NeuBox(
                              child: Icon(Icons.skip_next),
                            ),
                          ),
                        ),


                      ],
                    )

                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}
