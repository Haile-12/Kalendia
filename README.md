# 📅 Kalendia App - Your Smart Calendar & Event Organizer

**Your Personal Companion for Effortless Scheduling and Cultural Connections.**

Kalendia is a powerful and intuitive Flutter application designed to streamline your daily planning and event management. Beyond standard calendar functionalities, Kalendia offers a unique **Ethiopian Calendar integration** for seamless date conversion, ensuring cultural relevance for its users. With a robust notification and alarm system, personalized theming (light/dark mode), and efficient local data storage, Kalendia is built to keep you organized and informed, no matter where you are.

## ✨ Key Features

* **Comprehensive Event Management:**
    * **Create & Customize:** Easily add new events with detailed information including title, description, specific date and time, and optional reminder offsets.
    * **Edit & Delete:** Full control to modify or remove existing events.
    * **Notification Control:** Toggle notifications on/off for individual events.
* **Intuitive Calendar View:**
    * Powered by `table_calendar`, offering a clean and interactive monthly calendar view.
    * Visually indicates days with scheduled events for quick insights.
    * Smooth navigation between months and years.
* **Ethiopian Calendar Integration:**
    * A standout feature allowing bidirectional conversion between Gregorian and Ethiopian dates.
    * Dedicated "Convert" screen for precise date calculations.
    * Facilitates planning and tracking events in both calendar systems.
* **Reliable Notifications & Alarms:**
    * Utilizes `flutter_local_notifications` and `timezone` for highly accurate local event reminders.
    * **Boot-persistent:** Alarms and notifications are re-scheduled automatically after device reboots, ensuring you never miss an important event.
    * **Full-Screen Intents & Wake Lock:** Capable of triggering prominent, attention-grabbing alarms for critical events.
* **Persistent Local Data Storage:**
    * Events are securely stored locally using **Hive**, a fast and lightweight NoSQL database.
    * Ensures all your schedule data is available offline, without relying on an internet connection.
* **Dynamic Theming:**
    * Personalize your app experience by switching between a soothing **Light Mode** and an eye-friendly **Dark Mode**.
    * Themes are consistently applied throughout the application.
* **Saved Events List:**
    * A dedicated view to browse all your created events in an organized, scrollable list.
    * Provides quick access to event details for editing or review.
* **Informative About Section:**
    * Learn more about the Kalendia app and its developer.
    * Includes direct links to developer's contact information and social profiles.
* **External Application Integration:**
    * Seamlessly launch external applications like Telegram, Facebook, Instagram, and web browsers directly from the app (e.g., for sharing or accessing links).

## 🚀 Technologies and Libraries

Kalendia is built on the robust Flutter framework and leverages a suite of powerful Dart packages to deliver its rich functionality:

* **Frontend Framework:** `Flutter` (with `Dart`)
* **State Management:** `provider: ^6.1.5`
* **Local Data Persistence:**
    * `hive_flutter: ^1.1.0`
    * `hive: ^2.2.3`
    * `hive_generator: ^2.0.0`
    * `build_runner: ^2.4.15` (for code generation)
* **Notifications & Alarms:**
    * `flutter_local_notifications: ^19.1.0`
    * `timezone: ^0.10.1` (for accurate time handling)
    * `permission_handler: ^12.0.0+1` (for runtime permission requests)
* **Calendar Display:** `table_calendar: ^3.0.9`
* **Ethiopian Calendar Logic:** `ethiopian_calendar: ^0.0.2`
* **Internationalization & Date Formatting:** `intl: ^0.18.1`
* **External URL Handling:** `url_launcher: ^6.3.1`
* **App Information:** `package_info_plus: ^8.3.0`
* **UI/Icons:** `cupertino_icons: ^1.0.8`
* **Code Quality:** `flutter_lints: ^5.0.0`
* **App Icons Generation:** `flutter_launcher_icons: ^0.14.3`


## 📦 Getting Started

Follow these instructions to set up and run the Kalendia application on your local machine for development and testing.

