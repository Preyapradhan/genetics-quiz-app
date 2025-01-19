import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';


void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final AudioPlayer _audioPlayer = AudioPlayer();

  void _playWelcomeSound() async {
    await _audioPlayer.play(AssetSource('sounds/welcome.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    _playWelcomeSound();
    return Scaffold(
      appBar: AppBar(
        title: Text('Genetics and Evolution Quiz'),
        backgroundColor: const Color.fromARGB(255, 146, 105, 217),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to the Genetics Quiz!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    // Stop the audio before navigating
                    _audioPlayer.stop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuizScreen()),
                    );
                  },
                  child: Text(
                    'Start Quiz',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<dynamic> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  int _lives = 3;
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> loadQuizData() async {
    final response = await http.get(Uri.parse('https://api.jsonserve.com/Uw5CrX'));
    if (response.statusCode == 200) {
      setState(() {
        _questions = json.decode(response.body)['questions'];
      });
    } else {
      throw Exception('Failed to load quiz data');
    }
  }

  void _playSound(String soundPath) async {
    await _audioPlayer.play(AssetSource(soundPath));
  }

  @override
  void initState() {
    super.initState();
    loadQuizData();
  }

  void _checkAnswer(bool isCorrect) {
    if (isCorrect) {
      _playSound('sounds/correct.mp3');
      setState(() {
        _score += 4;
      });
    } else {
      _playSound('sounds/wrong.mp3');
      setState(() {
        _lives -= 1;
      });
    }

    if (_currentIndex < _questions.length - 1 && _lives > 0) {
      setState(() {
        _currentIndex++;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(score: _score, lives: _lives),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Loading Quiz...')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = _questions[_currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Screen'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/quiz_background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(
                        3,
                        (index) => Icon(
                          index < _lives
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Text(
                      'Score: $_score',
                      style: TextStyle(
                        fontSize: 18,
                        color: const Color.fromARGB(255, 255, 204, 2),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Question ${_currentIndex + 1}/${_questions.length}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 20),
                Text(
                  question['description'],
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SizedBox(height: 20),
                ...question['options'].map<Widget>((option) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _checkAnswer(option['is_correct']),
                    child: Text(option['description']),
                  );
                }).toList(),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final int score;
  final int lives;
  final AudioPlayer _audioPlayer = AudioPlayer();

  ResultScreen({required this.score, required this.lives});

  void _playResultSound() async {
    if (lives > 0) {
      await _audioPlayer.play(AssetSource('sounds/success.mp3'));
    } else {
      await _audioPlayer.play(AssetSource('sounds/gameover.mp3'));
    }
  }

  @override
  Widget build(BuildContext context) {
    _playResultSound();

    // Choose the image based on the result
    String resultImage =
    lives > 0 ? 'assets/images/success.jpg' : 'assets/images/gameover.jpg';

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Result'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              resultImage, // Show success or game over image
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Your Score: $score',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Lives Remaining: $lives',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    // Stop the audio before navigating
                    _audioPlayer.stop();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                      (route) => false,
                    );
                  },
                  child: Text('Retry Quiz'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
