import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Atividade {
  final int id;
  String titulo;
  String descricao;
  DateTime data;

  Atividade({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.data,
  });

  factory Atividade.fromJson(Map<String, dynamic> json) {
    return Atividade(
      id: json['ID_ATIVIDADE'],
      titulo: json['TITULO'],
      descricao: json['DESC'],
      data: DateTime.parse(json['DATA']),
    );
  }

  void atualizarTitulo(String novoTitulo) {
    this.titulo = novoTitulo;
  }

  void atualizarDescricao(String novaDescricao) {
    this.descricao = novaDescricao;
  }

  void atualizarData(DateTime novaData) {
    this.data = novaData;
  }
}

class ListaAtividadeScreen extends StatefulWidget {
  const ListaAtividadeScreen({Key? key}) : super(key: key);

  @override
  _ListaAtividadeScreenState createState() => _ListaAtividadeScreenState();
}

class _ListaAtividadeScreenState extends State<ListaAtividadeScreen> {
  late Future<List<Atividade>> _atividades;
  late final Map<int, bool> _isEditing = {};

  void startEditing(int id) {
    setState(() {
      _isEditing[id] = true;
    });
  }

  void stopEditing(int id) {
    setState(() {
      _isEditing[id] = false;
    });
    _atividades =
        _getAtividades(); // Atualiza a lista de atividades ao cancelar a edição
  }

  Future<List<Atividade>> _getAtividades() async {
    final response =
        await http.get(Uri.parse('http://localhost:3010/api/atividade'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Atividade.fromJson(data)).toList();
    } else {
      throw Exception('Falha ao carregar as atividades');
    }
  }

  @override
  void initState() {
    super.initState();
    _atividades = _getAtividades();
  }

  void editarAtividade(Atividade atividade) {
    startEditing(atividade.id);
  }

  void _showSnackBarMessage(String message,
      {Color backgroundColor = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  void removerAtividade(int id) async {
    try {
      final response = await http
          .delete(Uri.parse('http://localhost:3010/api/atividade/$id'));
      if (response.statusCode == 200) {
        setState(() {
          _atividades = _getAtividades();
        });
        _showSnackBarMessage('Atividade removida com sucesso',
            backgroundColor: Colors.green);
      } else {
        _showSnackBarMessage('Erro ao remover atividade');
      }
    } catch (error) {
      print('Erro ao fazer requisição DELETE: $error');
      _showSnackBarMessage('Erro ao fazer requisição DELETE');
    }
  }

  void salvarEdicao(Atividade atividade) async {
    print('Salvando edição da atividade ${atividade.id}');

    final Uri uri =
        Uri.parse('http://localhost:3010/api/atividade/${atividade.id}');
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final Map<String, dynamic> body = {
      'titulo': atividade.titulo,
      'descricao': atividade.descricao,
      'data':
          '${atividade.data.year}-${atividade.data.month.toString().padLeft(2, '0')}-${atividade.data.day.toString().padLeft(2, '0')} ${atividade.data.hour.toString().padLeft(2, '0')}:${atividade.data.minute.toString().padLeft(2, '0')}:${atividade.data.second.toString().padLeft(2, '0')}',
    };

    try {
      final response =
          await http.put(uri, headers: headers, body: json.encode(body));
      if (response.statusCode == 200) {
        print('Dados da atividade atualizados com sucesso');
        setState(() {
          _atividades = _getAtividades(); // Atualiza a lista de atividades
        });
        stopEditing(atividade.id);
        _showSnackBarMessage('Dados da atividade atualizados com sucesso',
            backgroundColor:
                Colors.green); // Chamada da função _showSnackBarMessage
      } else {
        final dynamic responseData = json.decode(response.body);
        final String errorMessage = responseData['message'];
        print('Falha ao atualizar dados da atividade: $errorMessage');
        _showSnackBarMessage(errorMessage,
            backgroundColor:
                Colors.red); // Chamada da função _showSnackBarMessage
      }
    } catch (error) {
      print('Erro ao fazer requisição PUT: $error');
      _showSnackBarMessage('Erro ao fazer requisição PUT',
          backgroundColor:
              Colors.red); // Chamada da função _showSnackBarMessage
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
          'Lista de Atividades',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.02,
          horizontal: screenWidth * 0.1,
        ),
        child: FutureBuilder<List<Atividade>>(
          future: _atividades,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Erro: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final atividade = snapshot.data![index];
                  final isEditing = _isEditing.containsKey(atividade.id) &&
                      _isEditing[atividade.id] == true;

                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: isEditing
                        ? _buildEditableAtividade(atividade)
                        : _buildStaticAtividade(atividade),
                  );
                },
              );
            } else {
              return Center(
                child: Text('Nenhuma atividade encontrada.'),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildStaticAtividade(Atividade atividade) {
    String formattedDay = atividade.data.day.toString().padLeft(2, '0');
    String formattedMonth = atividade.data.month.toString().padLeft(2, '0');
    String formattedYear = atividade.data.year.toString();
    String formattedDate = '$formattedDay/$formattedMonth/$formattedYear';

    return ListTile(
      title: Text(atividade.titulo),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(atividade.descricao),
          Text('Data: $formattedDate'),
        ],
      ),
      trailing: Wrap(
        spacing: 8,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              editarAtividade(atividade);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              removerAtividade(atividade.id);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEditableAtividade(Atividade atividade) {
    TextEditingController tituloController =
        TextEditingController(text: atividade.titulo);
    TextEditingController descricaoController =
        TextEditingController(text: atividade.descricao);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: tituloController,
          decoration: InputDecoration(labelText: 'Título'),
          onChanged: (value) {
            atividade.atualizarTitulo(value);
          },
        ),
        TextFormField(
          controller: descricaoController,
          decoration: InputDecoration(labelText: 'Descrição'),
          onChanged: (value) {
            atividade.atualizarDescricao(value);
          },
        ),
        TextButton(
          onPressed: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: atividade.data,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );

            if (selectedDate != null) {
              setState(() {
                atividade.atualizarData(selectedDate);
              });
            }
          },
          child: Text(
            'Data: ${atividade.data.day.toString().padLeft(2, '0')}/${atividade.data.month.toString().padLeft(2, '0')}/${atividade.data.year}',
            style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                salvarEdicao(atividade);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color.fromARGB(255, 34, 221, 9),
              ),
              child: Text('Salvar'),
            ),
            SizedBox(width: 8),
            TextButton(
              onPressed: () {
                stopEditing(atividade.id);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color.fromARGB(255, 207, 9, 9),
              ),
              child: Text('Cancelar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ListaAtividadeScreen(),
  ));
}
