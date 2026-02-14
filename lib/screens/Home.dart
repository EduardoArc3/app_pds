import 'dart:math';

import 'package:app_pds/screens/InitialSplash.dart';
import 'package:flutter/material.dart';
import 'Notes.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  final List<Color> noteColors = [
    const Color(0xFF8FA3C9),
    const Color(0xFF8EC5B6),
    const Color(0xFFA88CC5),
    const Color(0xFFB97BA5),
    const Color.fromARGB(255, 133, 163, 228),
    const Color.fromARGB(255, 238, 142, 142),
    const Color.fromARGB(255, 34, 173, 233),
    const Color.fromARGB(255, 16, 45, 108),
  ];

  //LISTA DINAMICA
  List<Map<String, String>> notes = [];

  @override //construye la interfaz
  Widget build(BuildContext context) {
    return Scaffold(
      //Scaffold proporciona la estructura base del screen
      backgroundColor: const Color(0xFF2E4FA2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E4FA2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Initialsplash()),
            );
          },
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: "Buscar",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Container(
                  padding: EdgeInsets.all(17),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Notas",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),
                      //Lista Dinamica
                      Expanded(
                        child: notes.isEmpty
                            ? const Center(child: Text("No hay notas aún"))
                            : ListView.builder(
                                itemCount: notes.length,
                                itemBuilder: (context, index) {
                                  return noteCard(
                                    notes[index]['title']!,
                                    notes[index]['content']!,
                                    notes[index]['date']!,
                                    noteColors[index % noteColors.length],
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 10),

                      addNoteCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget noteCard(String title, String content, String date, Color color) {
    DateTime parsedDate = DateTime.parse(date);
    String formattedDate =
        "${parsedDate.day}/${parsedDate.month}/${parsedDate.year}";

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              Text(content),
            ],
          ),
          Text(formattedDate),
        ],
      ),
    );
  }

  Widget addNoteCard() {
    return GestureDetector(
      onTap: () {
        setState(() {
          notes.add({
            "title": "Nota ${notes.length + 1}",
            "content": "Contenido de la nota",
            "date": DateTime.now().toString(),
          });
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.shade200,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: const [
            Icon(Icons.add),
            SizedBox(width: 10),
            Text("Nueva Nota"),
          ],
        ),
      ),
    );
  }
}
