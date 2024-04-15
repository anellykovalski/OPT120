import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'cadastro_usuario.dart' as usuario;
import 'cadastro_atividade.dart' as atividade;
import 'cadastro_usuario_atividade.dart' as usuario_atividade;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projeto DevMovel',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: MyHomePage(),
      routes: {
        '/cadastroUsuario': (context) => CadastroUsuarioScreen(),
        '/cadastroAtividade': (context) => atividade.CadastroAtividadeScreen(),
        '/cadastroUsuarioAtividade': (context) => usuario_atividade.CadastroUsuarioAtividadeScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Menu',
            style: TextStyle(fontSize: 24),
          ),
          toolbarHeight: 100,
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.pink,
                ),
                child: Center(
                  child: Text(
                    'Opções',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person_add),
                title: const Text('Cadastrar Usuário'),
                onTap: () {
                  Navigator.pushNamed(context, '/cadastroUsuario');
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_circle),
                title: const Text('Cadastrar Atividade'),
                onTap: () {
                  Navigator.pushNamed(context, '/cadastroAtividade');
                },
              ),
              ListTile(
                leading: const Icon(Icons.group_add),
                title: const Text('Cadastrar Usuário Atividade'),
                onTap: () {
                  Navigator.pushNamed(context, '/cadastroUsuarioAtividade');
                },
              ),
            ],
          ),
        ),
        body: const Center(
          child: Text(
            'Conteúdo da página!!!',
            style: TextStyle(fontSize: 24),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _toggleTheme,
          child: const Icon(Icons.brightness_4),
          backgroundColor: Colors.pink,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }
}

class CadastroUsuarioScreen extends StatefulWidget {
  const CadastroUsuarioScreen({Key? key}) : super(key: key);

  @override
  _CadastroUsuarioScreenState createState() => _CadastroUsuarioScreenState();
}

class _CadastroUsuarioScreenState extends State<CadastroUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  Future<void> _cadastrarUsuario() async {
    final nome = _nomeController.text;
    final email = _emailController.text;
    final senha = _senhaController.text;

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3010/api/usuario'),
        body: {'nome': nome, 'email': email, 'senha': senha},
      );

      // Verificar o status da resposta
      if (response.statusCode == 200) {
        // Sucesso
        print('Usuário cadastrado com sucesso');
      } else {
        // Erro
        print('Erro ao cadastrar usuário: ${response.body}');
      }
    } catch (e) {
      // Tratamento de exceções
      print('Erro durante a solicitação: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text(
          'Cadastro de Usuário',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.2,
          horizontal: screenWidth * 0.1,
        ),
        child: Center(
          child: SizedBox(
            width: screenWidth * 0.8,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person, color: Colors.pink),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um nome';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email, color: Colors.pink),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um email';
                      }
                      final emailRegExp =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegExp.hasMatch(value!)) {
                        return 'Por favor, insira um email válido';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  TextFormField(
                    controller: _senhaController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock, color: Colors.pink),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma senha';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _cadastrarUsuario();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                    ),
                    child: const Text(
                      'Cadastrar',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
