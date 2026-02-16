import 'dart:math';

import 'package:app_pds/screens/InitialSplash.dart';
import 'package:flutter/material.dart';
import 'package:app_pds/services/database_service.dart';
import 'package:app_pds/models/note.dart';

import 'Notes.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  TextEditingController search = TextEditingController();

  List<Note> filteredNotes = [];

  //LIST to work with databaseee
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    loadNotes(); //load information of database
  }

  Future<void> loadNotes() async {
    final data = await DatabaseService.instance
        .queryAllNotes(); //Consult the database, and return all the saved notes

    final loadedNotes = data
        .map((e) => Note.fromMap(e))
        .toList(); //Convert the map in notes

    loadedNotes.sort((a, b) {
      //a, b, compare two notes at the same time
      if (a.isPinned && !b.isPinned) return -1; // a first in the list
      if (!a.isPinned && b.isPinned) return 1; // b first in the list
      return b.createdAt.compareTo(
        a.createdAt,
      ); //compareTo() to date, more recent first
    });

    setState(() {
      notes = loadedNotes;
      filteredNotes = loadedNotes; //show all notes
    });
  }

  //Modal press a note
  void showNoteOptions(Note note) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: const Icon(Icons.delete, color: Colors.red),
                      title: const Text(
                        "Eliminar",
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () async {
                        await DatabaseService.instance.deleteNote(
                          note.id!,
                        ); //delete from database
                        Navigator.pop(context);
                        loadNotes();
                      },
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      leading: const Icon(Icons.edit, color: Colors.blue),
                      title: const Text(
                        "Editar",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onTap: () async {
                        // abrir formulario de edición
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Addnotes(editingNote: note),
                          ),
                        );

                        if (result == true) {
                          Navigator.pop(context);
                          loadNotes();
                        }
                      },
                    ),
                  ),
                ],
              ),

              ///delete
              const Divider(),

              //DUPLICATE NOTE
              ListTile(
                leading: const Icon(Icons.copy, color: Colors.blue),
                title: const Text("Duplicar nota"),
                onTap: () async {
                  final duplicatedNote = Note(
                    title: note.title,
                    description: note.description,
                    color: note.color,
                    createdAt: DateTime.now(), //New date
                    isPinned: false, //NO DUPLICATE AS PINN
                  );

                  await DatabaseService.instance.insertNote(duplicatedNote);

                  Navigator.pop(context);
                  loadNotes();
                },
              ),

              //PINNED NOTE
              ListTile(
                leading: Icon(
                  note.isPinned
                      ? Icons.push_pin
                      : Icons
                            .push_pin_outlined, // If notes is pinned, show icon pin
                  color: Colors.orange,
                ),
                title: Text(
                  note.isPinned ? "Desfijar nota" : "Fijar nota",
                ), //If the note is pinned, show Unpin not", otherwise show in note
                onTap: () async {
                  final updatedNote = Note(
                    //Copy the content
                    id: note.id,
                    title: note.title,
                    description: note.description,
                    color: note.color,
                    createdAt: note.createdAt,
                    isPinned: !note.isPinned,
                  );

                  await DatabaseService.instance.updateNote(updatedNote);

                  Navigator.pop(context);
                  loadNotes();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override //Build Interface
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
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: search,

                  onChanged: (value) {
                    final query = value.toLowerCase();

                    setState(() {
                      filteredNotes = notes.where((note) {
                        final titleMatch = note.title.toLowerCase().contains(
                          query,
                        );

                        final descriptionMatch = note.description
                            .toLowerCase()
                            .contains(query);

                        final dateString =
                            "${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}";

                        final dateMatch = dateString.contains(query);

                        return titleMatch || descriptionMatch || dateMatch;
                      }).toList();
                    });
                  },

                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF2E2E2E),
                  ),
                  decoration: InputDecoration(
                    hintText: "Buscar notas...",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF7A8FA6),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
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
                      //List Viewer.builder
                      Expanded(
                        child: filteredNotes.isEmpty
                            ? Center(
                                child: Text(
                                  search.text.isEmpty
                                      ? "No hay notas aún"
                                      : "No se encontraron resultados",
                                ),
                              )
                            : ListView.builder(
                                itemCount: filteredNotes.length,
                                itemBuilder: (context, index) {
                                  final note = filteredNotes[index];

                                  return GestureDetector(
                                    onTap: () {
                                      showNoteOptions(note);
                                    },
                                    child: noteCard(note),
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

  Widget noteCard(Note note) {
    String formattedDate =
        "${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}";

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: Color(note.color),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //TEXT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        note.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                //DATE
                Text(formattedDate, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),

          //ICONO PIN (only if is pinned)
          if (note.isPinned)
            const Positioned(
              top: 10,
              right: 14,
              child: Icon(
                Icons.push_pin,
                size: 30,
                color: Color.fromARGB(255, 232, 231, 231), // dorado suave
              ),
            ),
        ],
      ),
    );
  }

  Widget addNoteCard() {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Addnotes()),
        );

        if (result == true) {
          loadNotes();
        }
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
