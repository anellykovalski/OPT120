import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CadastroUsuarioAtividadeScreen extends StatefulWidget {
  const CadastroUsuarioAtividadeScreen({Key? key}) : super(key: key);

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
  // ignore: unused_field
  double? _nota;
  String _message = '';

  List<Map<String, dynamic>> _usuarios = [];
  List<Map<String, dynamic>> _atividades = [];

  bool _dataLoaded = false; // Flag para controlar se os dados foram carregados

  @override
  void initState() {
    super.initState();
    if (!_dataLoaded) {
      _fetchData();
      _dataLoaded = true;
    }
  }

  Future<void> _fetchData() async {
    try {
      final responseUsuarios =
          await http.get(Uri.parse('http://localhost:3020/usuario'));
      final responseAtividades =
          await http.get(Uri.parse('http://localhost:3020/atividade'));

      if (responseUsuarios.statusCode == 200 &&
          responseAtividades.statusCode == 200) {
        final List<dynamic> usuariosData = jsonDecode(responseUsuarios.body);
        final List<dynamic> atividadesData =
            jsonDecode(responseAtividades.body);

        setState(() {
          _usuarios = usuariosData.cast<Map<String, dynamic>>();
          _atividades = atividadesData.cast<Map<String, dynamic>>();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

 Future<void> _vincularUsuarioAtividade() async {
  if (_formKey.currentState!.validate()) {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3020/usuario-atividade'),
        body: {
          'idUsuario': _selectedUserId!,
          'idAtividade': _selectedActivityId!,
          'dataEntrega': _dataEntrega!.toIso8601String(),
          // Adicione outros campos conforme necessário
        },
      );

      // Verificar o status da resposta
      if (response.statusCode == 200) {
        // Sucesso
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sucesso'),
              content: Text('Usuário vinculado à atividade com sucesso'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(); // Volta para a tela anterior
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        setState(() {
          _message = '';
        });
      } else {
        // Erro
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Erro'),
              content: Text(
                  'Erro ao vincular usuário à atividade: ${response.body}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Tratamento de exceções
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: Text('Erro durante a solicitação: $e'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('Cadastro de Usuário Atividade',
            style: TextStyle(color: Colors.white)),
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
                      backgroundColor: Colors.pink,
                      padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02),
                    ),
                    child: const Text(
                      'Cadastrar',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.pinkAccent,
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
