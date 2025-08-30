# itaurb_transparente

Aplicativo **Flutter** que centraliza informações públicas e utilidades da Itaurb (transparência, serviços e comunicação com o cidadão). Este README documenta **código**, **arquitetura** e **funcionalidades**, conforme solicitado.

> Projeto identificado no `pubspec.yaml` como `itaurb_transparente`.

---

## 📦 Stack & Principais Pacotes

- **Flutter** (Material 3, Google Fonts)
- **Gerência de estado:** `provider`
- **HTTP / Integração:** `http`
- **Persistência local:** `shared_preferences`
- **Datas e formatação:** `intl`
- **Onboarding:** `introduction_screen`
- **Shimmers (loading):** `shimmer`
- **Notificações locais:** `awesome_notifications`
- **Outros:** `url_launcher`, `google_fonts`, `font_awesome_flutter`

Veja dependências no `pubspec.yaml`:
```yaml
name: itaurb_transparente
dependencies:
  flutter: { sdk: flutter }
  http: ^1.2.1
  intl: ^0.20.0
  url_launcher: ^6.2.6
  flutter_local_notifications: ^17.1.2
  timezone: ^0.9.4
  shared_preferences: ^2.2.3
  google_fonts: ^6.2.1
  shimmer: ^3.0.0
  introduction_screen: ^3.1.12
  provider: ^6.1.2
  font_awesome_flutter: ^10.7.0
  awesome_notifications: ^0.10.1
```

---

## 🧭 Arquitetura (Visão Geral)

Arquitetura **em camadas** simples com separação por responsabilidade:

```
lib/
├─ main.dart                 # Bootstrap, tema, rotas iniciais (Splash → Onboarding → Home)
├─ controllers/              # Providers (estado e preferências)
│  ├─ favorites_provider.dart
│  └─ theme_provider.dart
├─ models/                   # Modelos de domínio e serviços de dados
│  ├─ licitacao_model.dart
│  ├─ contrato_model.dart
│  ├─ legislacao_model.dart
│  ├─ servidor_model.dart
│  ├─ servidor_item_model.dart
│  ├─ processo_seletivo_model.dart
│  ├─ publicacao_model.dart
│  └─ data_cache_service.dart   # Cache em memória + sincronismo via HTTP
├─ services/
│  ├─ bairros_data.dart      # Agenda de coleta por bairro (dataset local)
│  ├─ notification_service.dart
│  └─ formatters.dart        # Funções utilitárias (formatação de valores/datas)
└─ views/                    # Telas e widgets visuais
   ├─ splash_screen.dart
   ├─ onboarding_tela.dart
   ├─ home_tela.dart
   ├─ pesquisa_global_tela.dart
   ├─ coleta_tela.dart
   ├─ guia_coleta_seletiva_tela.dart
   ├─ licitacoes_tela.dart / licitacao_card_widget.dart / licitacao_detalhe_tela.dart
   ├─ contratos_tela.dart / contrato_card_widget.dart / contrato_detalhe_tela.dart
   ├─ legislacoes_tela.dart / legislacao_card_widget.dart / legislacao_detalhe_tela.dart
   ├─ processos_seletivos_tela.dart / processo_seletivo_card.dart / processo_seletivo_detalhe_tela.dart
   ├─ servidores_tela.dart / servidor_card_widget.dart / servidor_detalhe_tela.dart
   ├─ contato_tela.dart
   ├─ sobre_tela.dart
   ├─ empty_state_widget.dart
   └─ loading_list_shimmer.dart
```

### Fluxo de inicialização
1. `main.dart` inicializa notificações e injeta `ThemeProvider` e `FavoritesProvider` via `MultiProvider`.
2. `AppInitializer` chama `DataCacheService.instance.initialize()` (carregamento de dados) e verifica `hasSeenOnboarding` em `SharedPreferences`.
3. Roteamento inicial: **Splash → Onboarding (primeiro uso) ou Home**.

### Camada de Dados
- **`DataCacheService`** realiza chamadas HTTP para APIs de **Dados Abertos/Transparência** (ex.: licitações por ano, contratos, legislações), **armazena em memória** e salva **timestamp da última sincronização** em `SharedPreferences`.
- **`bairros_data.dart`** provê a malha de **coleta seletiva** (orgânica/reciclável) por bairro — usado para exibir horários, favoritos e notificações.

### Estado & Preferências
- **`ThemeProvider`**: modo **Claro/Escuro/Sistema** (persistido).
- **`FavoritesProvider`**: bairros marcados como **favoritos** (persistidos).

### Notificações
- **`NotificationService`**: configura `awesome_notifications` e emite alertas locais (ex.: lembretes de coleta).

