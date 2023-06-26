import 'package:flutter/material.dart';
import 'package:maps/model/Pessoa.dart';
import 'package:uuid/uuid.dart';
import 'database.dart';

var uuid = const Uuid();

class ListUserPage extends StatefulWidget {
  const ListUserPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListUserPageState createState() => _ListUserPageState();
}

class _ListUserPageState extends State<ListUserPage> {
  Future<List<User>> minhaLista = getUserMySql();

  void removeItem(User contato) async {
    List<User> usersList = await minhaLista;
    usersList.remove(contato);

    setState(() {
      minhaLista = Future.value(usersList);
    });

    // Realize outras operações com a lista modificada, se necessário

    print(usersList); // Saída: Lista atualizada após remover o item
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
      ),
      body: FutureBuilder<List<User>>(
        future: minhaLista,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              ;
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final contato = snapshot.data![index];
                  return Card(
                      child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextButton(
                          child: Column(
                            children: [
                              Text(contato.name),
                              const SizedBox(height: 10),
                              Text(contato.email),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.red),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                    ),
                                    onPressed: () {
                                      delete(contato.id);
                                      removeItem(contato);
                                    },
                                    child: const Text('Apagar'),
                                  )
                                ],
                              )
                            ],
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(
                                  email: (contato.email),
                                  senha: (contato.password),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ));
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Erro ao carregar contatos: ${snapshot.error}'),
              );
            } else {
              return const Center(
                child: Text('Nenhum contato encontrado.'),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<Register> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  Future<void> _cadastrar() async {
    String password = _senhaController.text;
    String email = _emailController.text;
    String name = _nameController.text;
    //User novoContato = User(
    //id: DateTime.now().microsecondsSinceEpoch,
    //email: email,
    // senha: senha,
    //);

    //await insertContato(novoContato);
    await registerUser(name, email, password);

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Cadastro realizado!'),
        content: const Text('Seus dados foram salvos com sucesso.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Fechar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cadastro",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                'assets/images/user.png',
                width: 100,
                height: 150,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) => {value.isNotEmpty},
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
                onChanged: (value) => {value.isNotEmpty},
              ),
              const SizedBox(height: 1.0),
              TextField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Senha'),
                  onChanged: (value) => {value.isNotEmpty}),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _cadastrar,
                child: const Text('Fazer Cadastro'),
              ),
              ElevatedButton(
                child: const Text('Ver Usuarios'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ListUserPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.email,
    required this.senha,
  });

  final String? email;
  final String? senha;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey, Colors.white],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'Email: ${widget.email}!',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[900],
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Sua senha é:${widget.senha}!',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.blueGrey[900],
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