### Prerequisites

Ensure you have the following installed on your system:

* **Git:** For cloning the repository.
    * [Download Git](https://git-scm.com/downloads)
* **Flutter SDK:** The Flutter framework. Verify your installation by running `flutter doctor` in your terminal and resolving any issues. Kalendia requires Flutter SDK version compatible with `^3.7.0`.
    * [Install Flutter](https://flutter.dev/docs/get-started/install)
* **IDE (Integrated Development Environment):**
    * **Visual Studio Code (Recommended):** Install the official Flutter and Dart extensions.
        * [Download VS Code](https://code.visualstudio.com/)
        * [Flutter extension for VS Code](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)
    * **Android Studio:** Install the Flutter and Dart plugins.
        * [Download Android Studio](https://developer.android.com/studio)
* **Android SDK (for Android development):** Typically installed with Android Studio. Ensure you have Android API Level 33 (or compatible) installed.
* **Xcode (for iOS development on macOS):** Required if you plan to build for iOS.
    * [Install Xcode](https://developer.apple.com/xcode/) (from App Store)
    * After installation, run these commands in your terminal:
        ```bash
        sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
        sudo xcodebuild -runFirstLaunch
        ```

### Installation Steps

1.  **Clone the Kalendia repository:**
    Open your terminal or command prompt and run:
    ```bash
    git clone [https://github.com/your-username/kalendia.git](https://github.com/your-username/kalendia.git) # IMPORTANT: Replace with your actual repository URL
    ```

2.  **Navigate into the project directory:**
    ```bash
    cd kalendia
    ```

3.  **Install Flutter dependencies:**
    This command fetches all the required Dart and Flutter packages listed in `pubspec.yaml`.
    ```bash
    flutter pub get
    ```

4.  **Generate Hive Adapters (Crucial Step for Local Data!):**
    Kalendia uses Hive for local data persistence. After installing dependencies, you **must** run `build_runner` to generate the necessary type adapters for your `Event` and `TimeOfDay` models.
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
    * If you make any changes to your data models (`lib/models/*.dart`), you'll need to re-run this command.
    * For continuous development, you can use `flutter pub run build_runner watch --delete-conflicting-outputs` which will automatically regenerate files upon changes.

5.  **Generate App Launcher Icons:**
    The `pubspec.yaml` is configured with `flutter_launcher_icons`. To generate the platform-specific app icons using `Assets/images/image1.png`:
    ```bash
    flutter pub run flutter_launcher_icons:main
    ```

### Android Manifest Permissions

Kalendia requires specific permissions to operate its core functionalities like notifications, alarms, and boot completion. These are already configured in `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="[http://schemas.android.com/apk/res/android](http://schemas.android.com/apk/res/android)"
    xmlns:tools="[http://schemas.android.com/tools](http://schemas.android.com/tools)"
    package="com.example.kalendia">

    <uses-permission android:name="com.android.permission.SET_ALARM"/>
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
    <uses-permission android:name="android.permission.VIBRATE"/>
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
    <uses-permission android:name="android.permission.WAKE_LOCK"/>
    <uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT"/>
    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"
        android:maxSdkVersion="32"/> <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/> <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

    <queries>
        <intent>
            <action android:name="android.intent.action.PROCESS_TEXT"/>
            <data android:mimeType="text/plain"/>
        </intent>
        <package android:name="org.telegram.messenger"/>
        <package android:name="com.facebook.katana"/>
        <package android:name="com.instagram.android"/>
        <package android:name="com.android.chrome"/>
        <package android:name="com.google.android.apps.chrome"/>
    </queries>

    </manifest>
Running the Application
Launch an Emulator or Connect a Physical Device:
```
Android: Open Android Studio, navigate to "Device Manager" (or AVD Manager), and start a virtual device. Alternatively, connect a physical Android device to your computer with USB debugging enabled.
iOS (macOS only): Open the iOS simulator by running open -a Simulator in your terminal. You can also connect a physical iOS device.
Run the application from your project directory:
```
Bash

flutter run
If you have multiple devices connected or want to specify an emulator/device, you can use:

Bash

flutter run -d <device_id>
(Find <device_id> by running flutter devices)
```
🌳 Project Structure
The project is structured to promote modularity, readability, and maintainability.
```
Bash

kalendia/
├── android/                             # Android specific files and configurations.
├── ios/                                 # iOS specific files and configurations.
├── lib/                                 # 🌟 Main application source code.
│   ├── main.dart                        # Application entry point, global setup, and routing.
│   ├── models/                          # Data models for Hive, and their generated adapters.
│   │   ├── event.dart                   # Definition of the Event data structure.
│   │   ├── event.g.dart                 # Auto-generated Hive adapter for Event.
│   │   ├── icon.dart                    # Definition for custom icons/categories (if any).
│   │   └── time_of_day_adapter.dart     # Custom Hive adapter for Flutter's TimeOfDay.
│   ├── screens/                         # UI widgets for distinct application views.
│   │   ├── about_us.dart                # Information about the app and developer.
│   │   ├── add_event.dart               # Screen for creating or editing events.
│   │   ├── calander_view.dart           # Detailed calendar view component.
│   │   ├── convert.dart                 # Screen for Gregorian <-> Ethiopian date conversion.
│   │   ├── home.dart                    # The main home screen, often displaying the calendar.
│   │   ├── info_page.dart               # Potentially supplementary info or part of about_us.dart.
│   │   ├── saved_events.dart            # Screen displaying a list of all saved events.
│   │   └── settings.dart                # Application settings (e.g., theme toggle).
│   ├── services/                        # Business logic and data manipulation services.
│   │   └── event_service.dart           # Handles event CRUD operations and notification scheduling.
│   ├── utils/                           # Utility functions and helper classes.
│   │   ├── date_converter.dart          # Helper functions for date conversions.
│   │   └── theme_service.dart           # Manages and provides the application's theme state.
│   └── widget/                          # Reusable UI components used across screens.
│       └── theme_switch.dart            # A custom widget for toggling light/dark theme.
├── Assets/                              # Application assets (images, fonts, etc.).
│   └── images/                          # Image assets used in the application.
│       ├── image1.png                   # Main app icon image.
│       ├── HH.png                       # Another image asset.
│       ├── hailsh.png                   # Image related to developer/profile.
│       ├── developer.png                # Another developer-related image.
│       └── kalendi.png                  # App branding image.
├── pubspec.yaml                         # Project configuration, dependencies, assets, and metadata.
├── README.md                            # This documentation file.
└── .gitignore                           # Specifies files/directories to be excluded from Git version control.
```
👋 Contributing

We welcome contributions to the Kalendia project! 
Whether it's bug fixes, new features, or improvements to documentation, your input is valuable.
Please follow these steps to contribute:

Fork the Repository: Click the "Fork" button at the top right of this page on GitHub.
Clone Your Fork: Clone your forked repository to your local machine:
Bash

git clone [https://github.com/Haile-12/kalendia.git](https://github.com/Haile-12/kalendia.git)
cd kalendia
Create a New Branch: Create a dedicated branch for your feature or bug fix:
Bash

git checkout -b feature/your-awesome-feature # For new features
# OR
git checkout -b fix/bug-description         # For bug fixes
Make Your Changes: Implement your changes, ensuring code quality, consistency, and adding comments where necessary.
Run Tests: Before committing, ensure all existing tests pass and consider adding new tests for your changes.
Bash

flutter test
Commit Your Changes: Write a clear and concise commit message.
Bash


📞 Contact & Support
For any questions, issues, or collaborations, feel free to reach out to the developer:

Developer: Haile Tassew Belay
Email: hailetassew4545@gmail.com
GitHub: github.com/Haile-12
LinkedIn: linkedin.com/in/haile12_12
Built with ❤️ in Flutter, designed for clarity and cultural relevance.
