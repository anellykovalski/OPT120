import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CadastroAtividadeScreen extends StatefulWidget {
  const CadastroAtividadeScreen({Key? key}) : super(key: key);

  @override
  _CadastroAtividadeScreenState createState() =>
      _CadastroAtividadeScreenState();
}

class _CadastroAtividadeScreenState extends State<CadastroAtividadeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _dataEntregaController = TextEditingController();
  bool _dataEntregaError = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Cadastro de Atividade',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple, Colors.deepPurple],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _tituloController,
                    style: TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      prefixIcon: Icon(Icons.title, color: Colors.white),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um título';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  TextFormField(
                    controller: _descricaoController,
                    style: TextStyle(color: Colors.white),
                    maxLines: null,
                    decoration: const InputDecoration(
                      labelText: 'Descrição da Atividade',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      prefixIcon: Icon(Icons.description, color: Colors.white),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma descrição';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  TextFormField(
                    controller: _dataEntregaController,
                    style: TextStyle(color: Colors.white),
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: ColorScheme.light().copyWith(
                                primary: Colors.deepPurple, // Header background color
                                onPrimary: Colors.white, // Header text color
                                onSurface: Colors.deepPurple, // Selected day color
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.deepPurple, // Button text color
                                ),
                              ),
                              dialogBackgroundColor: Colors.white, // Background color
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _dataEntregaController.text =
                              '${pickedDate.day.toString().padLeft(2, '0')}/'
                              '${pickedDate.month.toString().padLeft(2, '0')}/'
                              '${pickedDate.year.toString().substring(2)}';
                          _dataEntregaError = false;
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Data de Entrega',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      prefixIcon: Icon(Icons.calendar_today, color: Colors.white),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma data de entrega';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _cadastrarAtividade();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
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

  Future<void> _cadastrarAtividade() async {
    final titulo = _tituloController.text;
    final descricao = _descricaoController.text;
    final dataEntrega = _dataEntregaController.text;

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3010/api/atividade'),
        body: {'titulo': titulo, 'descricao': descricao, 'data': dataEntrega},
      );

      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        final message = jsonResponse['message'] as String;
        print('Atividade cadastrada com sucesso');
        _showSnackBarMessage(context, message, backgroundColor: Colors.green);
      } else {
        final errorMessage = jsonResponse['erro'] as String;
        print('Erro ao cadastrar atividade: $errorMessage');
        _showSnackBarMessage(context, errorMessage,
            backgroundColor: Colors.red);
      }
    } catch (e) {
      final errorMessage = 'Erro durante a solicitação: $e';
      _showSnackBarMessage(context, errorMessage, backgroundColor: Colors.red);
      print(errorMessage);
    }
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
}
