# University Timetable App Setup

## Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Supabase account

## Setup Instructions

### 1. Clone and Install Dependencies
```bash
flutter pub get
```

### 2. Environment Configuration
1. Copy `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```

2. Update `.env` with your Supabase credentials:
   ```
   SUPABASE_URL=your_supabase_project_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

### 3. Supabase Setup
1. Create a new project at [supabase.com](https://supabase.com)
2. Get your project URL and anon key from Settings > API
3. Update the `.env` file with these values
4. **Important**: Configure OTP email settings in Authentication:
   
   **Step A: Email Templates**
   - Go to Authentication > Email Templates
   - Edit the "Magic Link" template
   - Change the template to send a **6-digit code** instead of a link
   - Use this template body:
   ```
   Your verification code is: {{ .TokenHash }}
   
   Enter this code in the app to verify your email.
   
   This code expires in 1 hour.
   ```

   **Step B: Authentication Settings**
   - Go to Authentication > Settings
   - Under "User Signups", keep "Enable email confirmations" **DISABLED**
   - This prevents the confirmation link emails we saw in the screenshots
   
   **Step C: Email Configuration** 
   - Ensure SMTP is properly configured for reliable email delivery
   - Test that OTP codes are delivered as 6-digit numbers, not links

### 4. Run the App
```bash
flutter run
```

## Features Implemented
- ✅ Clean Architecture with BLoC pattern
- ✅ User authentication (sign up/sign in)
- ✅ Email verification with OTP codes
- ✅ Animated UI components with smooth transitions
- ✅ Environment-based configuration
- ✅ Dependency injection with GetIt
- ✅ Real-time OTP input with auto-focus
- ✅ Resend code functionality with countdown timer

## Security Notes
- Supabase keys are stored in `.env` file (not committed to version control)
- The `.env` file is added to `.gitignore` for security
- Use environment variables for all sensitive configuration

## Architecture
```
lib/
├── core/                   # Core functionality
│   ├── di/                # Dependency injection
│   ├── error/             # Error handling
│   ├── params/            # Parameter classes
│   └── usecases/          # Base use case
├── features/              # Feature modules
│   └── auth/             # Authentication feature
│       ├── data/         # Data layer
│       ├── domain/       # Domain layer
│       └── presentation/ # Presentation layer
└── shared/               # Shared widgets and utilities
```