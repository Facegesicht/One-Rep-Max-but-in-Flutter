import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:number_editing_controller/number_editing_controller.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "test",
    theme: ThemeData(
    // Define the default brightness and colors.
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      // ···
      brightness: Brightness.dark,
    ),

    // Define the default `TextTheme`. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      displayLarge: const TextStyle(
        fontSize: 72,
      ),
      // ···
      titleLarge: GoogleFonts.inter(
        fontSize: 30,
      ),
      bodyMedium: GoogleFonts.inter(),
      displaySmall: GoogleFonts.inter(),
    ),
  ),
  home: const MyHomePage(title: "mario ist strong"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final getWeight = NumberEditingTextController.decimal();
  final getReps = NumberEditingTextController.integer();
  String oneRepMaxString = "poop";
  Map<double,double> items = {};

  String _poop()
  {
    items.clear();
    var reps = (getReps.number ?? 0).toDouble();

    if (getWeight.text.isEmpty || getReps.text.isEmpty)
    {
      return "leeres feld (dumm)";
    }
    if(num.tryParse(getWeight.text) == null || num.tryParse(getReps.text) == null)
    {
      return "benutz zahlen pls";
    }
    
    var oneRepMaxBigFinal = ((getWeight.number ?? 0) * (36.0 / (37.0 - reps)));
    var onreRepMaxFixedString = oneRepMaxBigFinal.toStringAsFixed(1);

    if(oneRepMaxBigFinal < 0)
    {
      return "error (reps zu hoch)";
    }

    if (reps == 0)
    {
      return "$onreRepMaxFixedString 🤨";
    }
    _poops(oneRepMaxBigFinal, reps);
    return onreRepMaxFixedString;
  }

  void _poops(double oneRepMax, double reps)
  {
    for (var i = 14; i >= 0; i--)
    {
      var gewicht  = oneRepMax / (36.0 / (37.0 - (15 - i)));
      items[gewicht] = (15 - i).toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  Text(
                    oneRepMaxString,
                    key: const Key("textKey"),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 48),
                  ),

                  const SizedBox(height: 40),

                  TextField(
                    controller: getWeight,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 28),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Gewicht",
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: getReps,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 28),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Wiederholungen",
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    height: 80,
                    child: ElevatedButton(
                       style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[400],
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        textStyle: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                        foregroundColor: Colors.black87),
                      onPressed: () {
                        setState(() {
                          oneRepMaxString = _poop();
                        });
                        FocusScope.of(context).unfocus();
                      },
                      child: const Text("Berechnen"),
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// SCROLLABLE TABLE
                  Expanded(
                    child: SingleChildScrollView(
                      child: Table(
                        border: TableBorder.all(),
                        columnWidths: const {
                          0: FlexColumnWidth(),
                          1: FlexColumnWidth(),
                        },
                        children: [
                          const TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  "Weight",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  "Reps",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                                ),
                              ),
                            ],
                          ),

                          ...items.entries.map(
                            (entry) => TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    entry.key.toStringAsFixed(1),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    entry.value.toStringAsFixed(0),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}
