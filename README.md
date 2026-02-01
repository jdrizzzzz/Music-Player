# Music Player

A beautiful and minimalist music player application built with Flutter, featuring a clean and modern user interface designed for seamless music playback experience across multiple platforms.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Screenshots](#-screenshots)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
- [Platform Support](#-platform-support)
- [Usage](#-usage)
- [Configuration](#-configuration)
- [Contributing](#-contributing)
- [License](#-license)

---

## Overview

**Music Player** is a cross-platform music player application developed using Flutter and Dart. This project demonstrates modern Flutter development practices and provides a clean, intuitive interface for managing and playing your music collection. Whether you're on Android, iOS, Web, Windows, macOS, or Linux, this app delivers a consistent and delightful user experience.

The application follows Material Design principles and showcases Flutter's capability to create beautiful, performant applications that work seamlessly across all major platforms.

---

## Features

### Core Features
- **Audio Playback**: Smooth and efficient music playback engine
- **Cross-Platform**: Works on Android, iOS, Web, Windows, macOS, and Linux
- **Modern UI**: Clean and minimal design with Material Design components
- **Music Library**: Browse and organize your music collection
- **Playback Controls**: Play, pause, skip, and seek functionality
- **Volume Control**: Adjust volume levels with ease
- **Repeat & Shuffle**: Multiple playback modes for enhanced listening
- **Playlist Management**: Create and manage custom playlists

### User Interface Features
- **Theme Support**: Light and dark mode themes
- **Now Playing Screen**: Beautiful visualization of currently playing track
- **Track Information**: Display artist, album, and song details
- **Progress Tracking**: Visual progress bar with time indicators
- **Album Artwork**: Display album cover art when available

### Technical Features
- **Fast Performance**: Optimized for smooth playback and quick loading
- **Efficient Memory Usage**: Smart caching and memory management
- **Permission Handling**: Proper request and handling of storage permissions
- **State Management**: Efficient state management for responsive UI
- **Error Handling**: Graceful error handling and user feedback

---

## 🛠️ Tech Stack

### Framework & Language
- **Flutter**: Google's UI toolkit for building natively compiled applications
- **Dart**: Programming language optimized for building mobile, desktop, server, and web applications

### Key Dependencies
The project uses several Flutter packages to provide rich functionality:

- **Audio Playback**: Audio processing and playback engine
- **State Management**: Provider/Bloc/Riverpod (based on implementation)
- **File Access**: Permission and file system handling
- **UI Components**: Material Design widgets and custom components

*Note: Run `flutter pub get` to install all dependencies listed in `pubspec.yaml`*

---

## 📁 Project Structure

```
Music-Player/
├── android/              # Android-specific files and configuration
├── ios/                  # iOS-specific files and configuration
├── lib/                  # Main application code
│   ├── main.dart        # Application entry point
│   ├── models/          # Data models and structures
│   ├── screens/         # UI screens and pages
│   ├── widgets/         # Reusable UI components
│   ├── services/        # Business logic and services
│   └── utils/           # Helper functions and utilities
├── linux/               # Linux-specific files and configuration
├── macos/               # macOS-specific files and configuration
├── test/                # Unit and widget tests
├── web/                 # Web-specific files and configuration
├── windows/             # Windows-specific files and configuration
├── .gitignore           # Git ignore rules
├── .metadata            # Flutter project metadata
├── analysis_options.yaml # Dart analyzer configuration
├── pubspec.yaml         # Project dependencies and metadata
├── pubspec.lock         # Locked versions of dependencies
└── README.md            # This file
```

---

## 📦 Prerequisites

Before you begin, ensure you have the following installed on your development machine:

### Required Software
1. **Flutter SDK** (version 3.0.0 or higher)
   - Download from [flutter.dev](https://flutter.dev/docs/get-started/install)
   - Verify installation: `flutter doctor`

2. **Dart SDK** (comes with Flutter)
   - Verify installation: `dart --version`

3. **IDE** (choose one):
   - [Android Studio](https://developer.android.com/studio) with Flutter plugin
   - [Visual Studio Code](https://code.visualstudio.com/) with Flutter extension
   - [IntelliJ IDEA](https://www.jetbrains.com/idea/) with Flutter plugin

### Platform-Specific Requirements

#### For Android Development
- Android Studio or Android SDK Command-line Tools
- Android SDK (API level 21 or higher)
- Android Emulator or physical device for testing

#### For Desktop Development
- **Windows**: Visual Studio 2019 or later with C++ development tools
- **macOS**: Xcode
- **Linux**: Appropriate build tools (`clang`, `cmake`, `ninja-build`, `libgtk-3-dev`)

---

## 🚀 Installation

Follow these steps to get the project up and running on your local machine:

### 1. Clone the Repository

```bash
git clone https://github.com/jdrizzzzz/Music-Player.git
cd Music-Player
```

### 2. Install Dependencies

```bash
flutter pub get
```

This command will download and install all the required packages listed in `pubspec.yaml`.

### 3. Verify Flutter Setup

```bash
flutter doctor
```

Ensure all required dependencies are installed and properly configured. Address any issues reported by `flutter doctor`.

### 4. Run the Application

#### On Mobile (Android)
```bash
# List available devices
flutter devices

# Run on connected device or emulator
flutter run
```

#### On Desktop
```bash
# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

### 5. Build for Production

#### Android APK
```bash
flutter build apk --release
```
---

## 🖥️ Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Android  | ✅ Supported | API level 21+ |

---

## 💡 Usage

### Basic Operations

1. **Launch the App**: Open the application on your device
2. **Grant Permissions**: Allow storage access when prompted (required for accessing music files)
3. **Browse Music**: Navigate through your music library
4. **Play Music**: Tap on any song to start playback
5. **Control Playback**: Use the player controls to play, pause, skip, or adjust volume
6. **Create Playlists**: Organize your favorite tracks into custom playlists

### Advanced Features

- **Shuffle Play**: Enable shuffle mode for random playback order
- **Repeat Modes**: Choose between repeat one, repeat all, or no repeat
- **Search**: Quickly find songs, albums, or artists
- **Now Playing Queue**: View and manage the current playback queue

---

## ⚙️ Configuration

### Customizing the App

1. **Theme Configuration**: Modify theme colors and styles in the theme configuration file
2. **App Name & Icon**: Update app name and icon in platform-specific folders
3. **Permissions**: Configure required permissions in `AndroidManifest.xml` (Android) and `Info.plist` (iOS)

### Environment Setup

Create appropriate configuration files for different environments (development, staging, production) as needed.

---

## 🤝 Contributing

Contributions are welcome and appreciated! Here's how you can contribute to this project:

### How to Contribute

1. **Fork the Repository**
   ```bash
   # Click the 'Fork' button on GitHub
   ```

2. **Create a Feature Branch**
   ```bash
   git checkout -b feature/AmazingFeature
   ```

3. **Make Your Changes**
   - Write clean, readable code
   - Follow Dart and Flutter best practices
   - Add comments where necessary

4. **Commit Your Changes**
   ```bash
   git commit -m 'Add some AmazingFeature'
   ```

5. **Push to Your Branch**
   ```bash
   git push origin feature/AmazingFeature
   ```

6. **Open a Pull Request**
   - Go to the original repository
   - Click 'New Pull Request'
   - Describe your changes in detail

### Contribution Guidelines

- Ensure your code follows the existing style and conventions
- Write meaningful commit messages
- Update documentation as needed
- Test your changes thoroughly before submitting
- One feature/fix per pull request

### Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on what's best for the community
- Show empathy towards other contributors

---

## Troubleshooting

### Common Issues and Solutions

#### App won't build
```bash
# Clean the project
flutter clean

# Get dependencies again
flutter pub get

# Try building again
flutter run
```

#### Permission Errors (Android)
- Ensure storage permissions are declared in `AndroidManifest.xml`
- Grant permissions manually in device settings

#### Audio Playback Issues
- Check if audio files are in supported formats (MP3, AAC, etc.)
- Verify file paths and permissions
- Check device volume settings

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Dart language developers
- Open-source community for various packages and tools
- Contributors who help improve this project
- Mitch KoKo youtube channel

---

## 🗺️ Roadmap

Future enhancements planned for this project:

- [ ] Cloud music streaming integration
- [ ] Equalizer with presets
- [ ] Sleep timer functionality
- [ ] Lyrics display
- [ ] Music recommendations
- [ ] Social sharing features
- [ ] Podcast support
- [ ] Chromecast/AirPlay support
- [ ] Advanced playlist features
- [ ] Music visualization effects

---



</div>
