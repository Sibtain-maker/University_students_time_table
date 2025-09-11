# University Timetable App - Authentication Flow

## 🔧 **Fixed Architecture Overview**

The authentication system has been completely restructured to solve the BlocProvider scope issues and provide a seamless user experience.

## 🏗️ **App Structure**

### **1. Global BlocProvider Setup**
```dart
// main.dart
BlocProvider(
  create: (context) => getIt<AuthBloc>(),
  child: MaterialApp(
    home: const AuthWrapper(),
  ),
)
```

- **AuthBloc is provided at the app root level**
- Available to all screens without additional providers
- Single source of truth for authentication state

### **2. AuthWrapper State Management**
The `AuthWrapper` handles automatic navigation based on auth states:

```dart
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    if (state is AuthAuthenticated) return const HomePage();
    if (state is AuthUnauthenticated) return const LoginPage();
    if (state is AuthEmailVerificationRequired) {
      return OtpVerificationPage(email: state.email);
    }
    return LoadingScreen();
  },
)
```

### **3. Navigation with BlocProvider.value**
For pushed routes, we maintain the BlocProvider context:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => BlocProvider.value(
      value: context.read<AuthBloc>(),
      child: const SignUpPage(),
    ),
  ),
);
```

## 📱 **Complete User Journey**

### **Step 1: Initial App Load**
- App starts with `AuthWrapper`
- AuthBloc checks current auth state
- Shows appropriate screen (Login/Home/Verification)

### **Step 2: User Registration**
1. **LoginPage** → Tap "Sign Up"
2. **SignUpPage** → Fill form and submit
3. **AuthBloc** processes signup → Emits `AuthEmailVerificationRequired`
4. **AuthWrapper** automatically shows `OtpVerificationPage`

### **Step 3: Email Verification**
1. **OtpVerificationPage** → User enters 6-digit code
2. **AuthBloc** verifies OTP → Emits `AuthAuthenticated`
3. **AuthWrapper** automatically shows `HomePage`

### **Step 4: Authenticated State**
- User lands on `HomePage`
- Can sign out to return to `LoginPage`
- All navigation handled by `AuthWrapper`

## 🔄 **State Flow Diagram**

```
AuthInitial
    ↓
AuthUnauthenticated → LoginPage
    ↓ (signup)
AuthEmailVerificationRequired → OtpVerificationPage  
    ↓ (verify OTP)
AuthAuthenticated → HomePage
    ↓ (sign out)
AuthUnauthenticated → LoginPage
```

## ✅ **Key Fixes Implemented**

### **1. BlocProvider Scope Issue**
- **Problem**: Each page created its own BlocProvider
- **Solution**: Single app-level BlocProvider with `BlocProvider.value` for navigation

### **2. State-Based Navigation**
- **Problem**: Manual navigation with `Navigator.push`
- **Solution**: Automatic navigation via `AuthWrapper` listening to states

### **3. Email Verification Flow**
- **Problem**: Complex manual navigation between verification screens
- **Solution**: Seamless state-driven flow from signup → verification → home

### **4. Provider Context Preservation**
- **Problem**: Lost BlocProvider context on new routes
- **Solution**: `BlocProvider.value` maintains context across navigation

## 🎯 **Benefits of This Architecture**

1. **Automatic Navigation**: No manual navigation code in auth screens
2. **Single Source of Truth**: AuthBloc manages all auth state
3. **Clean Separation**: AuthWrapper handles routing, screens handle UI
4. **Error Prevention**: No more Provider not found errors
5. **Scalable**: Easy to add new auth states and screens

## 🚀 **Ready to Use**

The authentication flow is now completely functional:
- ✅ Sign up with email verification
- ✅ OTP verification with resend functionality  
- ✅ Automatic navigation between states
- ✅ Proper error handling and user feedback
- ✅ Clean architecture maintained throughout

**The app is ready for testing and further development!**