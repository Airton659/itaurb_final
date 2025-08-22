// lib/telas/contato_tela.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContatoTela extends StatefulWidget {
  const ContatoTela({super.key});

  @override
  State<ContatoTela> createState() => _ContatoTelaState();
}

class _ContatoTelaState extends State<ContatoTela> {
  final _formKey = GlobalKey<FormState>();
  // Todos os controllers, incluindo os de endereço
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();

  String _selectedService = '';
  final String _whatsappNumber = '553138334000';

  final List<Map<String, String>> _serviceTypes = [
    {'label': 'Selecione o tipo de serviço', 'value': ''},
    {'label': 'Sugestão', 'value': 'sugestao'},
    {'label': 'Lixo não recolhido', 'value': 'lixo_nao_recolhido'},
    {'label': 'Animal Morto', 'value': 'animal_morto'},
    {'label': 'Dúvida', 'value': 'duvida'},
  ];

  // Função para mostrar o Pop-up de Aviso
  Future<void> _mostrarAvisoWhatsApp() async {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Continuar no WhatsApp'),
          content: const Text(
              'Você será redirecionado para o WhatsApp com a sua mensagem.\n\nSe necessário, por favor, anexe fotos diretamente na conversa.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FilledButton(
              child: const Text('Continuar'),
              onPressed: () {
                Navigator.of(context).pop();
                _enviarTextoParaWhatsApp();
              },
            ),
          ],
        );
      },
    );
  }

  // Lógica de envio do texto para o WhatsApp
  Future<void> _enviarTextoParaWhatsApp() async {
    final message = '''
🔔 *NOVA SOLICITAÇÃO DE ATENDIMENTO*

👤 *Nome:* ${_nameController.text}
📱 *Telefone:* ${_phoneController.text}
${_emailController.text.isNotEmpty ? '📧 *E-mail:* ${_emailController.text}\n' : ''}
🔧 *Tipo de Serviço:* ${_serviceTypes.firstWhere((t) => t['value'] == _selectedService)['label']}

📍 *Endereço:*
Bairro: ${_bairroController.text}
${_ruaController.text.isNotEmpty ? 'Rua: ${_ruaController.text}\n' : ''}
${_numeroController.text.isNotEmpty ? 'Número: ${_numeroController.text}\n' : ''}

📝 *Mensagem:*
${_messageController.text}
    '''
        .trim();

    final encodedMessage = Uri.encodeComponent(message);
    final whatsappUrl =
        Uri.parse('whatsapp://send?phone=$_whatsappNumber&text=$encodedMessage');

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Erro ao abrir o WhatsApp. Certifique-se de que a aplicação está instalada.')));
      }
    }
  }

  // Função para abrir links (telefone, email, mapa)
  Future<void> _launchUrlHelper(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Não foi possível abrir o link: $url')));
      }
    }
  }

  // Widget auxiliar para os itens de contato
  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String content,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle),
              child: Icon(icon, color: Theme.of(context).primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(content,
                      style: const TextStyle(
                          fontSize: 14, color: Colors.black54)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fale com a Itaurb'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Envie a sua Solicitação',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                  'Preencha os dados abaixo e envie a sua mensagem diretamente para o nosso WhatsApp.',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),

              // Campos do Formulário
              TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                      labelText: 'Nome *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person)),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Campo obrigatório' : null),
              const SizedBox(height: 16),
              TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                      labelText: 'E-mail (Opcional)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email)),
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                      labelText: 'Telemóvel *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone)),
                  keyboardType: TextInputType.phone,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Campo obrigatório' : null),
              const SizedBox(height: 16),

              // --- SECÇÃO DE ENDEREÇO CORRIGIDA ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    // Cor alterada para se adaptar ao tema
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                    // Borda alterada para se adaptar ao tema
                    border: Border.all(
                        color:
                            Theme.of(context).colorScheme.outline.withOpacity(0.5))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(Icons.location_on, color: Colors.green.shade400),
                      const SizedBox(width: 8),
                      const Text('Endereço da Ocorrência',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold))
                    ]),
                    const SizedBox(height: 12),
                    TextFormField(
                        controller: _bairroController,
                        decoration: const InputDecoration(
                            labelText: 'Bairro *',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12)),
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Informe o bairro'
                            : null),
                    const SizedBox(height: 12),
                    TextFormField(
                        controller: _ruaController,
                        decoration: const InputDecoration(
                            labelText: 'Rua (Opcional)',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12))),
                    const SizedBox(height: 12),
                    TextFormField(
                        controller: _numeroController,
                        decoration: const InputDecoration(
                            labelText: 'Número (Opcional)',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12)),
                        keyboardType: TextInputType.number),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedService,
                decoration: const InputDecoration(
                    labelText: 'Tipo de Serviço *',
                    border: OutlineInputBorder()),
                items: _serviceTypes
                    .map((s) => DropdownMenuItem<String>(
                        value: s['value'], child: Text(s['label']!)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedService = v!),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Selecione um serviço' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                      labelText: 'Mensagem *',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true),
                  maxLines: 5,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Digite a sua mensagem' : null),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                icon: const Icon(Icons.send_outlined),
                onPressed: _mostrarAvisoWhatsApp,
                label: const Text('Enviar via WhatsApp'),
              ),

              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),

              // --- SECÇÃO DE OUTROS CONTATOS ---
              Card(
                elevation: 0,
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Outras formas de contacto:',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 16),
                    _buildContactItem(
                      icon: Icons.phone,
                      title: 'Telefone',
                      content: '(31) 3833-4010',
                      onTap: () => _launchUrlHelper('tel:3138334010'),
                    ),
                    const Divider(),
                    _buildContactItem(
                      icon: Icons.email_outlined,
                      title: 'E-mail',
                      content: 'itaurb.oficial@itaurb.com.br',
                      onTap: () => _launchUrlHelper(
                          'mailto:itaurb.oficial@itaurb.com.br'),
                    ),
                    const Divider(),
                    _buildContactItem(
                      icon: Icons.location_on,
                      title: 'Endereço',
                      content: 'Av. Carlos Drummond de Andrade, 50 - Centro',
                      onTap: () => _launchUrlHelper(
                          'geo:0,0?q=Av. Carlos Drummond de Andrade, 50 - Centro, Itabira - MG'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}