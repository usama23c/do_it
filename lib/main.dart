import 'package:do_it/widgets/main_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart'; // for kReleaseMode

import 'firebase_options.dart';
import 'views/splash/splash_screen.dart';
import 'views/tasks/model/task_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  await Hive.openBox<TaskModel>('tasks');

  // Check login status
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // Enabled only in debug mode
      builder: (context) => MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, this.isLoggedIn = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DO IT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: isLoggedIn ? const MainScreen() : const SplashScreen(),
      builder: DevicePreview.appBuilder, // Wrap with DevicePreview builder
      locale: DevicePreview.locale(context), // Set locale from DevicePreview
    );
  }
}
