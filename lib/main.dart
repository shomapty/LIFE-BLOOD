import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smuctblooddonation/routes/app_routes.dart';
import 'package:smuctblooddonation/theme/theme_helper.dart';
import 'core/app_export.dart';
import 'core/utils/logger.dart';
import 'core/utils/size_utils.dart';
import 'firebase_options.dart';
import 'localization/Notification/notification.dart';
import 'localization/app_localization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalNotifications.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) {
    Logger.init(kReleaseMode ? LogMode.live : LogMode.debug);
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          translations: AppLocalization(),
          locale: Get.deviceLocale,
          fallbackLocale: Locale('en', 'US'),
          title: 'SMUCT Blood Donation',
          initialRoute: AppRoutes.initialRoute,
          getPages: AppRoutes.pages,
        );
      },
    );
  }
}
