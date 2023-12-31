import 'package:bizapptrack/ui/status.dart';
import 'package:bizapptrack/viewmodel/status_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

// test action
Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    usePathUrlStrategy();

    runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => StatusController())
        ],
        child: const MyApp()));
  } catch (error) {
    debugPrint("error di main.dart:: $error");
    debugPrint(error.toString());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bizapp Status',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const TestFirebase(),
      home: const TestRenew(),
      // home: const ListToExcel(),
    );
  }
}