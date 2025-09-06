import 'package:flutter/material.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/properties/data/models/property.dart';
import 'features/properties/presentation/pages/property_detail_page.dart';
import 'features/properties/presentation/pages/property_form_page.dart';
import 'features/properties/presentation/pages/property_list_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/login':
      return MaterialPageRoute(builder: (_) => const LoginPage());

    case '/form':
      return MaterialPageRoute(
        builder: (_) => const PropertyFormPage(),
        settings: settings, // conserva args si los hubiera
      );

    case '/detail':
      final prop = settings.arguments is Property ? settings.arguments as Property : null;
      return MaterialPageRoute(
        builder: (_) => PropertyDetailPage(item: prop),
        settings: settings,
      );

    case '/':
    default:
      return MaterialPageRoute(builder: (_) => const PropertyListPage());
  }
}
