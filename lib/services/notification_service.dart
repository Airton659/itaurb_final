// lib/services/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/bairro.dart';
import '../models/coleta.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() {
    return _instance;
  }
  NotificationService._internal();

  Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<bool> requestPermissions() async {
    final androidPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidPlugin != null) {
      final bool? notificationPermission = await androidPlugin.requestNotificationsPermission();
      final bool? exactAlarmPermission = await androidPlugin.requestExactAlarmsPermission();
      return (notificationPermission ?? false) && (exactAlarmPermission ?? false);
    }
    return false;
  }

  Future<void> agendarNotificacoesBairro(Bairro bairro) async {
    await cancelarNotificacoesBairro(bairro);

    for (var tipoColeta in bairro.coletas.keys) {
      for (var coleta in bairro.coletas[tipoColeta]!) {
        _agendarNotificacaoRecorrente(bairro.nome, tipoColeta, coleta);
      }
    }
  }
  
  Future<void> cancelarNotificacoesBairro(Bairro bairro) async {
    final List<PendingNotificationRequest> pendingRequests =
        await _notificationsPlugin.pendingNotificationRequests();
    for (var request in pendingRequests) {
      if (request.payload != null && request.payload!.startsWith(bairro.nome)) {
        await _notificationsPlugin.cancel(request.id);
      }
    }
  }

  Future<void> _agendarNotificacaoRecorrente(String bairro, String tipoColeta, Coleta coleta) async {
    final int diaDaSemana = _converterDiaParaNumero(coleta.dia);
    final int hora = int.parse(coleta.horario.split(':')[0]);
    final int minuto = int.parse(coleta.horario.split(':')[1]);

    final tz.TZDateTime scheduledDate = _proximoDiaDaSemana(diaDaSemana, hora, minuto);

    await _notificationsPlugin.zonedSchedule(
      _gerarIdUnico(bairro, tipoColeta, coleta.dia),
      'Coleta de Lixo em Itabira',
      'A coleta $tipoColeta no bairro $bairro será amanhã. Não se esqueça!',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'coleta_lixo_channel',
          'Notificações de Coleta de Lixo',
          channelDescription: 'Alertas sobre os dias de coleta de lixo.',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: '$bairro-$tipoColeta-${coleta.dia}',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      // --- CORREÇÃO FINAL APLICADA AQUI ---
      // A constante correta para combinar dia da semana e horário é 'dayOfWeekAndTime'
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }
  
  tz.TZDateTime _proximoDiaDaSemana(int diaDaSemana, int hora, int minuto) {
    tz.TZDateTime scheduledDate = _proximaData(diaDaSemana, hora, minuto);
    return scheduledDate.subtract(const Duration(days: 1));
  }

  tz.TZDateTime _proximaData(int dia, int hora, int minuto) {
    final tz.TZDateTime agora = tz.TZDateTime.now(tz.local);
    tz.TZDateTime dataAgendada = tz.TZDateTime(tz.local, agora.year, agora.month, agora.day, hora, minuto);

    if (dataAgendada.weekday == dia && dataAgendada.isBefore(agora)) {
      dataAgendada = dataAgendada.add(const Duration(days: 7));
    } else {
      while (dataAgendada.weekday != dia) {
        dataAgendada = dataAgendada.add(const Duration(days: 1));
      }
    }
    return dataAgendada;
  }

  int _gerarIdUnico(String bairro, String tipo, String dia) => (bairro.hashCode ^ tipo.hashCode ^ dia.hashCode) & 0x7FFFFFFF;

  int _converterDiaParaNumero(String dia) {
    switch (dia.toLowerCase()) {
      case 'domingo': return 7;
      case 'segunda': return 1;
      case 'terça': return 2;
      case 'quarta': return 3;
      case 'quinta': return 4;
      case 'sexta': return 5;
      case 'sábado': return 6;
      default: return 1;
    }
  }
}