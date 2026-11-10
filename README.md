# DemoBank iOS App and Appium Tests

This repository contains the **DemoBank iOS mobile app** and the **Appium automation tests written for that app**. The Swift files are the application; the Java files are tests that drive and verify the application.

## Repository layout

- `ios-app/` — DemoBank iOS app built with SwiftUI. Open `ios-app/DemoBank.xcodeproj` in Xcode to work on the app.
- `appium-tests/` — IntelliJ IDEA Gradle project containing the Java Appium tests for DemoBank.

## Run the tests

Open `appium-tests/` as a Gradle project in IntelliJ IDEA. Start an Appium server and make sure the DemoBank app is available on the configured iOS simulator/device, then run the tests from IntelliJ or with:

```bash
cd appium-tests
./gradlew test
```

The test capabilities and app bundle identifier are configured in `appium-tests/src/test/java/az/mobileqa/IOSBankingTests.java`.
