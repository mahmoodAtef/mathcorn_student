import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:math_corn/modules/notifications/data/models/app_notifications.dart';

class NotificationServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;

  Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    // await setupFlutterNotifications();
    await showNotification(message);
  }

  Future<void> initialize() async {
    await _requestPermission();
    Future.wait([_setupMessageHandlers(), setupFlutterNotifications()]);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _requestPermission() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );
  }

  Future<void> _setupMessageHandlers() async {
    // Foreground
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });

    // Background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    // App opened from terminated state
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage);
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    // Implement navigation or logic on message tap if needed
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) return;

    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    final initializationSettingsDarwin = DarwinInitializationSettings();

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    final RemoteNotification? notification = message.notification;
    final AndroidNotification? android = message.notification?.android;

    // if (notification != null && android != null) {
    await _localNotifications.show(
      notification.hashCode,
      notification?.title,
      notification?.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: message.data.toString(),
    );
  }

  Future<List<AppNotification>> getNotifications({
    required String grade,
  }) async {
    List<AppNotification> notifications = [];
    Future.wait([
      _firestore
          .collection('notifications')
          .where('grade', isEqualTo: grade)
          .get(),
      _firestore
          .collection('user')
          .doc(_auth.currentUser!.uid)
          .collection('notifications')
          .get(),
    ]).then((value) {
      List<AppNotification> publicNotifications = List.from(
        value[0].docs.map((e) => AppNotification.fromJson(e.data())),
      );
      List<AppNotification> privateNotifications = List.from(
        value[1].docs.map((e) => AppNotification.fromJson(e.data())),
      );
      notifications.addAll(publicNotifications + privateNotifications);
    });
    notifications.sort((a, b) => b.date.compareTo(a.date));
    return notifications.toSet().toList();
    // return dummyNontifications;
  }

  Future<void> markNotificationAsRead({required String notificationId}) async {
    await _firestore
        .collection('user')
        .doc(_auth.currentUser!.uid)
        .collection('notifications')
        .doc(notificationId)
        .delete();
  }

  Future<String> getMessageOfTheDay() async {
    DocumentSnapshot snapshot = await _firestore
        .collection('messageOfTheDay')
        .doc('messageOfTheDay')
        .get();
    Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
    return data["message"];
  }

  Future<void> subscribeToNotifications({required String grade}) async {
    await _firebaseMessaging.requestPermission();
    String? token = await _firebaseMessaging.getToken();
    Future.wait([
      _firebaseMessaging.subscribeToTopic(grade),
      _firestore.collection('user').doc(_auth.currentUser!.uid).update({
        'fcmToken': token,
      }),
    ]);
  }
}

List<AppNotification> dummyNontifications = [
  AppNotification(
    id: "1",
    title: "Notification 1",
    body: "Notification 1 body",
    type: "public",
    date: DateTime.now(),
  ),
  AppNotification(
    id: "2",
    title: "Notification 2",
    body: "Notification 2 body",
    type: "private",
    date: DateTime.now(),
  ),
  AppNotification(
    id: "3",
    title: "Notification 3",
    body: "Notification 3 body",
    type: "public",
    date: DateTime.now(),
  ),
  AppNotification(
    id: "4",
    title: "Notification 4",
    body: "Notification 4 body",
    type: "private",
    date: DateTime.now(),
  ),
  AppNotification(
    id: "5",
    title: "Notification 5",
    body: "Notification 5 body",
    type: "public",
    date: DateTime.now(),
  ),
  AppNotification(
    id: "6",
    title: "Notification 6",
    body: "Notification 6 body",
    type: "private",
    date: DateTime.now(),
  ),
];
