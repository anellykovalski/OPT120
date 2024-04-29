import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CadastroUsuarioAtividadeScreen extends StatefulWidget {
  const CadastroUsuarioAtividadeScreen({Key? key});

  @override
  _CadastroUsuarioAtividadeScreenState createState() =>
      _CadastroUsuarioAtividadeScreenState();
}

class _CadastroUsuarioAtividadeScreenState
    extends State<CadastroUsuarioAtividadeScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedUserId;
  String? _selectedActivityId;
  DateTime? _dataEntrega;
  double? _nota;
  String _message = '';

  List<Map<String, dynamic>> _usuarios = [];
  List<Map<String, dynamic>> _atividades = [];

  @override
  void initState() {
    super.initState();
    _fetchUsuarios();
    _fetchAtividades();
  }

  Future<void> _fetchUsuarios() async {
    final response =
        await http.get(Uri.parse('http://localhost:3010/api/usuario'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _usuarios = data.cast<Map<String, dynamic>>();
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> _fetchAtividades() async {
    final response =
        await http.get(Uri.parse('http://localhost:3010/api/atividade'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _atividades = data.cast<Map<String, dynamic>>();
      });
    } else {
      throw Exception('Failed to load activities');
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

  Future<void> _vincularUsuarioAtividade() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse('http://localhost:3010/api/usuario_atividade'),
          body: {
            'idUsuario': _selectedUserId!,
            'idAtividade': _selectedActivityId!,
            'dataEntrega': _dataEntrega!.toIso8601String(),
            'nota': _nota!.toString(),
          },
        );

        final jsonResponse = json.decode(response.body);

        // Verificar o status da resposta
        if (response.statusCode == 200) {
          final message = jsonResponse['message'] as String;
          print('Usuário vinculado à atividade com sucesso');
          _showSnackBarMessage(context, message, backgroundColor: Colors.green);
        } else {
          final errorMessage = jsonResponse['erro'] as String;
          print('Erro ao vincular usuário à atividade: $errorMessage');
          _showSnackBarMessage(context, errorMessage,
              backgroundColor: Colors.red);
        }
      } catch (e) {
        print('Erro durante a solicitação: $e');
        _showSnackBarMessage(context, 'Erro durante a solicitação: $e',
            backgroundColor: Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Cadastro de Usuário Atividade',
            style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.05,
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
                  Text(
                    'Vincular Usuário a Atividade',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  DropdownButtonFormField<String>(
                    value: _selectedUserId,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedUserId = value;
                      });
                    },
                    items: _usuarios.isEmpty
                        ? null
                        : _usuarios.map<DropdownMenuItem<String>>(
                            (Map<String, dynamic> user) {
                            return DropdownMenuItem<String>(
                              value: user['ID_USUARIO'].toString(),
                              child: Text(user['EMAIL']),
                            );
                          }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Selecione um usuário',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, selecione um usuário';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  DropdownButtonFormField<String>(
                    value: _selectedActivityId,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedActivityId = value;
                      });
                    },
                    items: _atividades.isEmpty
                        ? null
                        : _atividades.map<DropdownMenuItem<String>>(
                            (Map<String, dynamic> activity) {
                            return DropdownMenuItem<String>(
                              value: activity['ID_ATIVIDADE'].toString(),
                              child: Text(activity['TITULO']),
                            );
                          }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Selecione uma atividade',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, selecione uma atividade';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  InkWell(
                    onTap: () => _selectDataEntrega(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Data de Entrega',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _dataEntrega == null
                                ? 'Selecione a data de Entrega'
                                : '${_dataEntrega!.day}/${_dataEntrega!.month}/${_dataEntrega!.year}',
                          ),
                          Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Nota',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      double? nota = double.tryParse(value);
                      if (nota != null) {
                        setState(() {
                          _nota = nota;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma nota';
                      }
                      double? nota = double.tryParse(value);
                      if (nota == null) {
                        return 'Por favor, insira um número válido';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  ElevatedButton(
                    onPressed: _vincularUsuarioAtividade,
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
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    _message,
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _validateDataEntrega(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira uma data de entrega';
    }
    // Adicione outras validações conforme necessário
    return null;
  }

  Future<void> _selectDataEntrega(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _dataEntrega = pickedDate;
      });
    }
  }
}
 