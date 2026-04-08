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
  - `text` (String): The message content.
  - `senderId` (String): A unique ID tied securely to the user's device via SharedPreferences.
  - `senderName` (String): The user's randomly generated anonymous name.
  - `senderAvatar` (String): URL of the generated avatar.
  - `createdAt` (Timestamp): Server timestamp for chronological sorting.

## Deployment & Deliverables

- **Working APK:** [Download rumour_app.apk](./rumour_app.apk)
- **Workflow Demonstration Video:** [Paste Video Link Here]
