# Tzlil 🎵

**Tzlil** is a modern, native iOS music player application built with **SwiftUI**. 
The project demonstrates advanced state management using the **MVI (Model-View-Intent)** architecture, emphasizing Unidirectional Data Flow, testability, and a polished user experience conforming to Apple's Human Interface Guidelines.

<img width="100" height="100" alt="1024" src="https://github.com/user-attachments/assets/e2c1ffc4-998d-4abd-b47f-062e45f3049c" />
<img width="294.75" height="639" alt="Simulator Screenshot - iPhone 16 - 2026-01-19 at 10 33 55" src="https://github.com/user-attachments/assets/62cedb01-fe38-4182-b103-24a0cf6119b3" />
<img width="294.75" height="639" alt="Simulator Screenshot - iPhone 16 - 2026-01-19 at 10 33 20" src="https://github.com/user-attachments/assets/3bf7ca7c-aace-415d-9bc4-81fb94578262" />


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
