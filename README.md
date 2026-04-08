# Rumour

An anonymous chat mobile application built with Flutter, Firebase Cloud Firestore, and Clean Architecture with BLoC state management.

## Codebase Structure

The project follows a standard feature-based Clean Architecture pattern logically separated inside `lib/features/`:

- **Presentation (`/presentation`)**: UI pages, components, and BLoC classes for state management.
- **Domain (`/domain`)**: Core business logic containing Entities, Repository interfaces, and UseCases.
- **Data (`/data`)**: External data integrations containing DataSources (Firestore, SharedPreferences) and Repository implementations.

Dependency injection is managed centrally using `get_it` in `lib/injection_container.dart`.

## Firebase Data Structure

### Collection: `rooms`
- **Document ID:** 6-digit Room Code (e.g. `123456`)
- **Fields:**
  - `createdAt` (Timestamp)

#### Subcollection: `rooms/{roomId}/messages`
- **Document ID:** Auto-generated ID
- **Fields:**
  - `text` (String)
  - `senderId` (String)
  - `senderName` (String)
  - `senderAvatar` (String)
  - `createdAt` (Timestamp)

## Deployment & Deliverables

- **Working APK:** [Download rumour_app.apk](./apk/rumour_app.apk)
- **Workflow Demonstration Video:** [https://drive.google.com/file/d/1Q03fown9I8fT6mDVcIACm8SL0Gg3PUUh/view?usp=sharing]
