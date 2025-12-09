# OS Mastery Study Tracker

A manga/comic-themed study tracking app for Operating Systems course content, built with Flutter.

## Features

### Manga-Themed UI
- **Pure Japanese manga/comic aesthetics** - Bold black borders, hand-drawn style fonts, speech bubbles
- **Dynamic animations** - Splash screen with rotating logo, fade transitions, speedline effects
- **Custom widgets** - Manga panels, action bubbles, progress bars with comic styling
- **No emojis** - Pure manga visual language

### Study Tracking
- **4 Complete Modules** covering all OS topics:
  - Module 2: Process, Scheduling & Threads
  - Module 3: Process Synchronization & Deadlocks
  - Module 4: Memory Management
  
### Content Included
- **Detailed theory** for each topic
- **Previous Year Questions (PYQs)** categorized as theory or numerical
- **Progress tracking** with completion status
- **Study timer** that automatically tracks time spent on each topic
- **Overall statistics** showing completed topics and total study time

### Cache Storage
- Progress automatically saved using SharedPreferences
- Data persists between app sessions
- No internet connection required

## App Structure

```
lib/
├── main.dart                      # App entry point
├── data/
│   └── os_content.dart           # All study content and PYQs
├── models/
│   └── study_content.dart        # Data models
├── screens/
│   ├── splash_screen.dart        # Animated splash screen
│   ├── home_screen.dart          # Module overview
│   ├── module_screen.dart        # Topic list
│   └── topic_detail_screen.dart  # Content and PYQs
├── services/
│   └── storage_service.dart      # Progress caching
├── theme/
│   └── manga_theme.dart          # Manga styling
└── widgets/
    └── manga_widgets.dart        # Custom UI components
```

## How to Use

### Installation
```bash
flutter pub get
flutter run
```

### Navigation
1. **Home Screen** - View overall progress and select modules
2. **Module Screen** - Browse topics within a module
3. **Topic Detail Screen** - Read content, view PYQs, mark as complete

### Features
- Tap any module card to view its topics
- Tap any topic to view full content
- Timer automatically starts when viewing a topic
- Tap the floating button to mark topic as complete
- Progress is saved automatically

## Course Content Coverage

### Module 2: Process + Scheduling + Threads
- ✓ Process concepts, states, PCB
- ✓ CPU scheduling algorithms (FCFS, SJF, SRTN, Priority, RR)
- ✓ Threads and multithreading
- ✓ All related PYQs included

### Module 3: Process Synchronization & Deadlocks
- ✓ Concurrency and critical section
- ✓ Semaphores and synchronization problems
- ✓ Deadlock conditions, prevention, avoidance, detection
- ✓ All related PYQs included

### Module 4: Memory Management
- ✓ Partitioning and allocation strategies
- ✓ Paging and segmentation
- ✓ Virtual memory and page replacement
- ✓ All related PYQs included

## Technical Details

### Dependencies
- **flutter**: SDK
- **shared_preferences**: ^2.2.2 - Progress caching
- **google_fonts**: ^6.1.0 - Manga-style fonts (Bangers, Comic Neue)

### Key Design Elements
- **Colors**: Black ink, paper white, manga red, highlight yellow
- **Fonts**: Bangers for titles, Comic Neue for body text
- **Borders**: Bold 3px black borders on all panels
- **Shadows**: Hard shadows for comic effect
- **Animations**: Elastic, bounce, and fade effects

## Future Enhancements
- Quiz mode for PYQs
- Flashcard system
- Study streak tracking
- Notes feature
- Dark mode (if needed)

## License
Educational use only.
