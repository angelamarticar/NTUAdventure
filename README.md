# NTUAdventure

NTUAdventure is a Flutter-based mobile application designed to assist users in managing courses, events, and exploring the NTUA campus with interactive maps, course ratings, and event details.

---

## Table of Contents
- [Installation](#installation)
- [Usage Instructions](#usage-instructions)
- [Requirements](#requirements)
- [Key Features](#key-features)
- [Changes from Phase 2 Prototype](#changes-from-phase-2-prototype)


---

## Installation

1. **Download APK**  
   - Download the `app-release.apk` file.

2. **Transfer to Device**  
   - Copy the APK file to your Android device using a USB cable or a file-sharing service.

3. **Enable Unknown Sources**  
   - On your device, go to `Settings > Security` and enable `Install from Unknown Sources`.

4. **Install APK**  
   - Locate the APK on your device and tap to install.

5. **Run the App**  
   - Open the app and start exploring the features.

---

## Usage Instructions

1. **Login**  
   - Use the default credentials to log in:
     - **Username:** seven@borg.com  
     - **Password:** annika  

2. **Features Navigation**  
   - **Home Page:** View your enrolled courses and upcoming events.  
   - **Courses:** Browse available courses, view details, and rate them.  
   - **Map:** Explore NTU campus landmarks and add photos for locations.  
   - **Events Calendar:** View your event schedule and access event details.  

3. **Special Features**
   - Use the camera to take photos of places on the map.
   - Submit ratings and feedback for courses.

---

## Requirements

### Software
- **Flutter SDK:** 3.6.0 or higher  
- **Android SDK:** 21 or higher  

### Dependencies
The following Flutter packages are required to run the app:
- `table_calendar` (3.0.0): Calendar view integration  
- `intl` (0.18.0): Internationalization support  
- `google_maps_flutter` (2.2.1): Google Maps integration  
- `location` (5.0.0): Device location services  
- `logging` (1.3.0): Log management  
- `custom_info_window` (1.0.1): Custom map marker info windows  
- `camera` (0.11.0+2): Camera functionalities  
- `sqflite` (2.4.1): SQLite database management  
- `path` (1.9.0): File path handling  
- `shared_preferences` (2.3.5): Persistent key-value storage  

---

## Key Features

1. **Interactive Map**
   - Navigate the NTU campus using Google Maps integration.
   - View custom markers for landmarks and upload photos for each location.

2. **Course Management**
   - Search and browse courses by name or school.
   - Rate courses on workload, difficulty, and overall experience.

3. **Event Scheduling**
   - View a personalized event calendar.
   - Sign up for events and view event details such as location, price, and description.

4. **Camera Integration**
   - Use the camera to capture and upload photos for map locations.

5. **Database-Driven**
   - All data is stored locally using SQLite, ensuring offline accessibility.

---

## Changes from Phase 2 Prototype  
- minor design changes
- structure changes: language and semester is part of course information instead of part of course rating
---

## Further developement:
- control over ones account e.g. change password, set profile picture, account recovery
- different rights for different user groups e.g. professors can create courses, change course information, esnOrganisers can create events and receive insights on the signups
- chat function
- walktrough application functionalities with paNTUA (ESN mascot) upon first opening
- increase speed of application
  
