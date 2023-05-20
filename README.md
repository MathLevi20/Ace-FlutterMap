# Flutter Map

Descrição do projeto:

O projeto consiste em um aplicativo Flutter que oferece funcionalidade de login e registro para os usuários, juntamente com a integração do Google Maps para exibir mapas e locais relevantes.

## Recursos e Tecnologias Utilizadas

- Flutter: Um framework de desenvolvimento de aplicativos multiplataforma.
- Google Maps API: Utilizado para exibir mapas e dados relacionados.
- MySQL: Utilizado como banco de dados para armazenar informações de usuário.


## Estrutura de Pastas

projeto
├── lib/
│ ├── database/
│ ├── controller/
│ ├── models/
│ ├── view/
│ └── main.dart
├── assets/
│    └── images/
├── pubspec.yaml
└── README.md


## Fluxo de Funcionalidades

- Tela de login: Permite que os usuários entrem com suas credenciais (e-mail/senha).
- Tela de registro: Permite que novos usuários criem uma conta fornecendo suas informações (nome, e-mail, senha).
- Tela do mapa: Exibe um mapa usando a API do Google Maps, com marcadores e informações relevantes baseadas nos dados armazenados no MySQL.
- Integração com o MySQL: O aplicativo se conecta ao banco de dados MySQL para realizar operações de registro e armazenar dados de localização relacionados ao Google Maps.

## Configuração e Dependências

- Configure as chaves de Google Maps para autenticação de usuários e acesso ao serviço de mapas.
- Utilize o pacote `google_maps_flutter` para integrar o Google Maps no aplicativo Flutter.
- Utilize o pacote `http` para fazer solicitações HTTP ao servidor MySQL para realizar operações de registro e obter dados de localização.

## Instruções de Instalação e Execução

1. Clone o repositório do projeto para a sua máquina local.
2. Certifique-se de ter o Flutter SDK instalado.
3. Execute `flutter pub get` para obter todas as dependências do projeto.
4. Execute `flutter run` para iniciar o aplicativo no emulador ou dispositivo conectado.

## Contribuição

Contribuições são bem-vindas! Para contribuir com o projeto, siga as etapas abaixo:

1. Faça um fork do repositório.
2. Crie um branch com sua feature: `git checkout -b minha-feature`.
3. Faça o commit das suas alterações: `git commit -m 'Minha feature'`.
4. Faça o push para o branch: `git push origin minha-feature`.
5. Abra um Pull Request.

## Licença

MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

