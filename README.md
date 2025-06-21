# Aplicativo in8store

Este é um aplicativo completo de e-commerce desenvolvido em **Flutter**, cobrindo todo o fluxo de compra — desde a **autenticação do usuário** até a **finalização do pedido**. O projeto tem como foco boas práticas de arquitetura, usabilidade e escalabilidade alem de mostrar as habilidades tecnicas para o teste.

---

## Funcionalidades

- **Autenticação de Usuário**  
  Cadastro e login com persistência de token via armazenamento seguro.

- **Listagem de Produtos**  
  Exibição em grade com **rolagem infinita** (`infinite scrolling`).

- **Carrinho de Compras**
  - Adição e remoção de produtos.
  - Atualização de quantidades (incremento/decremento).
  - Limpeza total do carrinho.

- **Checkout**
  - Formulário para preenchimento de endereço e informações de contato.
  - Cálculo dinâmico do valor total.
  - Criação do pedido via API.

- **Confirmação de Pedido**  
  Exibição de tela de sucesso com o **ID da ordem**.

---

## Arquitetura e Tecnologias

A estrutura segue o padrão de **Arquitetura em Camadas**, promovendo separação de responsabilidades e facilitando testes e manutenção.

- **Framework**: Flutter  
- **Linguagem**: Dart  
- **Gerenciamento de Estado**: [`provider`](https://pub.dev/packages/provider) com `ChangeNotifier`, `ChangeNotifierProxyProvider`, `Consumer`  
- **HTTP Client**: [`http`](https://pub.dev/packages/http)  
- **Armazenamento Seguro**: [`flutter_secure_storage`](https://pub.dev/packages/flutter_secure_storage)

### Estrutura de Pastas

```
lib/
└── app/
    ├── data/
    │   ├── models/
    │   └── services/
    └── presentation/
        ├── providers/
        ├── screens/
        └── widgets/
```

---

## Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- ✅ Flutter SDK (versão 3.x ou superior)  
- ✅ Editor como VS Code ou Android Studio com plugins do Flutter/Dart  
- ✅ Backend rodando e acessível localmente (ou remotamente)

---

## Configuração do Projeto

### 1. Clone o Repositório

```bash
git clone <url-do-repositorio>
cd <nome-da-pasta>
```

### 2. Instale as Dependências

```bash
flutter pub get
```

### 3. Configure a URL da API (⚠️ Etapa Crucial)

Atualize a variável `_baseUrl` nos arquivos de serviço para apontar para sua API:

#### Arquivos:
- `lib/app/data/services/api_service.dart`
- `lib/app/data/services/auth_service.dart`
- `lib/app/data/services/cart_service.dart`
- `lib/app/data/services/order_service.dart`

#### Exemplo:

```dart
final String _baseUrl = "http://SUA_URL_AQUI/api/v1";
```

---

## Executando o Aplicativo

Após a configuração, execute:

```bash
flutter run
```

O app será compilado e executado no dispositivo/emulador conectado.

---

## API Endpoints Utilizados

| Método | Rota                             | Descrição                          |
|--------|----------------------------------|------------------------------------|
| POST   | `/api/v1/accounts/create`        | Criação de nova conta de usuário   |
| POST   | `/api/v1/auth/login`             | Login e retorno de token           |
| GET    | `/api/v1/products`               | Listagem de produtos (paginada)    |
| POST   | `/api/v1/cart/add`               | Adiciona produto ao carrinho       |
| GET    | `/api/v1/cart/list`              | Lista os itens no carrinho         |
| PUT    | `/api/v1/cart/update-quantity`   | Atualiza a quantidade de um item   |
| DELETE | `/api/v1/cart/delete-product`    | Remove um item do carrinho         |
| POST   | `/api/v1/cart/clear`             | Limpa todos os itens do carrinho   |
| POST   | `/api/v1/orders/create`          | Cria um novo pedido                |