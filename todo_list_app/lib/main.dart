import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TodoListScreen(),
    );
  }
}


class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  // para almacenar la lista de tareas
  List<String> tasks = [];
  // Controlador de texto
  final TextEditingController _controller = TextEditingController();
  String _dato = 'Sin Dato';

@override
void initState(){
  super.initState();
  _cargarDato();
}

Future<void> _guardarDato(String valor) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('miDato',tasks);
  setState((){
    _dato = valor;
  });
}


Future<void> _cargarDato() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState((){
    _dato = prefs.getStringList('tasks') ?? [];
  });
}


  void _addTask() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        tasks.add(_controller.text); // agrega la tarea a la lista
        _controller.clear(); // Limpia el campo de texto
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Tarea agregada'),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Por favor, ingresa una tarea'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _eraseTask(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text("¿Estás seguro de que quieres eliminar?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  tasks.removeAt(index); 
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tarea eliminada'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Sí'),
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de tareas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // campo de texto y el boton
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Ingrese una tarea'),
                    maxLength: 50,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: (){ 
                    _addTask(),
                    _guardarDato()
                  },
                  child: Text('Agregar'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Lista de tareas
            Expanded(
              child:
                  tasks.isEmpty
                      ? const Center(child: Text('No hay tareas aun'))
                      : ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(tasks[index]),
                            trailing: IconButton(
                              onPressed: () => _eraseTask(index),
                              icon: const Icon(Icons.delete, color: Colors.red,),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
