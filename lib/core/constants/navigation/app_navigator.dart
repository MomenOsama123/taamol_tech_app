import 'package:flutter/material.dart';

/// Shared navigator key so code outside the widget tree can push new screens.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();