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
    // Usando as cores e fontes do tema global
    final theme = Theme.of(context);
    return Card(
      elevation: 2.0,
      clipBehavior: Clip.antiAlias, // Garante que o InkWell respeite as bordas arredondadas
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: aoTocar,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icone, size: 40, color: theme.primaryColor), // Usa a cor primária do tema
              const SizedBox(height: 8),
              Text(
                texto,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall, // Usa o estilo de texto do tema
              ),
            ],
          ),
        ),
      ),
    );
  }
}