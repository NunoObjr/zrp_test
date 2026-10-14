# Rick and Morty — Lista de Personagens

Aplicativo Flutter que consulta a [Rick and Morty API](https://rickandmortyapi.com/) para buscar um **episódio pelo número** e listar os **personagens que aparecem nele**. Os dados consultados ficam salvos em um banco local (SQLite), então episódios já pesquisados podem ser reabertos sem nova chamada de rede.

O projeto serve também como estudo de **Clean Architecture em Flutter**, com camadas bem separadas, tratamento funcional de erros e testes automatizados.

## Funcionalidades

- Busca de episódio por número
- Listagem dos personagens do episódio (com *shimmer* durante o carregamento)
- Cache local: episódio e personagens persistidos em SQLite
- Tratamento de erros sem exceções vazando para a UI

## Conceitos técnicos

**Clean Architecture em módulos.** O módulo `home` segue a divisão:

| Camada | Pasta | Responsabilidade |
| --- | --- | --- |
| Domain | `domain/` | Entidades, contrato do repositório e *use cases* (`LoadEpisodeUsecase`, `LoadCharactersUsecase`). Não depende de Flutter nem de pacotes de infraestrutura |
| Infra | `infra/` | Models de serialização, contratos de *datasource* (remoto/local) e a implementação do repositório |
| Data | `data/` | Implementações concretas: `Service` (Dio) e `LocalDatabase` (sqflite) |
| Presenter | `presenter/` | Páginas e `HomeController` (`ChangeNotifier`) |

**Either / Failure (`dartz`).** Os *use cases* retornam `Either<Failure, T>`: o erro é um valor tratado explicitamente em `fold`, em vez de `try/catch` espalhado pela UI.

**Estratégia de dados.** O repositório decide entre fonte remota e local; o `LocalDatabase` é um singleton com schema versionado (`onCreate`/migração) e aceita injeção de um banco em memória (`sqflite_common_ffi`) para testes.

**Injeção de dependências.** `get_it` registra as implementações em `lib/core/di/injection.dart`; as camadas superiores conhecem apenas as abstrações.

**Navegação.** `go_router`.

## Stack

Flutter · Dart · `dio` · `sqflite` / `sqflite_common_ffi` · `get_it` · `go_router` · `dartz` · `equatable` · `shimmer` · `mockito` · `build_runner`

## Estrutura

```
lib/
  core/
    di/                # service locator (get_it)
    error/             # Failure
  modules/home/
    domain/            # entities, repositories, usecases
    infra/             # datasource contracts, models, repository impl
    data/              # external (Dio) e local (sqflite)
    presenter/         # home e characters_list
test/                  # data, usecases e presenter (com mocks do mockito)
```

## Como executar

Pré-requisito: Flutter (versão em [`.fvmrc`](.fvmrc), se usar FVM).

```bash
flutter pub get
flutter run
```

## Testes

```bash
flutter test --coverage
```

A suíte cobre o serviço HTTP, o banco local, o repositório, os *use cases*, o `HomeController` e a página de personagens. Mocks são gerados com `build_runner`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## API utilizada

[rickandmortyapi.com](https://rickandmortyapi.com/) — pública e sem autenticação (endpoints `/episode` e `/character`).
