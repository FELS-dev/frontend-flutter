import 'package:flutter/material.dart';
import './home_page.dart';

class QuizScreen extends StatefulWidget {
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> questionList = [
    {
      "id": 1,
      "question": "Où se déroule généralement VivaTech ?",
      "choices": [
        {"id": 1, "choice": "Londres", "isCorrect": false},
        {"id": 2, "choice": "Paris", "isCorrect": true},
        {"id": 3, "choice": "Berlin", "isCorrect": false},
      ]
    },
    {
      "id": 2,
      "question": "Quel est le principal thème de VivaTech ?",
      "choices": [
        {"id": 1, "choice": "Innovation et technologie", "isCorrect": true},
        {"id": 2, "choice": "Art et littérature", "isCorrect": false},
        {"id": 3, "choice": "Mode et design", "isCorrect": false},
      ]
    },
    {
      "id": 3,
      "question": "En quelle année a eu lieu la première édition de VivaTech ?",
      "choices": [
        {"id": 1, "choice": "2010", "isCorrect": false},
        {"id": 2, "choice": "2015", "isCorrect": false},
        {"id": 3, "choice": "2016", "isCorrect": true},
      ]
    },
    {
      "id": 4,
      "question": "VivaTech met en avant les startups de quel secteur ?",
      "choices": [
        {"id": 1, "choice": "Technologie et numérique", "isCorrect": true},
        {"id": 2, "choice": "Alimentation et restauration", "isCorrect": false},
        {"id": 3, "choice": "Textile et habillement", "isCorrect": false},
      ]
    },
    {
      "id": 5,
      "question": "VivaTech est organisé par quelle entreprise ?",
      "choices": [
        {"id": 1, "choice": "Microsoft", "isCorrect": false},
        {"id": 2, "choice": "Publicis Groupe et Les Échos", "isCorrect": true},
        {"id": 3, "choice": "Apple", "isCorrect": false},
      ]
    },
    {
      "id": 6,
      "question": "VivaTech s’adresse à quel type de public ?",
      "choices": [
        {"id": 1, "choice": "Professionnels de la technologie et grand public", "isCorrect": true},
        {"id": 2, "choice": "Professionnels de la santé uniquement", "isCorrect": false},
        {"id": 3, "choice": "Étudiants uniquement", "isCorrect": false},
      ]
    },
    {
      "id": 7,
      "question": "VivaTech accueille des conférences de qui ?",
      "choices": [
        {"id": 1, "choice": "Célébrités du cinéma uniquement", "isCorrect": false},
        {"id": 2, "choice": "dirigeants d'entreprises technologiques, entrepreneurs", "isCorrect": true},
        {"id": 3, "choice": "Musiciens uniquement", "isCorrect": false},
      ]
    },

    // Add more questions as needed
  ];
  int currentQuestionIndex = 0;
  int score = 0;
  Map<String, dynamic>? selectedChoice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 5, 50, 80),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              "Quiz",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            _questionWidget(),
            Column(
              children: questionList[currentQuestionIndex]["choices"]
                  .map<Widget>((choice) => _answerButton(choice))
                  .toList(),
            ),
            _nextButton(),
          ],
        ),
      ),
    );
  }

  _questionWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Question ${currentQuestionIndex + 1}/${questionList.length.toString()}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFF0081),
                Color(0xFFFF00E4),
                Color(0xFFF15700),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            questionList[currentQuestionIndex]["question"],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }

  Widget _answerButton(Map<String, dynamic> choice) {
    bool isSelected = selectedChoice?["id"] == choice["id"];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: isSelected ? Color(0xFFF15700) : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black,
        ),
        onPressed: () {
          setState(() {
            selectedChoice = choice;
          });
        },
        child: Text(choice["choice"]),
      ),
    );
  }

  _nextButton() {
    bool isLastQuestion = false;
    if (currentQuestionIndex == questionList.length - 1) {
      isLastQuestion = true;
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
        onPressed: selectedChoice != null ? () {
          if (selectedChoice!["isCorrect"]) {
            score++;
          }

          if (isLastQuestion) {
            showDialog(context: context, builder: (_) => _showScoreDialog());
          } else {
            setState(() {
              selectedChoice = null;
              currentQuestionIndex++;
            });
          }
        } : null,
        child: Text(isLastQuestion ? "Soumettre" : "Suivant"),
      ),
    );
  }

  _showScoreDialog() {
    bool isPassed = false;

    if (score >= questionList.length * 0.6) {
      //pass if 60 %
      isPassed = true;
    }
    String title = isPassed ? "Passed " : "Failed";

    return AlertDialog(
      title: Text(
        "Nombre de réponses correctes  $score",
        style: TextStyle(color: isPassed ? Colors.green : Colors.redAccent),
      ),
      content: ElevatedButton(
        child: const Text("Accueil"),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },
      ),
    );
  }
}
