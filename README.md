# Genetics and Evolution Quiz App

## Project Overview
The **Genetics and Evolution Quiz App** is a Flutter-based interactive quiz application designed to test users' knowledge of genetics and evolution. The app provides gamification features, including scoring, lives, background sounds, and a visually appealing UI. It fetches quiz data dynamically from an API and offers a seamless experience for users.

## Features
- **Dynamic Quiz Data**: Quiz questions and options are fetched from a remote API.
- **Gamification Elements**:
  - Scores are updated for correct answers.
  - Lives decrease for incorrect answers.
- **Audio Effects**:
  - Background sound on the home and result screens.
  - Correct and incorrect answer sound effects.
- **Background Images**: The app includes themed backgrounds for each screen.
- **Retry Functionality**: Users can retry the quiz after completing it.

## Screenshots
### Home Screen
![Home Screen](![homescreen](https://github.com/user-attachments/assets/e52e123e-dfc9-4b8d-97e8-d152bf1d6c69)
)

### Quiz Screen
![Quiz Screen](![quizscreen](https://github.com/user-attachments/assets/6aafc138-d67d-4d1a-9afc-a5edd338da6b)
)

### Result Screen (Success)
![Result Screen - Success](![result_success](https://github.com/user-attachments/assets/26659e63-cf8e-446a-9aa4-8c0922fd166b)
)

### Result Screen (Game Over)
![Result Screen - Game Over](![gameover](https://github.com/user-attachments/assets/3a31ee32-3012-4ce2-80e3-d53e1d1c5a55)
)

## Video Walkthrough
[Click here to watch the video walkthrough]()

---

## Setup Instructions

### Prerequisites
1. Install [Flutter](https://flutter.dev/docs/get-started/install) and ensure it is set up on your system.
2. Install any code editor of your choice (e.g., [Android Studio](https://developer.android.com/studio), [Visual Studio Code](https://code.visualstudio.com/)).

### Steps
1. Clone the repository:
   ```bash
   git clone <repository-link>
   ```

2. Navigate to the project directory:
   ```bash
   cd quiz_app
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Add the required assets:
   - Place the background images in `assets/images/`.
   - Place the audio files in `assets/sounds/`.

5. Run the app:
   ```bash
   flutter run
   ```

### Notes
- The app requires an internet connection to fetch quiz data from the API.
- Ensure your Flutter environment is correctly set up to avoid runtime errors.

---

## API Used
The quiz data is fetched from the following API:
- **Endpoint**: `https://api.jsonserve.com/Uw5CrX`
- **Response Format**:
  ```json
  {
    "questions": [
      {
        "description": "Question text here",
        "options": [
          { "description": "Option 1", "is_correct": true },
          { "description": "Option 2", "is_correct": false }
        ]
      }
    ]
  }
  ```

## Folder Structure
```
quiz_app/
├── lib/
│   ├── main.dart       # Main application file
├── assets/
│   ├── images/         # Background images
│   ├── sounds/         # Audio files
├── screenshots/        # App screenshots
├── videos/             # App demo video
├── pubspec.yaml        # Dependency file
```

---

## Contribution
Contributions are welcome! If you'd like to improve the app, feel free to fork the repository and create a pull request.


