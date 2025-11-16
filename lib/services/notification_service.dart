import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Manejar cuando el usuario toca la notificación
        print('Notificación tocada: ${details.payload}');
      },
    );

    // Solicitar permisos en Android 13+
    await _requestPermissions();

    _initialized = true;
  }

  Future<void> _requestPermissions() async {
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }

    final iosPlugin = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    
    if (iosPlugin != null) {
      await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  Future<void> mostrarNotificacionNoticias() async {
    await initialize();

    const androidDetails = AndroidNotificationDetails(
      'noticias_channel',
      'Noticias Electorales',
      channelDescription: 'Notificaciones de noticias electorales',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFFE53935),
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      0,
      '📰 Nuevas Noticias Electorales',
      'Hay actualizaciones de El Comercio sobre las elecciones 2026',
      details,
      payload: 'noticias',
    );
  }

  Future<void> mostrarNotificacionPersonalizada({
    required int id,
    required String titulo,
    required String mensaje,
    String? payload,
  }) async {
    await initialize();

    const androidDetails = AndroidNotificationDetails(
      'general_channel',
      'Notificaciones Generales',
      channelDescription: 'Notificaciones generales de la app',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFFE53935),
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      id,
      titulo,
      mensaje,
      details,
      payload: payload,
    );
  }

  Future<void> cancelarNotificacion(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelarTodas() async {
    await _notifications.cancelAll();
  }
}
