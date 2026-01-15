# Tzlil 🎵

**Tzlil** is a modern, native iOS music player application built with **SwiftUI**. 
The project demonstrates advanced state management using the **MVI (Model-View-Intent)** architecture, emphasizing Unidirectional Data Flow, testability, and a polished user experience conforming to Apple's Human Interface Guidelines.

![App Banner](https://via.placeholder.com/1200x400?text=Tzlil+App+Showcase) 
*(Replace this link with a banner or remove it)*

## Features

* **Real-time Search:** Live search functionality using the iTunes API with Combine-based debouncing.
* **Audio Playback:** Robust audio handling using `AVFoundation`, including a persistent mini-player overlay.
* **Favorites System:** Local persistence for favorite tracks using `UserDefaults`.
* **MVI Architecture:** Strict state management where the View is a function of the State.
* **Accessibility** Fully optimized for VoiceOver

## Architecture: MVI (Model-View-Intent)

This project moves away from traditional MVVM to embrace **MVI**, ensuring a single source of truth and predictable state changes.

### The Flow
1.  **Model (State):** An immutable structure representing the entire screen state (Loading, Playing, Error, Data).
2.  **View:** A declarative SwiftUI view that renders based solely on the current `State`.
3.  **Intent:** The user's actions (e.g., `.play(song)`, `.loadSongs`) are dispatched to the Store.
4.  **Store:** The brain of the app. It processes Intents, handles side effects (Network/Audio), and publishes a new State.
