import 'package:flutter/material.dart';

class Addnotes extends StatefulWidget {
  const Addnotes({super.key});

  @override
  State<Addnotes> createState() => _Addnotes();
}

class _Addnotes extends State<Addnotes> {
  final TextEditingController title =
      TextEditingController(); //TextEditingController get the text of TextField
  final TextEditingController content = TextEditingController();

  Color selectedColor = const Color.fromARGB(255, 254, 255, 255);

  final List<Color> colors = [
    const Color(0xFF8FA3C9),
    const Color(0xFF8EC5B6),
    const Color(0xFFA88CC5),
    const Color(0xFFB97BA5),
  ];

  void saveNote() {
    if (title.text.isEmpty && content.text.isEmpty) {
      Navigator.pop(context); //Navigator.pop(context) return a former page
      return;
    }

    Navigator.pop(context, {
      "title": title.text,
      "content": content.text,
      "date": DateTime.now().toString(),
      "color": selectedColor.value,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E4FA2),

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
                    const Text(
                      "Nueva nota",
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: colors.map((color) {
                    return GestureDetector(
                      onTap: () {
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
