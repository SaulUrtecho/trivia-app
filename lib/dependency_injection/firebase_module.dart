part of 'di.dart';

Future<void> registerFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final pushNotificationsManager = PushNotificationsManager(FirebaseMessaging.instance);
  await pushNotificationsManager.setup();
  getIt.registerLazySingleton(() => pushNotificationsManager);
}
