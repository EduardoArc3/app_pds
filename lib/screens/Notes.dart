import 'package:flutter/material.dart';
import 'package:app_pds/models/note.dart';
import 'package:app_pds/services/database_service.dart';

class Addnotes extends StatefulWidget {
  final Note? editingNote;

  const Addnotes({super.key, this.editingNote});

  @override
  State<Addnotes> createState() => _Addnotes();
}

class _Addnotes extends State<Addnotes> {
  late final TextEditingController
  title; //TextEditingController get the text of TextField
  late final TextEditingController content;
  late Color selectedColor;

  bool get isEditing => widget.editingNote != null;

  @override
  void initState() {
    super.initState();

    title = TextEditingController();
    content = TextEditingController();

    if (isEditing) {
      final note = widget.editingNote!;
      title.text = note.title;
      content.text = note.description;
      selectedColor = Color(note.color);
    } else {
      selectedColor = const Color.fromARGB(255, 255, 255, 255);
    }
  }

  @override
  void dispose() {
    title.dispose();
    content.dispose();
    super.dispose();
  }

  //Available Colors for your selection
  final List<Color> colors = [
    const Color(0xFF8FA3C9),
    const Color(0xFF8EC5B6),
    const Color(0xFFA88CC5),
    const Color(0xFFB97BA5),
  ];

  //Execute [Aceptar]
  void saveNote() async {
    if (title.text.isEmpty && content.text.isEmpty) {
      Navigator.pop(context); //Navigator.pop(context) return a former page
      return;
    }

    // editar nota
    if (isEditing) {
      final updatedNote = Note(
        id: widget.editingNote!.id,
        title: title.text,
        description: content.text,
        color: selectedColor.value,
        createdAt: widget.editingNote!.createdAt,
        isPinned: widget.editingNote!.isPinned,
      );

      await DatabaseService.instance.updateNote(updatedNote);
    } else {
      //create a new note with this info
      final newNote = Note(
        title: title.text,
        description: content.text,
        color: selectedColor.value,
        createdAt: DateTime.now(),
        isPinned: false,
      );
      //insert the new note in SqLite used Databaservicesuwu
      await DatabaseService.instance.insertNote(newNote);
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E4FA2),

      //DESIGN
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                //HEADER
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      isEditing ? "Editar nota" : "Nueva nota",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: selectedColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: title,
                          decoration: const InputDecoration(
                            hintText: "Titulo",
                            border: InputBorder.none,
                          ),
                        ),

                        const Divider(),
                        Expanded(
                          child: TextField(
                            controller: content,
                            maxLines: null,
                            expands: true,
                            decoration: const InputDecoration(
                              hintText: "Contenido",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                //ColorMap
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: colors.map((color) {
                    return GestureDetector(
                      onTap: () {
                        //change color when pressed
                        setState(() {
                          selectedColor = color;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: selectedColor == color
                              ? Border.all(color: Colors.white, width: 3)
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                //Buttons Cancel and Accept
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: saveNote,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 203, 246, 205),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Center(
                            child: Text(
                              "Aceptar",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 154, 160, 171),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 248, 197, 197),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Center(
                            child: Text(
                              "Cancelar",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 229, 102, 90),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
