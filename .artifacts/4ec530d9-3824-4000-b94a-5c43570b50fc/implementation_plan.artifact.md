# Fix Runtime TypeError and Import Resolution

Fix the `TypeError: Cannot read properties of undefined (reading 'key')` by correcting invalid import paths and updating translation logic to correctly display localized text.

## User Review Required

> [!IMPORTANT]
> I will be switching all imports to **package imports** (`package:taamol_tech/...`). This is the standard best practice for Flutter projects as it prevents path resolution errors and ensures that components are correctly identified as the same types across the application.

## Proposed Changes

### Core Constants

#### [MODIFY] [app_strings.dart](file:///D:/Material/Coding/Flutter/Taamol%20tech/taamol_tech/lib/core/constants/app_strings.dart)
- No changes needed here, but it will be correctly imported by other files.

---

### Auth Feature

#### [MODIFY] [splash.dart](file:///D:/Material/Coding/Flutter/Taamol%20tech/taamol_tech/lib/features/auth/splash.dart)
- Replace broken relative imports with package imports.
- Fix the `OnboardingScreen` import path.
- Wrap `appNameAr` and `appNameEn` with `AppStrings.tr()` to display the actual text instead of the key names.

#### [MODIFY] [onboarding_screen.dart](file:///D:/Material/Coding/Flutter/Taamol%20tech/taamol_tech/lib/features/auth/presentation/screens/onboarding_screen.dart)
- Convert all relative imports to package imports for consistency and stability.

---

### App Entry Point

#### [MODIFY] [main.dart](file:///D:/Material/Coding/Flutter/Taamol%20tech/taamol_tech/lib/main.dart)
- Remove duplicate splash screen import.
- Convert imports to package imports.

## Verification Plan

### Automated Tests
- I will verify that the project structure is intact and imports resolve correctly by suggesting a build or analysis step if possible.

### Manual Verification
- Run the app on Flutter Web.
- Verify the Splash Screen displays the company name correctly (not the key name).
- Verify that after 3 seconds, it successfully navigates to the Onboarding Screen without crashing.
