import 'package:bizapptrack/bloc_status/status_bloc.dart';
import 'package:bizapptrack/ui/bloc_ui/status.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: kIsWeb ? DefaultFirebaseOptions.currentPlatform : null,
    );
    usePathUrlStrategy();

    runApp(BlocProvider(
      create: (context)=> StatusBloc(),
        child: const MyApp()
    ));
  } catch (error) {
    debugPrint("error di main.dart:: $error");
    debugPrint(error.toString());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bizapp Status',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StatusScreen(),
    );
  }
}