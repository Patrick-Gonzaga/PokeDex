# Pokédex Flutter 🎯

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![REST API](https://img.shields.io/badge/REST_API-FF6B6B?style=for-the-badge)
![Offline Cache](https://img.shields.io/badge/Offline_Cache-4ECDC4?style=for-the-badge)

Uma aplicação Flutter completa da Pokédex com cache offline, carregamento inteligente e interface
moderna.

<img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/25.png" width="200" />

*Uma Pokédex moderna e eficiente construída com Flutter*

</div>

## ✨ Características

- **📱 Interface Moderna** - Design elegante com tema escuro e acentos verdes
- **⚡ Cache Inteligente** - Carrega dados offline após primeira execução
- **🔄 Carregamento em Lotes** - Processa Pokémon em lotes de 50 para melhor performance
- **🔍 Busca Integrada** - Campo de busca para filtrar Pokémon
- **📊 Progresso em Tempo Real** - Visualização do progresso do carregamento
- **🎨 Imagens de Alta Qualidade** - Sprites oficiais da Pokémon Home
- **🚀 Performance Otimizada** - FutureBuilder e carregamento assíncrono
- **🛡️ Tratamento de Erros** - Lida com requisições 404 e falhas de rede


## 🛠️ Tecnologias

- **Flutter** - Framework UI
- **Dart** - Linguagem de programação
- **HTTP** - Requisições à API
- **Path Provider** - Armazenamento local
- **Transparent Image** - Placeholders elegantes
- **PokéAPI** - Fonte de dados

## 📦 Instalação

```bash
# Clone o repositório
git clone https://github.com/seu-usuario/pokedex-flutter.git

# Entre no diretório
cd pokedex-flutter

# Instale as dependências
flutter pub get

# Execute o app
flutter run
```

## 🎯 Como Funciona
### Primeira Execução
🔄 Faz requisição para obter contagem total de Pokémon

📦 Carrega dados em lotes de 50 Pokémon

💾 Salva cache completo localmente

⏱️ Pode demorar 1-2 minutos

### Execuções Seguintes
📁 Carrega instantaneamente do cache local

🚀 0 requisições à API

⚡ Experiência ultrarrápida

### Recarregar Dados
Use o botão 🔄 no AppBar para forçar recarregamento

Apaga cache e baixa dados atualizados

## 🏗️ Estrutura do Projeto
text
lib/
├── main.dart # Arquivo principal
├── home.dart # Tela principal da Pokédex
└── widgets/ # Componentes reutilizáveis

assets/
├── images/ # Assets locais
└── icons/ # Ícones do app
## 🔧 Funcionalidades Principais
### Cache Inteligente
#### dart
Future<List<Map<String, dynamic>>> _getInfos() async {
// Verifica se cache existe e está completo
// Carrega apenas Pokémon faltantes
// Atualiza cache automaticamente
}
### Grid Responsivo
dart
GridView.builder(
gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
crossAxisCount: 3, // Adaptável a diferentes telas
),
// ...
)
### Tratamento de Erros
dart
imageErrorBuilder: (context, error, stackTrace) {
return Icon(Icons.error); // Fallback elegante
}
## 🎨 Customização
### Cores do Tema
dart
Color(0xFF171F25) // Fundo escuro
Color(0xFFC3FF68) // Verde Pokémon

## 👨‍💻 Autor
Feito com ❤️ por Patrick da Silva Gonzaga

## 🌟 Agradecimentos
PokéAPI pela incrível API

Flutter pelo framework fantástico

Comunidade Pokémon pelos recursos visuais

<div align="center">
⭐️ Não esqueça de dar uma estrela se gostou do projeto!

</div> ```
