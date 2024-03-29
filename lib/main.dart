import 'package:device_preview/device_preview.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/rendering.dart';
import 'package:protein_tracker/theme/color_schemes.g.dart';
import 'package:protein_tracker/di/service_locator.dart';
import 'package:protein_tracker/firebase_options.dart';
import 'package:protein_tracker/ui/widgets/widget_tree.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  setupLogging();
  ServiceLocator().setupLocator();

  runApp(
      DevicePreview(enabled: false, builder: ((context) => const PeachyApp())));
}

class PeachyApp extends StatelessWidget {
  const PeachyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // showLayoutBounds
    debugPaintSizeEnabled = false;
    
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        colorScheme: lightColorScheme,
        useMaterial3: true
      ),
      home: const Scaffold(
        body: WidgetTree(),
      ),
    );
  }
}

void setupLogging() {
  Logger.root.level = Level.ALL; // Set logging level to log all messages
  Logger.root.onRecord.listen((rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}
