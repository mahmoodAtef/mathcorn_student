# MathCorn

MathCorn is a comprehensive educational platform built with Flutter, designed to provide students with a seamless learning experience. The application offers a range of features including course management, exam taking, resource libraries, and secure payment integration.

## Overview

MathCorn aims to digitize the learning process, making it accessible and engaging for students. It leverages the power of Flutter for a cross-platform experience and Firebase for a robust backend.

## Key Features

-   **Authentication**: Secure user sign-up and login using Firebase Authentication.
-   **Course Management**: Browse and enroll in mathematics courses.
-   **Exam System**: Take exams and track progress.
-   **Library**: Access to educational resources and PDFs.
-   **Video Playback**: Integrated YouTube player for video lessons.
-   **Notifications**: Real-time updates and announcements via Firebase Cloud Messaging.
-   **Payments**: Secure payment processing with Paymob.
-   **Student Profile**: Manage personal information and academic history.
-   **Settings**: Customizable app experience with Theme switching (Dark/Light mode) and Localization (Multi-language support).
-   **Offline Support**: Caching and local storage for essential data.

## Tech Stack & Dependencies

This project relies on a modern tech stack to ensure performance and scalability:

-   **Framework**: [Flutter](https://flutter.dev/)
-   **Language**: [Dart](https://dart.dev/)
-   **State Management**:
    -   `flutter_bloc`
    -   `hydrated_bloc` (for persistent state)
-   **Dependency Injection**: `get_it`
-   **Backend & Services**:
    -   **Firebase**: Auth, Firestore, Messaging, Storage
    -   **Paymob**: Payment Gateway
-   **UI & Utilities**:
    -   `sizer` (Responsive design)
    -   `animated_splash_screen`
    -   `fluttertoast`
    -   `flutter_svg`
    -   `google_fonts` (Cairo font family)
-   **Media & Files**:
    -   `youtube_player_flutter`
    -   `flutter_pdfview`
    -   `syncfusion_flutter_pdfviewer`
    -   `file_picker`
-   **Other**:
    -   `connectivity_plus`
    -   `package_info_plus`
    -   `equatable`
    -   `flutter_secure_storage`

## Project Structure

The project follows a clean architecture approach, organized by features:

```
lib/
├── core/                   # Shared resources
│   ├── services/           # DI, Localization, App Initialization
│   ├── utils/              # Theme, Constants, Helpers
│   ├── widgets/            # Reusable UI components
│   ├── error/              # Error handling classes
│   └── routing/            # Navigation logic
├── modules/                # Feature-specific code
│   ├── auth/               # Authentication (Login, Register)
│   ├── courses/            # Course listing and details
│   ├── exams/              # Exam taking and results
│   ├── library/            # PDF and resource library
│   ├── notifications/      # Notification handling
│   ├── payment/            # Payment processing
│   ├── settings/           # App settings (Theme, Language)
│   └── student/            # Student profile and data
├── generated/              # Generated code (Localization, Assets)
└── main.dart               # Application entry point
```

## Installation

To get a local copy up and running, follow these steps:

1.  **Prerequisites**:
    -   [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
    -   An IDE (VS Code or Android Studio) with Flutter plugins.

2.  **Clone the repository**:
    ```bash
    git clone (https://github.com/mahmoodAtef/mathcorn_student)
    cd mathcorn_student
    ```

3.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

4.  **Firebase Setup**:
    -   Ensure you have the `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) placed in their respective directories (`android/app` and `ios/Runner`).

## How to Run

Run the application on your preferred device or emulator:

```bash
flutter run
```

## Screenshots

| Login Screen | Home Dashboard | Course Details |
| :---: | :---: | :---: |
| ![Login](assets/images/placeholder_login.png) | ![Home](assets/images/placeholder_home.png) | ![Course](assets/images/placeholder_course.png) |
