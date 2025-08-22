// lib/telas/home_tela.dart
import 'package:flutter/material.dart';
import 'package:itaurb_transparente/controllers/sync_controller.dart';
import 'package:itaurb_transparente/views/screens/coleta_tela.dart';
import 'package:itaurb_transparente/views/screens/contato_tela.dart';
import 'package:itaurb_transparente/views/screens/contratos_tela.dart';
import 'package:itaurb_transparente/views/screens/guia_coleta_seletiva_tela.dart';
import 'package:itaurb_transparente/views/screens/legislacoes_tela.dart';
import 'package:itaurb_transparente/views/screens/licitacoes_tela.dart';
import 'package:itaurb_transparente/views/screens/pesquisa_global_tela.dart';
import 'package:itaurb_transparente/views/screens/processos_seletivos_tela.dart';
import 'package:itaurb_transparente/views/screens/servidores_tela.dart';
import 'package:itaurb_transparente/views/screens/sobre_tela.dart';
import 'package:provider/provider.dart';
import '../views/widgets/menu_icone_widget.dart';

class HomeTela extends StatefulWidget {
  const HomeTela({super.key});

  @override
  State<HomeTela> createState() => _HomeTelaState();
}

class _HomeTelaState extends State<HomeTela> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String query) {
    if (query.trim().isNotEmpty) {
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Pesquisar...',
                        prefixIcon: const Icon(Icons.search),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceVariant,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                      onSubmitted: _onSearchSubmitted,
                    ),
                    // --- ESPAÇAMENTO REDUZIDO AQUI ---
                    const SizedBox(height: 20),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.asset(
                        'assets/images/banner_itaurb.jpg',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // --- ESPAÇAMENTO REDUZIDO AQUI ---
                    const SizedBox(height: 20),

                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: [
                        MenuIconeWidget(icone: Icons.gavel, texto: 'Licitações', aoTocar: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LicitacoesPage()))),
                        MenuIconeWidget(icone: Icons.recycling, texto: 'Coleta\nno bairro', aoTocar: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ColetaTela()))),
                        MenuIconeWidget(icone: Icons.people_outline, texto: 'Servidores', aoTocar: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ServidoresTela()))),
                        MenuIconeWidget(icone: Icons.description, texto: 'Contratos', aoTocar: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ContratosTela()))),
                        MenuIconeWidget(icone: Icons.work_outline, texto: 'Concursos', aoTocar: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProcessosSeletivosTela()))),
                        MenuIconeWidget(icone: Icons.balance_outlined, texto: 'Legislação', aoTocar: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LegislacoesTela()))),
                        MenuIconeWidget(icone: Icons.compost_rounded, texto: 'Guia', aoTocar: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GuiaColetaSeletivaTela()))),
                        MenuIconeWidget(icone: Icons.contact_phone, texto: 'Contato', aoTocar: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ContatoTela()))),
                        MenuIconeWidget(icone: Icons.info_outline, texto: 'Sobre', aoTocar: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SobreTela()))),
                      ],
                    ),
                    
                    // Adiciona um espaço no final para garantir que nada fique colado
                    const SizedBox(height: 16), 
                  ],
                ),
              ),
            ),
            
            // Rodapé Fixo
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 16.0), // Padding ajustado
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 60), // Altura máxima da logo
                child: FractionallySizedBox(
                  widthFactor: 0.6, // Fator de largura da logo
                  child: Image.asset(
                    'assets/images/logo_itaurb2.png',
                  ),
                ),
              ),
            ),

            Consumer<SyncController>(
              builder: (context, controller, child) {
                return controller.isSyncing
                  ? const Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2.0)),
                          SizedBox(width: 12),
                          Text("Atualizando dados..."),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Dados atualizados em: ${controller.lastSyncTime}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh, size: 20),
                            onPressed: () async {
                              await controller.forceSync();
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Dados atualizados com sucesso!'),
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                  ),
                                );
                              }
                            },
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}