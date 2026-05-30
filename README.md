# Flutter Labs 🚀

Welcome to the **Flutter Labs** repository! This repository consolidates multiple Flutter projects, labs, and exercises organized by their source directories.

---

## 📂 Repository Structure

The repository is organized into the following main directories to prevent naming conflicts and maintain clear categorization:

### 🔹 [C_firebase_todo_app](file:///C:/Users/dorjo/.gemini/antigravity/scratch/Flutter_Labs/C_firebase_todo_app)
Contains a Firebase-integrated Todo Application.
*   **[firebase_todo_app](file:///C:/Users/dorjo/.gemini/antigravity/scratch/Flutter_Labs/C_firebase_todo_app/firebase_todo_app)**: Todo App with Firebase authentication, firestore database, and smooth animations.
    > [!IMPORTANT]
    > **Security Note:** Sensitive Firebase configuration files (`google-services.json`, `GoogleService-Info.plist`) and API Keys have been sanitized and excluded from this repository to prevent credential leaks.

### 🔹 [D_Flutter_projects](file:///C:/Users/dorjo/.gemini/antigravity/scratch/Flutter_Labs/D_Flutter_projects)
Projects imported from `D:\Flutter projects`:
*   **[bloc_chat_app](file:///C:/Users/dorjo/.gemini/antigravity/scratch/Flutter_Labs/D_Flutter_projects/bloc_chat_app)**: Chat application utilizing the BLoC state management pattern.
*   **[lab6](file:///C:/Users/dorjo/.gemini/antigravity/scratch/Flutter_Labs/D_Flutter_projects/lab6)**: Laboratory exercise #6.
*   **[tank_game](file:///C:/Users/dorjo/.gemini/antigravity/scratch/Flutter_Labs/D_Flutter_projects/tank_game)**: Flutter-based mobile tank arcade game.
*   **[tetris_game](file:///C:/Users/dorjo/.gemini/antigravity/scratch/Flutter_Labs/D_Flutter_projects/tetris_game)**: Classic Tetris game implementation.

### 🔹 [D_IT_Flutter_projects](file:///C:/Users/dorjo/.gemini/antigravity/scratch/Flutter_Labs/D_IT_Flutter_projects)
University IT labs and projects imported from `D:\IT\Flutter projects`:
*   **[Game](file:///C:/Users/dorjo/.gemini/antigravity/scratch/Flutter_Labs/D_IT_Flutter_projects/Game)**: Mini-game project.
*   **[flutter_application_1](file:///C:/Users/dorjo/.gemini/antigravity/scratch/Flutter_Labs/D_IT_Flutter_projects/flutter_application_1)**: Flutter sandbox application.
*   **[lab3](file:///C:/Users/dorjo/.gemini/antigravity/scratch/Flutter_Labs/D_IT_Flutter_projects/lab3)** to **[lab8](file:///C:/Users/dorjo/.gemini/antigravity/scratch/Flutter_Labs/D_IT_Flutter_projects/lab8)**: Laboratory assignments 3, 4, 5, 6, 7, 8 (including subtasks like `lab3_1`, `lab4_1`).
*   **[tank_battle_game](file:///C:/Users/dorjo/.gemini/antigravity/scratch/Flutter_Labs/D_IT_Flutter_projects/tank_battle_game)**: 2D tank battle simulation game.

---

## 🛠️ Security & Safe Pushes

To maintain the highest level of security, the repository has been configured with strict `.gitignore` rules that automatically block and ignore sensitive files:
*   `google-services.json` (Android Firebase)
*   `GoogleService-Info.plist` (iOS Firebase)
*   `.env` and `.env.*` files (Environment secrets)
*   `local.properties` and `key.properties` (Android build keys)
*   Keystore and JKS files (Android release signing keys)
*   Build directories (`build/`, `.dart_tool/`) are completely excluded to keep the repository size optimal.
