import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:crypto/crypto.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool _obscurePassword = true;

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

  Future<void> _realizarLogin() async {
    final email = _emailController.text;
    final senha = _senhaController.text;

    // Calcular o hash da senha usando o algoritmo SHA-256
    String hashedPassword = hashPassword(senha);

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3010/api/login'),
        body: {'email': email, 'senha': hashedPassword},
      );

      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        final token = jsonResponse['token']
            as String; // Obtenha o token JWT do JSON de resposta

        // Salve o token JWT no localStorage
        html.window.localStorage['token'] = token;

        final message = jsonResponse['message'] as String;
        print('Login realizado com sucesso');
        _showSnackBarMessage(context, message, backgroundColor: Colors.green);
        // Entrar no sistema
        html.window.location.reload();
      } else {
        final errorMessage = jsonResponse['erro'] as String;
        print('Erro durante o login: $errorMessage');
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
          'Login',
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
                    obscureText: _obscurePassword,
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
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _realizarLogin();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                    ),
                    child: const Text(
                      'Entrar',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/cadastroUsuario');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 188, 118, 235),
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