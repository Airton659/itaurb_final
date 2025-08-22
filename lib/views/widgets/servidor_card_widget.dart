import 'package:flutter/material.dart';
import 'package:itaurb_transparente/utils/formatters.dart';
import '../models/servidor_model.dart';

class ServidorCardWidget extends StatelessWidget {
  final Servidor servidor;
  final VoidCallback? aoTocar;

  const ServidorCardWidget({super.key, required this.servidor, this.aoTocar});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        onTap: aoTocar,
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
          child: Icon(Icons.person_outline, color: theme.primaryColor),
        ),
        title: Text(servidor.descServidor, style: theme.textTheme.titleMedium),
        subtitle: Text(servidor.descFuncao, style: theme.textTheme.bodySmall),
        trailing: Text(
          formatarMoeda(servidor.vlLiquido),
          style: TextStyle(fontWeight: FontWeight.bold, color: theme.primaryColor),
        ),
      ),
    );
  }
}
