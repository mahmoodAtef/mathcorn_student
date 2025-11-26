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

## Screenshots
<img width="1920" height="1080" alt="4" src="https://github.com/user-attachments/assets/c36bafd5-136d-4ed9-aea4-8fb71c8b6e9f" />
<img width="1920" height="1080" alt="3" src="https://github.com/user-attachments/assets/fb267d51-1158-4fd9-81bd-9f4217074aad" />
<img width="1920" height="1080" alt="2" src="https://github.com/user-attachments/assets/50368b2f-c95a-43b5-a9f3-4f0733395164" />
<img width="1920" height="1080" alt="1" src="https://github.com/user-attachments/assets/fde624a2-640b-446f-a5ca-f8fd57eb31ad" />
<img width="1920" height="1080" alt="6" src="https://github.com/user-attachments/assets/42046c78-e986-4518-a4f6-3407f3789371" />
<img width="1920" height="1080" alt="5" src="https://github.com/user-attachments/assets/351cf4ae-b5e3-4c77-b12d-8d69b0c93444" />

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

