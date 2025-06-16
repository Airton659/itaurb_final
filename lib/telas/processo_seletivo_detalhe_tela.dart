import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:itaurb_transparente/models/processo_seletivo_model.dart';

class ProcessoSeletivoDetalheTela extends StatelessWidget {
  final ProcessoSeletivo processo;
  const ProcessoSeletivoDetalheTela({super.key, required this.processo});

  @override
  Widget build(BuildContext context) {
    final publicacoesOrdenadas = List.of(processo.publicacoes);
    final formatadorDeData = DateFormat('dd/MM/yyyy HH:mm:ss');
    publicacoesOrdenadas.sort((a, b) {
      try {
        return formatadorDeData.parse(b.dtPublicacao).compareTo(formatadorDeData.parse(a.dtPublicacao));
      } catch (e) { return 0; }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Processo ${processo.numProcesso}/${processo.numExercicio}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(processo.descNome, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Chip(label: Text(processo.descSituacao)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Histórico de Publicações', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).primaryColor)),
                  const Divider(),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: publicacoesOrdenadas.length,
                    itemBuilder: (context, index) {
                      final publicacao = publicacoesOrdenadas[index];
                      return ListTile(
                        leading: const Icon(Icons.article_outlined),
                        title: Text(publicacao.descPublicacao),
                        subtitle: Text('${publicacao.descTipoPublicacao} - ${publicacao.dtPublicacao.split(' ')[0]}'),
                      );
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}