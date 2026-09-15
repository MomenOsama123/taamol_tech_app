# Tkamol Tech Trading — Modern Product Catalog

> A modern, responsive web-based product catalog for **Tkamol Tech Trading**, built with **Flutter Web** and **Supabase**.

## 🌐 Website live link

Explore the live catalog: **[Tkamol Web App](https://tkamol-tech-app.vercel.app/)**

---

## 📌 About The Project

**Tkamol Tech Trading** is an optimized, web-first product showcase platform designed to present technology products, commercial printing machinery, original & compatible inks, and office stationery.

The main goal of the platform is **streamlined product representation and efficient catalog management**. Instead of a complex multi-step e-commerce cart system, customers can easily explore product categories, search items in real-time, inspect detailed specifications, and contact sales directly via WhatsApp for quotes and purchasing inquiries.

The platform includes a secured, role-based **Admin Management Panel** that allows authorized personnel to manage the catalog, upload image URLs, update prices, and control inventory availability in real-time.

---

## ✨ Key Features

### 🛍️ Product Catalog & Navigation
- **Hierarchical Category Tree**: Clean multi-level navigation separating Main Categories from Sub-Categories (e.g., Computers → Laptops, Printing → Original Ink).
- **Responsive Layout**: Adaptive GridView layout (`SliverGridDelegateWithMaxCrossAxisExtent`) optimized for mobile, tablet, and desktop screens.
- **Dynamic Product Preview**: Displays localized names (Arabic/English), prices in SAR, categories, and inventory status badges.
- **Guest Browsing**: Full access to browse products, filter by categories, and search without forced account creation.

### 🔍 Search & Filtering
- Instant bi-lingual search engine matching products by both **Arabic** and **English** titles.
- Multi-chip interactive horizontal filters for fast main-category and sub-category sorting.

### 🔐 Authentication & Role-Based Access
- Powered by **Supabase Auth** for secure user login, registration, and session persistence.
- Automatic **Admin Role Verification** via Supabase Database profiles (`is_admin` attribute).
- Protected administrative privileges with conditional UI elements.

### 👑 Admin Management Panel
- **Add New Products**: Form validation with category selector, pricing, descriptions, and dynamic `Image URL` input with live preview.
- **Edit Products**: Update existing item details, prices, categories, or image links seamlessly.
- **Delete Products**: Secure deletion trigger with confirmation dialogs and instant UI synchronization.
- **Stock Availability Toggle**: Easily toggle items between "Available" and "Out of Stock" (red badge indicator for admins).

### 💬 Direct Communication
- Integrated WhatsApp launcher for instant product inquiries, corporate quotations, and support.

---

## 🛠️ Tech Stack & Dependencies

- **Framework**: [Flutter Web](https://flutter.dev/) (Dart)
- **Backend & Auth**: [Supabase](https://supabase.com/) (PostgreSQL, Realtime API, Auth, RLS)
- **Hosting & Deployment**: [Vercel](https://vercel.com/)
- **UI Components & Icons**: `flutter_bloc`, `url_launcher`, `google_fonts` (Tajawal / Montserrat)

---

## 🏗️ Project Architecture

The project follows a **Feature-First Architecture** combined with **Clean Code** principles to maintain scalability, isolation, and easy maintenance:

```text
lib/
├── config/                     # Application configurations & Dependency Injection
│   ├── di/
│   └── routes/                 # Routing configuration (GoRouter / Navigator)
│
├── core/                       # Core system components, constants & utilities
│   ├── constants/
│   │   ├── app_colors.dart     # Official Brand Palette (Cyan #00ADEF, Green #00A651, Purple #4B286D)
│   │   ├── app_strings.dart    # Bi-lingual Translation Engine (AR / EN)
│   │   └── product_categories.dart # Hierarchical Tree Category Models & Handlers
│   ├── theme/                  # Typography & Application Themes
│   └── utils/                  # Utility functions & helpers
│
├── features/                   # Application Features (Feature-First Structure)
│   ├── admin/                  # Administrative tools & CRUD views
│   │   └── screens/
│   │       └── add_edit_product_screen.dart
│   │
│   ├── auth/                   # Authentication logic & User Settings
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── login_screen.dart
│   │       │   ├── sign_up_screen.dart
│   │       │   └── settings_screen.dart
│   │       └── widgets/
│   │
│   └── products/               # Core catalog, product cards, & filtering
│       ├── data/
│       │   └── models/
│       │       └── product_model.dart
│       └── presentation/
│           └── pages/
│               ├── home_screen.dart
│               ├── product_details_screen.dart
│               ├── profile_screen.dart
│               └── contact_us_screen.dart
│
├── app.dart                    # Application entry configuration
└── main.dart                   # Supabase initialization & app launch
