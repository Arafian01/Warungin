@echo off
echo ========================================
echo Cleaning Flutter Build
echo ========================================
echo.

echo Step 1: Flutter Clean...
call flutter clean

echo.
echo Step 2: Flutter Pub Get...
call flutter pub get

echo.
echo Step 3: Cleaning Android Build...
cd android
call gradlew clean
cd ..

echo.
echo ========================================
echo Clean Complete!
echo ========================================
echo.
echo Now you can run: flutter run
echo.
pause
