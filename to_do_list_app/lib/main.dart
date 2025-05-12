import 'package:flutter/material.dart';
import 'second_page.dart'; // Mengimpor halaman kedua

void main() {
  runApp(const TodoListApp());
}

class TodoListApp extends StatefulWidget {
  const TodoListApp({super.key});

  @override
  State<TodoListApp> createState() => _TodoListAppState();
}

class _TodoListAppState extends State<TodoListApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List Mingguan',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Poppins',
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Poppins',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: TodoHomePage(onThemeToggle: _toggleTheme),
    );
  }
}

class TodoHomePage extends StatelessWidget {
  final Function(bool) onThemeToggle;

  const TodoHomePage({super.key, required this.onThemeToggle});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('To-Do List Mingguan'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Home'),
              Tab(text: 'Tentang'),
              Tab(text: 'Pengaturan'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TodoListPage(),
            const AboutPage(),
            SettingsPage(onThemeToggle: onThemeToggle),
          ],
        ),
      ),
    );
  }
}

class TodoListPage extends StatefulWidget {
  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final Map<String, List<Map<String, dynamic>>> _weeklyTodos = {
    'Senin': [], 'Selasa': [], 'Rabu': [],
    'Kamis': [], 'Jumat': [], 'Sabtu': [], 'Minggu': [],
  };
  final TextEditingController _controller = TextEditingController();
  String _selectedDay = 'Senin';

  void _addTodo() {
    final text = _controller.text;
    if (text.isNotEmpty) {
      setState(() {
        _weeklyTodos[_selectedDay]!.add({'task': text, 'isDone': false});
        _controller.clear();
      });
    }
  }

  void _removeTodo(String day, int index) {
    setState(() => _weeklyTodos[day]!.removeAt(index));
  }

  void _toggleTaskStatus(String day, int index) {
    setState(() {
      _weeklyTodos[day]![index]['isDone'] = !_weeklyTodos[day]![index]['isDone'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Tambahkan Tugas',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: _selectedDay,
                onChanged: (value) => setState(() => _selectedDay = value!),
                items: _weeklyTodos.keys
                    .map((day) => DropdownMenuItem(value: day, child: Text(day)))
                    .toList(),
              ),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: _addTodo, child: const Text('Tambah')),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: _weeklyTodos.entries.map((entry) {
                final day = entry.key;
                final todos = entry.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(day, style: Theme.of(context).textTheme.titleMedium),
                    ...todos.asMap().entries.map((item) {
                      return Card(
                        child: ListTile(
                          leading: Checkbox(
                            value: item.value['isDone'],
                            onChanged: (_) => _toggleTaskStatus(day, item.key),
                          ),
                          title: Text(
                            item.value['task'],
                            style: TextStyle(
                              decoration: item.value['isDone']
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _removeTodo(day, item.key),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 8),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Aplikasi To-Do List Mingguan ini dibuat dengan Flutter.\n'
          'Gunakan untuk mengatur tugas harian kamu secara lebih terstruktur.',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  final Function(bool) onThemeToggle;

  const SettingsPage({super.key, required this.onThemeToggle});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SwitchListTile(
          title: const Text('Mode Gelap'),
          value: _isDark,
          onChanged: (value) {
            setState(() => _isDark = value);
            widget.onThemeToggle(_isDark);
          },
        ),
      ],
    );
  }
}