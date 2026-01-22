# Tzlil 🎵

**Tzlil** is a modern, native iOS music player application built with **SwiftUI**. 
The project demonstrates advanced state management using the **MVI (Model-View-Intent)** architecture, emphasizing Unidirectional Data Flow, testability, and a polished user experience conforming to Apple's Human Interface Guidelines.

<img width="100" height="100" alt="1024" src="https://github.com/user-attachments/assets/e2c1ffc4-998d-4abd-b47f-062e45f3049c" />
<br>
<img width="294.75" height="639" alt="Simulator Screenshot - iPhone 16 - 2026-01-19 at 10 33 55" src="https://github.com/user-attachments/assets/62cedb01-fe38-4182-b103-24a0cf6119b3" />
<img width="294.75" height="639" alt="Simulator Screenshot - iPhone 16 - 2026-01-19 at 10 33 20" src="https://github.com/user-attachments/assets/3bf7ca7c-aace-415d-9bc4-81fb94578262" />
<img width="294.75" height="639" alt="Simulator Screenshot - iPhone 16 - 2026-01-22 at 09 38 31" src="https://github.com/user-attachments/assets/c41f6851-7f6c-429b-a583-14f57a1323d0" />


## New: AI-Driven Experience

The latest version of Tzlil introduces a smart personalization layer:

* **Dynamic Reordering:** Search results are automatically sorted to prioritize genres the user loves.
* **Explainable UI:** The interface clearly distinguishes between algorithmic recommendations ("Especially for you") and standard results, providing transparency to the user.
* **Feedback Loop:** User interactions (Likes/Favorites) are captured in real-time to refine preferences.

## Features

* **Real-time Search:** Live search functionality using the iTunes API with Combine-based debouncing.
* **Smart Recommendations:** Heuristic engine that adapts the UI based on user history.
* **ML Data Pipeline:** Built-in mechanism (`MLDataManager`) that captures and exports user interactions to train future CoreML models.
* **Audio Playback:** Robust audio handling using `AVFoundation`, including a persistent mini-player overlay.
* **Favorites System:** Local persistence for favorite tracks using `UserDefaults`.
* **MVI Architecture:** Strict state management where the View is a function of the State.
* **Accessibility:** Fully optimized for VoiceOver.

## Architecture: MVI (Model-View-Intent)

This project moves away from traditional MVVM to embrace **MVI**, ensuring a single source of truth and predictable state changes.

### The Flow
1.  **Model (State):** An immutable structure representing the entire screen state (Loading, Playing, Error, Data, Recommendations).
2.  **View:** A declarative SwiftUI view that renders based solely on the current `State`.
3.  **Intent:** The user's actions (e.g., `.play(song)`, `.loadSongs`, `.toggleFavorite`) are dispatched to the Store.
4.  **Store:** The brain of the app. It processes Intents, calculates recommendations, handles side effects (Network/Audio), and publishes a new State.

## AI & Personalization Roadmap 

The app implements a **Hybrid AI Strategy** to provide personalized experiences:

1.  **Phase 1 (Current): Heuristic Engine & Data Collection**
    * The app analyzes user favorites locally to determine preferred genres.
    * Search results are dynamically re-ordered to surface content matching the user's taste.
    * A dedicated `MLDataManager` records interactions to a JSON dataset.

2.  **Phase 2 (Future): On-Device Machine Learning**
    * The collected data will be used to train a **Tabular Classification** model using Apple's **CreateML**.
    * The static heuristic logic will be replaced by the trained `.mlmodel` for more nuanced predictions (e.g., combining Artist + BPM + Time of Day).
