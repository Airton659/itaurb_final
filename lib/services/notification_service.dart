// lib/services/notification_service.dart
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import '../models/bairro.dart';
import '../models/coleta.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> init() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/res_notification_app_icon',
      [
        NotificationChannel(
          channelKey: 'coleta_notification_channel',
          channelName: 'Notificações de Coleta',
          channelDescription: 'Alertas sobre os dias de coleta de lixo no seu bairro.',
          defaultColor: const Color(0xFF5C9DD5),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
        )
      ],
      debug: true,
    );
  }

  Future<bool> requestPermissions() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      isAllowed = await AwesomeNotifications().requestPermissionToSendNotifications();
    }
    return isAllowed;
  }

  Future<void> agendarNotificacoesBairro(Bairro bairro) async {
    await cancelarNotificacoesBairro(bairro); // Garante que não haja agendamentos duplicados

    for (var tipoColeta in bairro.coletas.keys) {
      for (var coleta in bairro.coletas[tipoColeta]!) {
        _agendarNotificacaoRecorrente(bairro.nome, tipoColeta, coleta);
      }
    }
  }

  Future<void> _agendarNotificacaoRecorrente(String bairro, String tipoColeta, Coleta coleta) async {
    try {
      int diaSemana = _converterDiaParaNumero(coleta.dia);
      List<String> horario = coleta.horario.split(':');
      int hora = int.parse(horario[0]);
      int minuto = int.parse(horario[1]);

      int diaSemanaNotificacao = (diaSemana - 1) < 1 ? 7 : (diaSemana - 1);
      int notificationId = _gerarIdUnico(bairro, tipoColeta, coleta.dia);

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notificationId,
          channelKey: 'coleta_notification_channel',
          title: 'Lembrete de Coleta de Lixo',
          body: 'A coleta $tipoColeta no bairro $bairro será amanhã às ${coleta.horario}.',
          notificationLayout: NotificationLayout.Default,
        ),
        schedule: NotificationCalendar(
          weekday: diaSemanaNotificacao,
          hour: hora,
          minute: minuto,
          second: 0,
          repeats: true,
          allowWhileIdle: true,
        ),
      );
      debugPrint("Notificação agendada para $bairro ($tipoColeta) - ID: $notificationId");
    } catch (e) {
      debugPrint("Erro ao agendar notificação: $e");
    }
  }

  Future<void> cancelarNotificacoesBairro(Bairro bairro) async {
    for (var tipoColeta in bairro.coletas.keys) {
      for (var coleta in bairro.coletas[tipoColeta]!) {
        int notificationId = _gerarIdUnico(bairro.nome, tipoColeta, coleta.dia);
        AwesomeNotifications().cancel(notificationId);
      }
    }
    debugPrint("Notificações para o bairro ${bairro.nome} canceladas.");
  }

  int _gerarIdUnico(String bairro, String tipo, String dia) {
    return (bairro.hashCode ^ tipo.hashCode ^ dia.hashCode) & 0x7FFFFFFF;
  }

  int _converterDiaParaNumero(String dia) {
    // Domingo é 7 no awesome_notifications
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