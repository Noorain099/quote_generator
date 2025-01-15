import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> quotes = [];
  String currentQuote = '';
  bool inProgress = false;

  @override
  void initState() {
    super.initState();
    getQuotes();
  }

  Future<void> getQuotes() async {
    try {
      String url =
          "https://www.goodreads.com/author/quotes/22527058.Muslim_Smiles";

      Uri uri = Uri.parse(url);
      http.Response response = await http.get(uri);

      dom.Document document = parser.parse(response.body);

      final quotesElements = document.getElementsByClassName("quoteText");

      setState(() {
        quotes = quotesElements.map((element) {
          String quoteText = element.text.trim();

          if (quoteText.contains('—')) {
            quoteText = quoteText
                .replaceAll('—', "")
                .trim(); // Keep only the quote part
          }

          if (quoteText.endsWith('Muslim Smiles')) {
            quoteText = quoteText.replaceAll('Muslim Smiles', '').trim();
          }

          return quoteText;
        }).toList();
      });

      if (quotes.isNotEmpty) {
        currentQuote = quotes[Random().nextInt(quotes.length)];
      }
    } catch (e) {
      print("Error fetching quotes: $e");
    }
  }

  void generateQuote() {
    setState(() {
      if (quotes.isNotEmpty) {
        // Select a random quote from the list
        final randomIndex = Random().nextInt(quotes.length);
        currentQuote = quotes[randomIndex];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF000000),
                  Color.fromARGB(255, 15, 42, 92),
                  Color.fromARGB(255, 26, 64, 134),
                  Color.fromARGB(255, 37, 92, 114),
                  Color.fromARGB(255, 26, 64, 134),
                  Color.fromARGB(255, 16, 36, 75),
                  Color(0xFF000000),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/splash");
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 35,
                          weight: 50,
                        )),
                    const SizedBox(width: 20),
                    const Text(
                      "Quotes",
                      style: TextStyle(
                        color: Colors.white,
                        height: 2,
                        fontSize: 30,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                // Display the current quote
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    currentQuote.isNotEmpty ? currentQuote : "Loading...",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 22,
                        fontStyle: FontStyle.italic,
                        color: Colors.white),
                  ),
                ),

                const Spacer(),
                ElevatedButton(
                  onPressed: generateQuote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 37, 92, 114),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.only(top: 16, bottom: 16, right: 8, left: 8),
                    child: Text(
                      "Generate Next Quote",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
