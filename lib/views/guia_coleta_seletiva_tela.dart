// lib/telas/guia_coleta_seletiva_tela.dart
import 'package:flutter/material.dart';

class GuiaColetaSeletivaTela extends StatelessWidget {
  const GuiaColetaSeletivaTela({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guia de Coleta'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aprenda a separar seu lixo',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Separar o lixo corretamente é fundamental para o meio ambiente e para a eficiência da reciclagem. Veja abaixo como classificar os resíduos em sua casa.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),

            // Card de Entulho e Bens Inservíveis
            _buildInfoCard(
              context: context,
              title: 'Entulho e Bens Inservíveis',
              icon: Icons.construction_rounded,
              // --- COR ALTERADA AQUI ---
              color: Colors.green.shade800, // Verde Escuro
              description: 'Coleta gratuita para pequenos volumes.',
              oQueDescartar: [
                'Pequenas quantidades de entulho (até 1m³).',
                'Móveis velhos (sofás, armários, etc).',
                'Eletrodomésticos (geladeiras, fogões).',
                'Pneus (máximo de 4 por residência).',
                'Galhos e troncos de árvores podados.',
              ],
              oQueNaoDescartar: [
                'Grandes volumes de entulho de construção.',
                'Lixo industrial ou de serviços de saúde.',
                'Animais mortos.',
                'Lixo orgânico ou reciclável misturado.',
              ],
              // O botão de agendamento foi removido daqui
            ),
            const SizedBox(height: 16),
            
            // Card para Lixo Reciclável
            _buildInfoCard(
              context: context,
              title: 'Reciclável',
              icon: Icons.recycling,
              color: const Color(0xFF007BFF), // Azul
              description: 'Materiais que podem ser transformados em novos produtos.',
              oQueDescartar: [
                'Papéis: Jornais, revistas, caixas de papelão, folhas de caderno.',
                'Plásticos: Garrafas PET, potes de alimentos, embalagens de limpeza, sacolas.',
                'Metais: Latinhas de alumínio e aço, tampas de metal, clipes.',
                'Vidros: Garrafas de bebidas, potes de conserva, frascos de perfume (sem tampa e limpos).',
              ],
              oQueNaoDescartar: [
                'Papel carbono, fitas adesivas, fotografias, papéis sujos (gordurosos).',
                'Embalagens metalizadas (salgadinhos), esponjas de aço, pilhas e baterias.',
                'Espelhos, lâmpadas, cerâmicas, porcelanas, vidros temperados (box, pratos).',
              ],
            ),
            const SizedBox(height: 16),
            
            // Card para Lixo Orgânico
            _buildInfoCard(
              context: context,
              title: 'Orgânico',
              icon: Icons.eco,
              color: const Color(0xFF8B4513), // Marrom
              description: 'Resíduos de origem vegetal ou animal que podem ser usados para compostagem.',
              oQueDescartar: [
                'Restos de frutas, verduras e legumes.',
                'Cascas de ovos.',
                'Borra de café e sachês de chá.',
                'Restos de alimentos (sem excesso de gordura).',
                'Galhos finos e folhas secas de jardim.',
              ],
              oQueNaoDescartar: [
                'Carnes e ossos em grande quantidade.',
                'Gorduras e óleos.',
                'Feijão e arroz cozidos (em excesso, podem atrair vetores).',
                'Excrementos de animais.',
              ],
            ),
            const SizedBox(height: 16),

            // Card para Rejeito
            _buildInfoCard(
              context: context,
              title: 'Rejeito',
              icon: Icons.delete_forever,
              color: Colors.grey.shade700, // Cinza escuro
              description: 'Tudo o que não pode ser reciclado nem compostado e vai para o aterro sanitário.',
              oQueDescartar: [
                'Lixo de banheiro: Papel higiênico, absorventes, fraldas descartáveis, cotonetes.',
                'Etiquetas adesivas e fitas.',
                'Fotografias e papéis metalizados.',
                'Esponjas de limpeza e palhas de aço.',
                'Embalagens engorduradas (ex: caixa de pizza com gordura).',
              ],
              oQueNaoDescartar: [
                'Materiais recicláveis limpos.',
                'Resíduos orgânicos.',
                'Pilhas, baterias, lâmpadas e eletrônicos (descartar em Ecopontos).',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required String description,
    required List<String> oQueDescartar,
    required List<String> oQueNaoDescartar,
    Widget? customActionWidget,
  }) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Container(
            color: color,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.9)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ExpansionTile(
            title: const Text('O que descartar', style: TextStyle(fontWeight: FontWeight.bold)),
            children: oQueDescartar.map((item) => ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              leading: const Icon(Icons.check_circle_outline, color: Colors.green),
              title: Text(item),
            )).toList(),
          ),
          ExpansionTile(
            title: const Text('O que NÃO descartar', style: TextStyle(fontWeight: FontWeight.bold)),
            children: oQueNaoDescartar.map((item) => ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              leading: const Icon(Icons.cancel_outlined, color: Colors.red),
              title: Text(item),
            )).toList(),
          ),
          if (customActionWidget != null) customActionWidget,
        ],
      ),
    );
  }
}