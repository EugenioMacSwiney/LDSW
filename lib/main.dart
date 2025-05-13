import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CineApp());
}

class CineApp extends StatelessWidget {
  const CineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo de Películas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const PantallaInicio(),
        '/registro': (context) => const PantallaRegistro(),
        '/login': (context) => const PantallaLogin(),
        '/catalogo': (context) => const PantallaCatalogo(),
        '/admin': (context) => const PantallaAdministracion(),
      },
    );
  }
}

// Pantalla de Inicio
class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/cine_fondo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'BIENVENIDO A CINEFLIX',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/registro'),
                child: const Text('Registrarse'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: const Text('Iniciar Sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Pantalla de Registro
class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Correo electrónico'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su correo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su contraseña';
                  }
                  if (value.length < 6) {
                    return 'La contraseña debe tener al menos 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registrarUsuario,
                child: const Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _registrarUsuario() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        Navigator.pushReplacementNamed(context, '/catalogo');
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

// Pantalla de Login
class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Correo electrónico'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su correo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su contraseña';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _iniciarSesion,
                child: const Text('Iniciar Sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _iniciarSesion() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        Navigator.pushReplacementNamed(context, '/catalogo');
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

// Pantalla de Catálogo
class PantallaCatalogo extends StatefulWidget {
  const PantallaCatalogo({super.key});

  @override
  State<PantallaCatalogo> createState() => _PantallaCatalogoState();
}

class _PantallaCatalogoState extends State<PantallaCatalogo> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('peliculas');
  List<Map<dynamic, dynamic>> peliculas = [];

  @override
  void initState() {
    super.initState();
    _cargarPeliculas();
  }

  void _cargarPeliculas() {
    _dbRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          peliculas = data.entries.map((entry) {
            return {
              'id': entry.key,
              ...entry.value as Map<dynamic, dynamic>,
            };
          }).toList();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Películas'),
        actions: [
          if (FirebaseAuth.instance.currentUser?.email == 'admin@example.com')
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => Navigator.pushNamed(context, '/admin'),
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.7,
        ),
        itemCount: peliculas.length,
        itemBuilder: (context, index) {
          final pelicula = peliculas[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PantallaDetalle(pelicula: pelicula),
                ),
              );
            },
            child: Card(
              child: Column(
                children: [
                  Expanded(
                    child: pelicula['imagenUrl'] != null
                        ? Image.network(
                      pelicula['imagenUrl'],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                        : const Icon(Icons.movie, size: 100),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      pelicula['titulo'] ?? 'Sin título',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Pantalla de Detalle de Película
class PantallaDetalle extends StatelessWidget {
  final Map<dynamic, dynamic> pelicula;

  const PantallaDetalle({super.key, required this.pelicula});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pelicula['titulo'] ?? 'Detalle')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: pelicula['imagenUrl'] != null
                  ? Image.network(
                pelicula['imagenUrl'],
                height: 300,
                fit: BoxFit.contain,
              )
                  : const Icon(Icons.movie, size: 200),
            ),
            const SizedBox(height: 20),
            Text(
              'Título: ${pelicula['titulo'] ?? 'No disponible'}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Año: ${pelicula['anio'] ?? 'No disponible'}'),
            const SizedBox(height: 10),
            Text('Director: ${pelicula['director'] ?? 'No disponible'}'),
            const SizedBox(height: 10),
            Text('Género: ${pelicula['genero'] ?? 'No disponible'}'),
            const SizedBox(height: 20),
            const Text(
              'Sinopsis:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(pelicula['sinopsis'] ?? 'No disponible'),
          ],
        ),
      ),
    );
  }
}

// Pantalla de Administración
class PantallaAdministracion extends StatefulWidget {
  const PantallaAdministracion({super.key});

  @override
  State<PantallaAdministracion> createState() => _PantallaAdministracionState();
}

class _PantallaAdministracionState extends State<PantallaAdministracion> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('peliculas');
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _anioController = TextEditingController();
  final _directorController = TextEditingController();
  final _generoController = TextEditingController();
  final _sinopsisController = TextEditingController();
  File? _imagenSeleccionada;
  List<Map<dynamic, dynamic>> peliculas = [];

  @override
  void initState() {
    super.initState();
    _cargarPeliculas();
  }

  void _cargarPeliculas() {
    _dbRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          peliculas = data.entries.map((entry) {
            return {
              'id': entry.key,
              ...entry.value as Map<dynamic, dynamic>,
            };
          }).toList();
        });
      }
    });
  }

  Future<void> _subirPelicula() async {
    if (_formKey.currentState!.validate()) {
      try {
        final nuevaPelicula = {
          'titulo': _tituloController.text,
          'anio': _anioController.text,
          'director': _directorController.text,
          'genero': _generoController.text,
          'sinopsis': _sinopsisController.text,
          'imagenUrl': _imagenSeleccionada != null
              ? await _subirImagen(_imagenSeleccionada!)
              : null,
        };

        await _dbRef.push().set(nuevaPelicula);

        // Limpiar formulario
        _formKey.currentState!.reset();
        _tituloController.clear();
        _anioController.clear();
        _directorController.clear();
        _generoController.clear();
        _sinopsisController.clear();
        setState(() {
          _imagenSeleccionada = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Película agregada correctamente')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<String> _subirImagen(File imagen) async {
     return 'https://via.placeholder.com/300x450?text=${_tituloController.text}';
  }

  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagenSeleccionada = File(pickedFile.path);
      });
    }
  }

  Future<void> _eliminarPelicula(String id) async {
    await _dbRef.child(id).remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administración de Películas')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _tituloController,
                    decoration: const InputDecoration(labelText: 'Título'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el título';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _anioController,
                    decoration: const InputDecoration(labelText: 'Año'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el año';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _directorController,
                    decoration: const InputDecoration(labelText: 'Director'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el director';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _generoController,
                    decoration: const InputDecoration(labelText: 'Género'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el género';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _sinopsisController,
                    decoration: const InputDecoration(labelText: 'Sinopsis'),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese la sinopsis';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _imagenSeleccionada != null
                      ? Image.file(
                    _imagenSeleccionada!,
                    height: 150,
                    fit: BoxFit.cover,
                  )
                      : Container(),
                  ElevatedButton(
                    onPressed: _seleccionarImagen,
                    child: const Text('Seleccionar Imagen'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _subirPelicula,
                    child: const Text('Agregar Película'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Películas Existentes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: peliculas.length,
              itemBuilder: (context, index) {
                final pelicula = peliculas[index];
                return ListTile(
                  title: Text(pelicula['titulo'] ?? 'Sin título'),
                  subtitle: Text(pelicula['director'] ?? 'Sin director'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _eliminarPelicula(pelicula['id']),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _anioController.dispose();
    _directorController.dispose();
    _generoController.dispose();
    _sinopsisController.dispose();
    super.dispose();
  }
}