import 'dart:async';
import 'package:flutter/material.dart';

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
  bool isNameSet = false; // Track if the name has been set
  TextEditingController _nameController = TextEditingController();

  // Timer for automatic hunger increase
  Timer? _hungerTimer;

  // Function to increase happiness and update hunger when playing with the pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updateHunger();
    });
  }

  // Function to decrease hunger and update happiness when feeding the pet
  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
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

  // Cancel the timer when the widget is disposed to avoid memory leaks
  @override
  void dispose() {
    _hungerTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Start the hunger timer once the pet name is confirmed
    if (isNameSet && _hungerTimer == null) {
      _startHungerTimer();
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

            // Display the pet's mood
            Text(
              'Mood: ${_getPetMood()}',
              style: TextStyle(fontSize: 20.0),
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
          ],
        ),
      ),
    );
  }
}
