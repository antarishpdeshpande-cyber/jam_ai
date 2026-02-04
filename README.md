# 🎵 Jam.ai - AI Music Generator

> Generate professional-quality music with AI using natural language prompts

[![Flutter](https://img.shields.io/badge/Flutter-Web-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Hosting-FFCA28?logo=firebase)](https://firebase.google.com)
[![ACE-Step](https://img.shields.io/badge/ACE--Step-1.5-green)](https://github.com/ace-step/ACE-Step-1.5)

## Overview

**Jam.ai** is an AI-powered music generation web application built with Flutter Web, hosted on Firebase, and powered by the open-source [ACE-Step-1.5](https://github.com/ace-step/ACE-Step-1.5) model running on Google Cloud Platform.

## ✨ Features

- 🎼 **Text-to-Music**: Generate music from natural language descriptions
- 🎤 **Lyrics-to-Music**: Create songs with custom lyrics
- 🎸 **Cover Generation**: Mimic the style of reference tracks
- ✂️ **Audio Repainting**: Edit specific sections of generated audio
- 🔐 **Google Authentication**: Secure sign-in with Firebase Auth
- 📚 **Music Library**: Save and manage your generated tracks

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      User's Browser                          │
│  ┌─────────────────────────────────────────────────────┐    │
│  │              Flutter Web Application                 │    │
│  └─────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    Firebase Hosting                          │
│  ┌─────────────────┐  ┌─────────────┐  ┌─────────────────┐  │
│  │  Static Assets  │  │  Firestore  │  │   Firebase Auth │  │
│  └─────────────────┘  └─────────────┘  └─────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│               Google Cloud Platform VM                       │
│  ┌─────────────────────────────────────────────────────┐    │
│  │              ACE-Step-1.5 REST API                   │    │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │    │
│  │  │  DiT Model  │  │   LM Model  │  │  GPU (CUDA) │  │    │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  │    │
│  └─────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

## 📁 Project Structure

```
jam_ai/
├── app/                    # Flutter web application
│   ├── lib/
│   │   ├── main.dart
│   │   ├── core/           # Services, models, config
│   │   └── features/       # Feature modules
│   └── web/
├── infrastructure/         # GCP deployment scripts
│   ├── setup_vm.sh
│   ├── install_model.sh
│   └── systemd/
├── docs/                   # Documentation
└── firebase.json           # Firebase configuration
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.x+)
- Firebase CLI
- Google Cloud SDK
- Node.js (for Firebase)

### Local Development

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/jam_ai.git
cd jam_ai/app

# Install dependencies
flutter pub get

# Run the web app
flutter run -d chrome
```

### Firebase Deployment

```bash
# Build the web app
cd app
flutter build web

# Deploy to Firebase
firebase deploy --only hosting
```

## 🔧 Configuration

### Environment Variables

Create a `.env` file in the `app` directory:

```env
ACE_STEP_API_URL=https://your-gcp-vm-ip:8001
ACE_STEP_API_KEY=your-api-key
```

### Firebase Setup

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Enable Google Authentication
3. Add your web app and copy the config to `app/web/index.html`

## 📖 API Reference

### Generate Music

```http
POST /release_task
Content-Type: application/json

{
  "prompt": "A cheerful pop song with acoustic guitar",
  "lyrics": "Your lyrics here...",
  "audio_duration": 60,
  "thinking": true,
  "audio_format": "mp3"
}
```

See [ACE-Step API Documentation](https://github.com/ace-step/ACE-Step-1.5/blob/main/docs/en/API.md) for complete reference.

## 📜 License

This project uses the [ACE-Step-1.5](https://github.com/ace-step/ACE-Step-1.5) model which is subject to its own license terms.

## 🙏 Acknowledgements

- [ACE-Step](https://github.com/ace-step/ACE-Step-1.5) - The powerful open-source music generation model
- [Flutter](https://flutter.dev) - UI framework for building beautiful applications
- [Firebase](https://firebase.google.com) - Backend infrastructure and hosting
