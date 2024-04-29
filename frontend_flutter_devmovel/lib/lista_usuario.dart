import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Usuario {
  final int id;
  String nome;
  String email;

  Usuario({required this.id, required this.nome, required this.email});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['ID_USUARIO'],
      nome: json['NOME'],
      email: json['EMAIL'],
    );
  }

  void atualizarNome(String novoNome) {
    this.nome = novoNome;
  }

  void atualizarEmail(String novoEmail) {
    this.email = novoEmail;
  }
}

class ListaUsuarioScreen extends StatefulWidget {
  const ListaUsuarioScreen({Key? key}) : super(key: key);

  @override
  _ListaUsuarioScreenState createState() => _ListaUsuarioScreenState();
}

class _ListaUsuarioScreenState extends State<ListaUsuarioScreen> {
  late Future<List<Usuario>> _usuarios;
  late final Map<int, bool> _isEditing = {};

  @override
  void initState() {
    super.initState();
    _usuarios = _getUsuarios();
  }

  Future<List<Usuario>> _getUsuarios() async {
    final response =
        await http.get(Uri.parse('http://localhost:3010/api/usuario'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Usuario.fromJson(data)).toList();
    } else {
      throw Exception('Falha ao carregar os usuários');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Lista de Usuários',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Usuario>>(
        future: _usuarios,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final usuario = snapshot.data![index];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(usuario.nome),
                    subtitle: Text(usuario.email),
                    trailing: Wrap(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Adicione a lógica para editar o usuário aqui
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // Adicione a lógica para remover o usuário aqui
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erro: ${snapshot.error}'),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ListaUsuarioScreen(),
  ));
}