---

## ✅ Funcionalidades

- **Onboarding** com introdução às funcionalidades principais.
- **Tema claro/escuro** com persistência da escolha.
- **Tela inicial (Home)** com navegação por **cards/menus**.
- **Pesquisa Global** (busca geral em diferentes módulos).
- **Coleta Seletiva por Bairro**
  - Busca/seleção de **bairros** com horários de **orgânica** e **reciclável**.
  - Marcar **favoritos** (salvos localmente).
  - **Notificações locais** como lembrete (ex.: dia/hora da coleta).
- **Licitações**
  - Lista com informações: número, modalidade, objeto, status, data de publicação, **ano**, **unidade**, processo, **valor estimado**, prazos etc.
  - **Tela de detalhes** com informações completas.
- **Contratos**
  - Lista e detalhes com: número, processo, CNPJ/CPF, fornecedor, objeto, valor, datas (início/fim/assinatura), situação, vigência etc.
- **Legislações**
  - Lista e detalhes de atos normativos/leis com metadados essenciais.
- **Processos Seletivos**
  - Lista/cards e detalhamento (edital, cronograma, situação).
- **Servidores**
  - Lista e detalhe do servidor, com **itens do holerite** (proventos/descontos) quando aplicável.
- **Páginas institucionais:** **Sobre** e **Contato**.
- **Feedback de carregamento** com **shimmer** e estados **vazios** bem definidos.

> Observação: os **endpoints** são consumidos via `http` em `DataCacheService`. Para licitações, por exemplo, são feitas consultas por **ano atual e anterior**; ao final, o serviço grava o timestamp da sincronização (`last_sync_timestamp`) para exibir na UI.

---

## 🌐 Integrações & Dados

- **APIs de Dados Abertos / Portal da Transparência (municipal)**.
- Requisições via `http` com **parametrização por ano**, paginação e mapeamento para **models** (`Licitacao`, `Contrato`, `Legislacao` etc.).
- **Cache em memória** (listas carregadas na inicialização) + **persistência de preferências** (`SharedPreferences`).

> Caso algum endpoint exija chave ou configuração específica, inclua nos passos de execução (se aplicável). No pacote atual **não há `.env`** nem variáveis de ambiente sensíveis.

---

## 🧪 Testes

Há testes em `test/` e `test/integration_test/`, incluindo:
- `coleta_tela_build_test.dart`
- `favorites_provider_test.dart`
- `data_cache_service_test.dart`
- `app_test.dart` (integration)

> Execute com: `flutter test`

---

## 🚀 Como executar (Dev)

Pré-requisitos:
- Flutter SDK instalado (canal estável) e em PATH.
- Android Studio (SDK/Emulador) **ou** Xcode (iOS).

Passos:
```bash
# 1) Instalar dependências
flutter pub get

# 2) Rodar no dispositivo/emulador conectado
flutter run

# (opcional) Rodar no Chrome/web
flutter run -d chrome

# Testes
flutter test
```

### Build (Android APK)
```bash
flutter build apk --release
# APK em: build/app/outputs/flutter-apk/app-release.apk
```

---

## 🗂️ Organização do Código (Resumo por pasta)

- `lib/main.dart` → setup de tema, `MultiProvider`, inicialização de dados e roteamento inicial.
- `lib/controllers/` → providers de estado (`ThemeProvider`, `FavoritesProvider`).
- `lib/models/` → classes de domínio + `DataCacheService` para chamadas HTTP e cache.
- `lib/services/` → utilidades (notificações, formatações e dataset de bairros).
- `lib/views/` → telas e widgets para cada módulo (licitações, contratos, legislações, processos seletivos, servidores, coleta, onboarding, home, etc.).
- `assets/images/` → pasta declarada no `pubspec.yaml` (garanta os ativos conforme necessário).

---

## 🔒 Permissões (Android)

Se utilizar notificações, confirme permissões no `AndroidManifest.xml` conforme `awesome_notifications` (ex.: `POST_NOTIFICATIONS` para Android 13+).

---

## 🧭 Roadmap (sugestões futuras)

- Filtros avançados e paginação em todas as listagens.
- Sincronização sob demanda (“puxar para atualizar”) com indicador de última atualização.
- Camada de repositórios e cache offline estruturado (ex.: `sqflite`).
- Testes de unidade/instrumentados adicionais para serviços e views críticas.

---

## 👤 Autoria

- **Autor:** José Airton (Itaurb) — disciplina/projeto acadêmico.
- **Curso/Disciplina:** Projetos III
- **Professor:** Edson Wisses de Figueiredo

---

