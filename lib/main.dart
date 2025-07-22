import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart'; // ← Add this to pubspec.yaml

void main() {
  runApp(const DailyQuotesApp());
}

class DailyQuotesApp extends StatefulWidget {
  const DailyQuotesApp({super.key});

  @override
  State<DailyQuotesApp> createState() => _DailyQuotesAppState();
}

class _DailyQuotesAppState extends State<DailyQuotesApp> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Quotes',
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: DailyQuotePage(
        toggleTheme: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
      ),
    );
  }
}

class DailyQuotePage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const DailyQuotePage({super.key, required this.toggleTheme});

  @override
  State<DailyQuotePage> createState() => _DailyQuotePageState();
}

class _DailyQuotePageState extends State<DailyQuotePage> {
  List<String> quotes = [
    "Believe you can and you're halfway there.",
    "Dream big and dare to fail.",
    "What we think, we become.",
    "Success is not in what you have, but who you are.",
    "Act as if what you do makes a difference. It does.",
    "With the new day comes new strength and new thoughts.",
    "The best way to get started is to quit talking and begin doing.",
  ];

  late String currentQuote;
  List<String> favorites = [];

  @override
  void initState() {
    super.initState();
    currentQuote = quotes[0];
  }

  void getNewQuote() {
    setState(() {
      currentQuote = (quotes..shuffle()).first;
    });
  }

  void shareQuote() {
    Share.share(currentQuote);
  }

  void showFavoritesDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Favorite Quotes"),
        content: favorites.isEmpty
            ? const Text("No favorites yet!")
            : SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    return ListTile(title: Text(favorites[index]));
                  },
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🌟 Daily Quotes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
            tooltip: "Toggle Light/Dark Mode",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Today's Quote:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '"$currentQuote"',
                  style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 12,
                children: [
                  ElevatedButton(
                    onPressed: getNewQuote,
                    child: const Text("🎲 New Quote"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (!favorites.contains(currentQuote)) {
                        setState(() {
                          favorites.add(currentQuote);
                        });
                      }
                    },
                    child: const Text("❤️ Favorite"),
                  ),
                  ElevatedButton(
                    onPressed: showFavoritesDialog,
                    child: const Text("⭐ View Favorites"),
                  ),
                  ElevatedButton(
                    onPressed: shareQuote,
                    child: const Text("📤 Share"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
