import 'package:flutter/material.dart';

void main(){
  runApp(Myapp());
}

class Myapp extends StatelessWidget{
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

  void _addTask(BuildContext context){
    if (_controller.text.isNotEmpty){
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

void _eraseTask(BuildContext context){
  if (tasks.isNotEmpty) {
    setState(() {
      tasks.removeAt(tasks.length - 1 );// Removes the last task in the list
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
      content: Text('Tarea eliminada'),
      duration: Duration(seconds: 2),
      ),
    );
  }
}



@override
Widget build(BuildContext context){
  return Scaffold(
    appBar: AppBar(
      title: Text('Lista de tareas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // campo de texto y el boton
            Row(
              children: [
                Expanded(
                  child:TextField(
                    controller : _controller,
                    decoration: InputDecoration(
                      hintText: 'Ingrese una tarea',
                    ),
                  ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _addTask(context),
                    child: Text('Agregar'),
                  )
              ],
            ),
            SizedBox(height: 20),
            // Lista de tareas
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index){
                  return ListTile(
                    title: Text(tasks[index]),
                  );
                },
                ),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => _eraseTask(context),
              child: Text('Eliminar'), 
              ),
          ],
        ),
      ),
    );
  }
}