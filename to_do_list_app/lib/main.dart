import 'package:flutter/material.dart';

void main() {
  runApp(const TodoListApp());
}

class TodoListApp extends StatelessWidget {
  const TodoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo List Mingguan',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const TodoHomePage(),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  _TodoHomePageState createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  // ✅ Struktur data untuk tugas per hari dengan status (selesai atau belum)
  final Map<String, List<Map<String, dynamic>>> _weeklyTodos = {
    'Senin': [],
    'Selasa': [],
    'Rabu': [],
    'Kamis': [],
    'Jumat': [],
    'Sabtu': [],
    'Minggu': [],
  };

  final TextEditingController _controller = TextEditingController();
  String _selectedDay = 'Senin'; // ✅ Hari default saat input tugas

  // ✅ Tambah tugas ke hari tertentu
  void _addTodo() {
    final text = _controller.text;
    if (text.isNotEmpty) {
      setState(() {
        _weeklyTodos[_selectedDay]!.add({
          'task': text,
          'is Done': false, // Status awal tugas adalah belum selesai
        });
        _controller.clear();
      });
    }
  }

  // ✅ Hapus tugas dari hari tertentu
  void _removeTodo(String day, int index) {
    setState(() {
      _weeklyTodos[day]!.removeAt(index);
    });
  }

  // ✅ Ubah status tugas (selesai/belum selesai)
  void _toggleTaskStatus(String day, int index) {
    setState(() {
      _weeklyTodos[day]![index]['isDone'] = !_weeklyTodos[day]![index]['isDone'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List Mingguan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ✅ Form input tugas + dropdown hari
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Tambahkan Tugas',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedDay,
                  onChanged: (value) {
                    setState(() {
                      _selectedDay = value!;
                    });
                  },
                  items: _weeklyTodos.keys
                      .map((day) => DropdownMenuItem(
                            value: day,
                            child: Text(day),
                          ))
                      .toList(),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTodo,
                  child: const Text('Tambah'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ✅ Tampilan daftar tugas mingguan
            Expanded(
              child: ListView(
                children: _weeklyTodos.entries.map((entry) {
                  final day = entry.key;
                  final todos = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        day,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ...todos.asMap().entries.map((item) {
                        return Card(
                          child: ListTile(
                            leading: Checkbox(
                              value: item.value['isDone'],
                              onChanged: (_) => _toggleTaskStatus(day, item.key),
                            ),
                            title: Text(item.value['task']),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _removeTodo(day, item.key),
                            ),
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 8),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}