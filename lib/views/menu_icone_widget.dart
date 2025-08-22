// lib/widgets/menu_icone_widget.dart
import 'package:flutter/material.dart';

class MenuIconeWidget extends StatelessWidget {
  final IconData icone;
  final String texto;
  final VoidCallback? aoTocar;

  const MenuIconeWidget({
    super.key,
    required this.icone,
    required this.texto,
    this.aoTocar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2.0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: aoTocar,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icone, size: 40, color: theme.primaryColor),
              const SizedBox(height: 8),
              // Garante que a área do texto tenha uma altura consistente
              SizedBox(
                height: 32, 
                child: Center(
                  // --- NOVA LÓGICA APLICADA AQUI ---
                  // O FittedBox irá encolher o texto se ele for muito grande
                  // para o espaço disponível, mantendo-o em uma única linha.
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      texto,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}