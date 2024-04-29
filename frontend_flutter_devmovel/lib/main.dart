import 'dart:async';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'cadastro_usuario.dart' as usuario;
import 'cadastro_atividade.dart' as atividade;
import 'cadastro_usuario_atividade.dart' as usuario_atividade;
import 'lista_usuario.dart' as lista_usuario;
import 'lista_atividade.dart' as lista_atividade;
import 'lista_usuario_atividade.dart' as lista_usuario_atividade;
import 'login.dart' as login;

String? getTokenFromLocalStorage() {
  return html.window.localStorage['token'];
}

Future<bool> verificarTokenValido() async {
  String? token = getTokenFromLocalStorage();

  if (token == null || token.isEmpty) {
    return false;
  }

  try {
    // ignore: unused_local_variable
    final jwt = JwtDecoder.decode(token);
    return true; // Se a análise for bem-sucedida, o token é válido
  } catch (e) {
    // Se ocorrer uma exceção ao analisar o token, ele não é válido
    return false;
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: verificarTokenValido(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Exibir um indicador de carregamento enquanto verifica o token
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else {
          // Verificar o estado do token e construir a interface do usuário de acordo
          return MaterialApp(
            title: 'Projeto DevMovel',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 0, 242)),
              useMaterial3: true,
            ),
            home: snapshot.data == true
                ? const MyHomePage()
                : const login.LoginScreen(),
            onGenerateRoute: (settings) {
              // Disable route generation if the token is not valid
              if (snapshot.data != true) {
                return MaterialPageRoute<void>(
                  builder: (context) => const login.LoginScreen(),
                );
              }
              // Enable route generation if the token is valid
              return null;
            },
            routes: {
              '/cadastroUsuario': (context) =>
                  const usuario.CadastroUsuarioScreen(),
              if (snapshot.data == true) ...{
                '/cadastroAtividade': (context) =>
                    const atividade.CadastroAtividadeScreen(),
                '/cadastroUsuarioAtividade': (context) =>
                    const usuario_atividade.CadastroUsuarioAtividadeScreen(),
                '/listaUsuario': (context) =>
                    const lista_usuario.ListaUsuarioScreen(),
                '/listaAtividade': (context) =>
                    const lista_atividade.ListaAtividadeScreen(),
                '/listaUsuarioAtividade': (context) =>
                    const lista_usuario_atividade.ListaUsuarioAtividadeScreen(),
              },
            },
          );
        }
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key});

  // Function to handle logout
  void _logout(BuildContext context) {
    html.window.localStorage.remove('token'); // Remove token from local storage
    html.window.location.reload(); // Navigate to login screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Menu',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: 100,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Card(
                color: Colors.orangeAccent,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: const Icon(Icons.person_add),
                  title: const Text(
                    'Cadastrar Usuário',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/cadastroUsuario');
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                color: Colors.greenAccent,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: const Icon(Icons.add_circle),
                  title: const Text(
                    'Cadastrar Atividade',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/cadastroAtividade');
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                color: Colors.blueAccent,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: const Icon(Icons.group_add),
                  title: const Text(
                    'Cadastrar Usuário Atividade',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                        context, '/cadastroUsuarioAtividade');
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                color: Colors.purpleAccent,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text(
                    'Lista de Usuários',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/listaUsuario');
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                color: Colors.yellowAccent,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text(
                    'Lista de Atividades',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/listaAtividade');
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                color: Colors.redAccent,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text(
                    'Lista de Usuários Atividades',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                        context, '/listaUsuarioAtividade');
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                color: Colors.grey,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text(
                    'Sair',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () => _logout(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
