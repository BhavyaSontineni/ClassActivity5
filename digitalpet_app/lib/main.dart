import 'dart:async';
import 'package:flutter/material.dart';
//Bhavya Sri Sai-002893685
//Madhuri Tumula-002892521
void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Billa";
  int happinessLevel = 50;
  int hungerLevel = 50;
  int energyLevel = 100;
  bool isNameSet = false;
  TextEditingController _nameController = TextEditingController();
  Timer? _hungerTimer;
  Timer? _winTimer;
  bool gameOver = false;
  bool gameWon = false;

  // Function to increase happiness and update hunger when playing with the pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      energyLevel = (energyLevel - 10).clamp(0, 100); // Play consumes energy
      _updateHunger();
    });
  }

  // Function to decrease hunger and update happiness when feeding the pet
  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
      energyLevel = (energyLevel + 5).clamp(0, 100); // Feeding increases energy
    });
  }

  // Update happiness based on hunger level
  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
  }

  // Increase hunger level slightly when playing with the pet
  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
  }

  // Determine pet color based on happiness level
  Color _getPetColor() {
    if (happinessLevel > 70) {
      return Colors.green;  // Happy pet
    } else if (happinessLevel >= 30) {
      return Colors.yellow; // Neutral pet
    } else {
      return Colors.red;    // Unhappy pet
    }
  }

  // Get the mood text and emoji based on happiness level
  String _getPetMood() {
    if (happinessLevel > 70) {
      return "Happy 😊";  // Happy pet
    } else if (happinessLevel >= 30) {
      return "Neutral 😐"; // Neutral pet
    } else {
      return "Unhappy 😞"; // Unhappy pet
    }
  }

  // Handle the name confirmation
  void _confirmName() {
    setState(() {
      petName = _nameController.text.isNotEmpty ? _nameController.text : petName;
      isNameSet = true; // Set the name as confirmed
    });
  }

  // Start the timer to increase hunger every 30 seconds
  void _startHungerTimer() {
    _hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        _updateHunger();
      });
    });
  }

  // Check for win or loss conditions
  void _checkGameStatus() {
    if (happinessLevel > 80) {
      _startWinTimer();
    }
    if (hungerLevel == 100 && happinessLevel <= 10) {
      setState(() {
        gameOver = true;
      });
    }
  }

  // Start the timer for win condition
  void _startWinTimer() {
    if (_winTimer == null) {
      _winTimer = Timer.periodic(Duration(seconds: 180), (timer) {
        setState(() {
          gameWon = true;
        });
      });
    }
  }

  // Cancel the timers when the widget is disposed
  @override
  void dispose() {
    _hungerTimer?.cancel();
    _winTimer?.cancel();
    super.dispose();
  }

  // Activity selection dropdown
  String selectedActivity = "Play";

  // Handle activity selection
  void _selectActivity(String activity) {
    setState(() {
      selectedActivity = activity;
    });
    if (selectedActivity == "Play") {
      _playWithPet();
    } else if (selectedActivity == "Feed") {
      _feedPet();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Start the hunger timer once the pet name is confirmed
    if (isNameSet && _hungerTimer == null) {
      _startHungerTimer();
    }

    if (!gameOver && !gameWon) {
      _checkGameStatus();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // If the name is not set, show the name input field
            if (!isNameSet) ...[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Enter Pet Name',
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _confirmName,
                child: Text('Confirm Name'),
              ),
            ] else ...[
              // Once name is confirmed, show the pet information
              Text(
                'Name: $petName',
                style: TextStyle(fontSize: 20.0),
              ),
            ],
            SizedBox(height: 16.0),

            // Display Pet Image with dynamic color filter based on happiness
            Container(
              color: _getPetColor(), // Dynamically change the pet's color
              child: Image.asset('assets/pet_image.png', width: 200, height: 200),
            ),

            SizedBox(height: 16.0),
            Text(
              'Happiness Level: $happinessLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Hunger Level: $hungerLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Energy Level: $energyLevel',
              style: TextStyle(fontSize: 20.0),
            ),

            // Display the pet's mood
            Text(
              'Mood: ${_getPetMood()}',
              style: TextStyle(fontSize: 20.0),
            ),

            SizedBox(height: 16.0),
            LinearProgressIndicator(
              value: energyLevel / 100,
              color: Colors.blue,
              backgroundColor: Colors.grey,
            ),

            SizedBox(height: 16.0),

            // Activity selection dropdown
            DropdownButton<String>(
              value: selectedActivity,
              items: <String>['Play', 'Feed']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _selectActivity(newValue);
                }
              },
            ),

            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),

            // Game over or win display
            if (gameOver)
              Text(
                'Game Over! Your pet is hungry and unhappy!',
                style: TextStyle(fontSize: 20.0, color: Colors.red),
              ),
            if (gameWon)
              Text(
                'You Win! Your pet is happy for 3 minutes!',
                style: TextStyle(fontSize: 20.0, color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}
