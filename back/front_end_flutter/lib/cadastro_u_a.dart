// cadastro_u_a.dart
import 'package:flutter/material.dart';

class CadastroUsuarioAtividade extends StatefulWidget {
  @override
  _CadastroUsuarioAtividadeState createState() => _CadastroUsuarioAtividadeState();
}

class _CadastroUsuarioAtividadeState extends State<CadastroUsuarioAtividade> {
  late String _usuarioSelecionado;
  late String _atividadeSelecionada;
  late DateTime _dataSelecionada;
  late double _nota;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Usuário Atividade'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _usuarioSelecionado,
                hint: Text('Selecione um usuário'),
                items: ['Usuário 1', 'Usuário 2', 'Usuário 3']
                    .map((String usuario) {
                  return DropdownMenuItem(
                    value: usuario,
                    child: Text(usuario),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _usuarioSelecionado = value!;
                  });
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _atividadeSelecionada,
                hint: Text('Selecione uma atividade'),
                items: ['Atividade 1', 'Atividade 2', 'Atividade 3']
                    .map((String atividade) {
                  return DropdownMenuItem(
                    value: atividade,
                    child: Text(atividade),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _atividadeSelecionada = value!;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Data',
                  hintText: 'Selecione a data',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2025),
                  );
                  if (pickedDate != null && pickedDate != _dataSelecionada) {
                    setState(() {
                      _dataSelecionada = pickedDate;
                    });
                  }
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nota',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  setState(() {
                    _nota = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Implemente a lógica para vincular usuário, atividade, data e nota
                  print('Usuário selecionado: $_usuarioSelecionado');
                  print('Atividade selecionada: $_atividadeSelecionada');
                  print('Data selecionada: $_dataSelecionada');
                  print('Nota: $_nota');
                },
                child: Text('Vincular'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
