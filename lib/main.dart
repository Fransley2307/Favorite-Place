import 'package:flutter/material.dart';
import 'package:gerenciador_tarefas_26/pages/filtro_pages.dart';
import 'package:gerenciador_tarefas_26/pages/lista_lugares_page.dart';





void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Favorite Place 2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      home: ListaLugaresPage(),
      routes: {
        FiltroPage.ROUTE_NAME: (BuildContext context) => FiltroPage(),
      },
    );
  }
}