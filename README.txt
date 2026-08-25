Love App (Flutter Web)

Quick setup and build instructions (run locally after you ensured Flutter is installed and web is enabled):

1. Open a terminal and navigate to this folder:
   cd "C:\Users\Owner\Desktop\Python Learning\flutter dart\love_app"

2. Get packages (no external deps, but run this to be safe):
   flutter pub get

3. Run in Chrome for quick preview:
   flutter run -d chrome

4. Analyze and build for web:
   flutter analyze
   flutter build web

5. After successful build, the web folder is at:
   <project-root>\build\web
   Open build\web\index.html in a browser, or serve it:
   cd build\web
   python -m http.server 8000
   then open http://localhost:8000

Notes:
- This project is intentionally simple and uses only Flutter SDK (no external packages).
- To change texts and colors, edit lib/main.dart (comments point to configurable sections).
- If anything fails, paste the flutter analyze or flutter build output here and I'll help.
