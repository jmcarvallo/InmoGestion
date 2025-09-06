import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/properties/data/datasources/property_dao.dart';
import 'features/properties/data/repositories/property_repository.dart';
import 'features/properties/presentation/providers/property_provider.dart';
import 'router.dart';
import 'features/auth/data/session_prefs.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const InmoApp());
}

class InmoApp extends StatefulWidget {
  const InmoApp({super.key});

  @override
  State<InmoApp> createState() => _InmoAppState();
}

class _InmoAppState extends State<InmoApp> {
  String _initialRoute = '/login';
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final logged = await SessionPrefs().isLoggedIn();
    setState(() {
      _initialRoute = logged ? '/' : '/login';
      _checking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PropertyProvider(PropertyRepository(PropertyDao())),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'InmoGestión',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
        initialRoute: _initialRoute,
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
