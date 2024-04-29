import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  final _confirmSenhaController =
      TextEditingController(); // New controller for confirm password

  bool _obscurePassword = true; // To toggle password visibility

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _showSnackBarMessage(BuildContext context, String message,
      {Color backgroundColor = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  String hashPassword(String password) {
    // Cria um hash SHA-256 do password
    var bytes = utf8.encode(password); // Converte a senha para bytes
    var digest = sha256.convert(bytes); // Calcula o hash

    // Retorna o hash como uma string hexadecimal
    return digest.toString();
  }

  Future<void> _cadastrarUsuario() async {
    final nome = _nomeController.text;
    final email = _emailController.text;
    final senha = _senhaController.text;
    final confirmSenha = _confirmSenhaController.text;

    if (senha != confirmSenha) {
      _showSnackBarMessage(context, "As senhas não coincidem");
      return;
    }

    String hashedPassword = hashPassword(senha);

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3010/api/usuario'),
        body: {'nome': nome, 'email': email, 'senha': hashedPassword},
      );

      final jsonResponse = json.decode(response.body);

      // Verificar o status da resposta
      if (response.statusCode == 200) {
        final message = jsonResponse['message'] as String;
        print('Usuário cadastrado com sucesso');
        _showSnackBarMessage(context, message, backgroundColor: Colors.green);
      } else {
        final errorMessage = jsonResponse['erro'] as String;
        print('Erro ao cadastrar usuário: $errorMessage');
        _showSnackBarMessage(context, errorMessage,
            backgroundColor: Colors.red);
      }
    } catch (e) {
      print('Erro durante a solicitação: $e');
      _showSnackBarMessage(context, 'Erro durante a solicitação: $e',
          backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Cadastro de Usuário',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'data:image/jpeg;base64,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',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
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
                          prefixIcon: Icon(Icons.person),
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
                          prefixIcon: Icon(Icons.email),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira um email';
                          }
                          final emailRegExp =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegExp.hasMatch(value)) {
                            return 'Por favor, insira um email válido';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        controller: _senhaController,
                        obscureText: _obscurePassword, // Toggle password visibility
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira uma senha';
                          }
                          // Additional password validation can be added here
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        controller: _confirmSenhaController,
                        obscureText: _obscurePassword, // Toggle password visibility
                        decoration: InputDecoration(
                          labelText: 'Confirmar Senha',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, confirme a senha';
                          }
                          // Additional password validation can be added here
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
                          backgroundColor: Colors.deepPurple,
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
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CadastroUsuarioScreen(),
  ));
}
