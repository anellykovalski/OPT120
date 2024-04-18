import 'package:flutter/material.dart';
// ignore: unused_import
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
      home: const MyHomePage(),
     routes: {
  '/cadastroUsuario': (context) => usuario.CadastroUsuarioScreen(),
  '/cadastroAtividade': (context) => atividade.CadastroAtividadeScreen(),
  '/cadastroUsuarioAtividade': (context) => usuario_atividade.CadastroUsuarioAtividadeScreen(),
},

    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}

class CadastroUsuarioScreen extends StatelessWidget {
  const CadastroUsuarioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text(
          'Cadastro de Usuário',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: const Text(
          'Tela de Cadastro de Usuário',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
