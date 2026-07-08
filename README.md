# Enterprise Platform

A scalable Flutter application built using **Clean Architecture**, **GetX**, and **Dio**. The project follows a feature-first architecture with a clear separation between Presentation, Domain, Data, and Core layers, making it maintainable, testable, and easy to extend.

---

# Project Architecture

```
lib/
│
├── core/
│   ├── api/
│   ├── constants/
│   ├── storage/
│   ├── theme/
│   ├── utils/
│   └── widgets/
│
├── features/
│   ├── auth/
│   ├── dashboard/
│   ├── employee/
│   ├── product/
│   └── ...
│
├── routes/
│
├── app.dart
└── main.dart
```

---

# Tech Stack

- Flutter
- Dart
- GetX
- Dio
- Flutter Secure Storage
- Flutter Dotenv
- Clean Architecture

---

# Clean Architecture

```
Presentation
      │
      ▼
UseCase
      │
      ▼
Repository
      │
      ▼
Remote Data Source
      │
      ▼
Api Service
      │
      ▼
Dio
      │
      ▼
Backend API
```

---

# Folder Structure

## Core

Contains reusable components shared across the entire application.

```
core/
│
├── api/
├── constants/
├── storage/
├── theme/
├── utils/
└── widgets/
```

---

## Features

Every feature contains its own layers.

Example:

```
features/
└── auth/
    ├── data/
    ├── domain/
    └── presentation/
```

---

# Data Layer

Responsible for communicating with APIs.

```
data/
│
├── datasources/
├── models/
│   ├── request/
│   └── response/
└── repositories/
```

### Models

Contains API request and response models.

Example

```
LoginRequestModel
LoginResponseModel
UserModel
```

---

### Datasources

Responsible for making API calls.

Example

```dart
login()

getMe()

refreshToken()
```

---

### Repository

Acts as a bridge between Domain and Data.

It hides the implementation details from the rest of the application.

---

# Domain Layer

Contains business logic.

```
domain/
│
├── repositories/
└── usecases/
```

Example

```
LoginUseCase

RefreshTokenUseCase

GetMeUseCase
```

---

# Presentation Layer

Responsible for UI.

```
presentation/
│
├── bindings/
├── controllers/
├── pages/
└── widgets/
```

---

# API Layer

## api_config.dart

Responsible for configuring Dio.

Contains

- Base URL
- Timeouts
- Headers
- Interceptors

If the backend URL changes, update this file.

---

## api_endpoints.dart

Contains all API endpoint paths.

Example

```dart
static const login = '/auth/login';
```

Never hardcode endpoint strings inside the application.

---

## base_api.dart

Defines the contract for API operations.

Supported methods

- GET
- POST
- PUT
- PATCH
- DELETE
- Upload
- Download

---

## api_service.dart

Wrapper around Dio.

Every API request goes through this class.

Responsibilities

- Execute HTTP requests
- Keep networking centralized

---

## api_response.dart

Generic response wrapper.

Maps

```json
{
    "success": true,
    "message": "",
    "data": {}
}
```

---

## api_response_handler.dart

Responsible for

- Parsing responses
- Handling Dio exceptions
- Converting errors into Failures

---

## auth_interceptor.dart

Automatically

- Adds Bearer Token
- Refreshes expired tokens
- Retries requests
- Logs out if refresh fails

---

# Authentication Flow

```
Login Page
      │
      ▼
AuthController
      │
      ▼
LoginUseCase
      │
      ▼
Repository
      │
      ▼
RemoteDataSource
      │
      ▼
ApiService
      │
      ▼
Dio
      │
      ▼
Backend
      │
      ▼
ApiResponseHandler
      │
      ▼
Repository
      │
      ▼
Controller
      │
      ▼
Save Token
      │
      ▼
Navigate Home
```

---

# API Request Flow

```
UI
│
▼
Controller
│
▼
UseCase
│
▼
Repository
│
▼
RemoteDataSource
│
▼
ApiService
│
▼
Dio
│
▼
Server
│
▼
ApiResponseHandler
│
▼
Repository
│
▼
Controller
│
▼
UI
```

---

# Where to Make Changes

### Backend URL

```
core/api/api_config.dart
```

---

### API Endpoint

```
core/api/api_endpoints.dart
```

---

### Headers

```
core/api/api_config.dart
```

---

### Timeout

```
core/api/api_config.dart
```

---

### Global Error Handling

```
core/api/api_response_handler.dart
```

---

### Authentication

```
core/api/auth_interceptor.dart
```

---

### API Request

```
features/.../data/datasources/
```

---

### Request Model

```
features/.../data/models/request/
```

---

### Response Model

```
features/.../data/models/response/
```

---

### Business Logic

```
features/.../domain/usecases/
```

---

### UI

```
features/.../presentation/
```

---

# Getting Started

## Clone Repository

```bash
git clone <repository-url>
```

---

## Install Dependencies

```bash
flutter pub get
```

---

## Configure Environment

Create a `.env` file

```env
BASE_URL=https://your-api-url.com
API_VERSION=1
```

---

## Run Project

```bash
flutter run
```

---

## Build APK

```bash
flutter build apk --release
```

---

## Build App Bundle

```bash
flutter build appbundle --release
```

---

# Best Practices

- Never call Dio directly inside Controllers.
- Never hardcode API endpoints.
- Keep business logic inside UseCases.
- Keep UI logic inside Controllers.
- Keep networking inside Datasources.
- Keep API configuration inside Core.
- Use Secure Storage for authentication tokens.
- Reuse ApiService for all network requests.

---

# Future Improvements

- Local Database (Hive/Isar)
- Offline Support
- Unit Testing
- Integration Testing
- CI/CD Pipeline
- Firebase Analytics
- Crashlytics
- Push Notifications

---

# Author

**Rajan**

Enterprise Platform Flutter Application

Built with ❤️ using Flutter & Clean Architecture.