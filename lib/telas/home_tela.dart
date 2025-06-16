// lib/telas/home_tela.dart
import 'package:flutter/material.dart';
import 'package:itaurb_transparente/telas/coleta_tela.dart';
import 'package:itaurb_transparente/telas/contato_tela.dart';
import 'package:itaurb_transparente/telas/contratos_tela.dart';
import 'package:itaurb_transparente/telas/legislacoes_tela.dart';
import 'package:itaurb_transparente/telas/licitacoes_tela.dart';
import 'package:itaurb_transparente/telas/pesquisa_global_tela.dart'; // Importe a nova tela
import 'package:itaurb_transparente/telas/processos_seletivos_tela.dart';
import 'package:itaurb_transparente/telas/servidores_tela.dart';
import 'package:itaurb_transparente/telas/sobre_tela.dart';
import '../widgets/menu_icone_widget.dart';

// Convertemos para StatefulWidget para gerenciar o controller da pesquisa
class HomeTela extends StatefulWidget {
  const HomeTela({super.key});

  @override
  State<HomeTela> createState() => _HomeTelaState();
}

class _HomeTelaState extends State<HomeTela> {
  // Controller para capturar o texto da pesquisa
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  void _onSearchSubmitted(String query) {
    if (query.trim().isNotEmpty) {
      // Navega para a tela de resultados da pesquisa
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PesquisaGlobalTela(query: query),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo_itaurb.png',
                      width: 80,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      // --- CAMPO DE PESQUISA AGORA FUNCIONAL ---
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Pesquisar em Licitações...',
                          prefixIcon: const Icon(Icons.search),
                          border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surfaceVariant,
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        ),
                        // Ação ao pressionar 'enter' ou o botão de busca no teclado
                        onSubmitted: _onSearchSubmitted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset(
                    'assets/images/banner_itaurb.jpg',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 24),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    MenuIconeWidget(
                      icone: Icons.gavel,
                      texto: 'Licitações',
                      aoTocar: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LicitacoesPage())),
                    ),
                    MenuIconeWidget(
                      icone: Icons.recycling,
                      texto: 'Coleta',
                      aoTocar: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ColetaTela())),
                    ),
                    MenuIconeWidget(
                      icone: Icons.people_outline,
                      texto: 'Servidores',
                      aoTocar: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ServidoresTela())),
                    ),
                    MenuIconeWidget(
                      icone: Icons.description,
                      texto: 'Contratos',
                      aoTocar: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ContratosTela())),
                    ),
                    MenuIconeWidget(
                      icone: Icons.work_outline,
                      texto: 'Concursos',
                      aoTocar: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ProcessosSeletivosTela())),
                    ),
                    MenuIconeWidget(
                      icone: Icons.balance_outlined,
                      texto: 'Legislação',
                      aoTocar: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LegislacoesTela())),
                    ),
                    MenuIconeWidget(
                      icone: Icons.contact_phone,
                      texto: 'Contato',
                      aoTocar: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ContatoTela())),
                    ),
                    MenuIconeWidget(
                      icone: Icons.info_outline,
                      texto: 'Sobre',
                      aoTocar: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SobreTela())),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}