class Song {
  final String songName;
  final String artistName;

  // albumArtImagePath can be null (no image)
  final String? albumArtImagePath;

  final String audioPath;

  // tell Flutter whether these paths are assets or device files
  final bool isAssetImage;
  final bool isAssetAudio;

  Song({
    required this.songName,
    required this.artistName,
    required this.audioPath,
    this.albumArtImagePath,
    this.isAssetImage = true,
    this.isAssetAudio = true,
  });

  // convert song to map for saving
  Map<String, dynamic> toMap() {
    return {
      'songName': songName,
      'artistName': artistName,
      'albumArtImagePath': albumArtImagePath,
      'audioPath': audioPath,
      'isAssetImage': isAssetImage,
      'isAssetAudio': isAssetAudio,
    };
  }

  // create song from saved map
  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      songName: (map['songName'] ?? '') as String,
      artistName: (map['artistName'] ?? '') as String,
      albumArtImagePath: map['albumArtImagePath'] as String?,
      audioPath: (map['audioPath'] ?? '') as String,
      isAssetImage: (map['isAssetImage'] ?? true) as bool,
      isAssetAudio: (map['isAssetAudio'] ?? true) as bool,
    );
  }

  // copy helper so we can update paths after copying
  Song copyWith({
    String? songName,
    String? artistName,
    String? albumArtImagePath,
    String? audioPath,
    bool? isAssetImage,
    bool? isAssetAudio,
  }) {
    return Song(
      songName: songName ?? this.songName,
      artistName: artistName ?? this.artistName,
      albumArtImagePath: albumArtImagePath ?? this.albumArtImagePath,
      audioPath: audioPath ?? this.audioPath,
      isAssetImage: isAssetImage ?? this.isAssetImage,
      isAssetAudio: isAssetAudio ?? this.isAssetAudio,
    );
  }
}
