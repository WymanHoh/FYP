import 'package:flutter/material.dart';

class UserSelectionScreen extends StatefulWidget {
  const UserSelectionScreen({super.key});

  @override
    UserSelectionScreenState createState() => UserSelectionScreenState();
}

class UserSelectionScreenState extends State<UserSelectionScreen> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading:  Padding(
          padding:  const EdgeInsets.only(left: 16),
          child: Image.asset(
            'assets/images/logowhite.png',
            width: 20,
          ),
        ),
        title: const Text(
          'Procrastination Terminator',
          style: TextStyle(
            fontFamily: "Unica_One",  
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 10),
              // Progress bar
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: selectedRole != null ? 1.0 : 0.5),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, value, child) {
                    return LinearProgressIndicator(
                      value: value,
                      backgroundColor: Colors.grey[700],
                      color: const Color.fromARGB(255, 255, 196, 0),
                    );
                  },
                ),
              ),

              const Text(
                'WELCOME,',
                style: TextStyle(
                  fontFamily: "SpaceGrotesk",  
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'How do you define yourself?',
                style: TextStyle(
                  fontFamily: "SpaceGrotesk", 
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedRole  = 'Student';
                        });
                      },
                      child: Card(
                        color: Colors.grey[900],
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                            color: selectedRole == 'Student'
                                ? const Color.fromARGB(255, 255, 196, 0)
                                : Colors.transparent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),


                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/select_student.png', 
                                width: 60,
                                height: 60,
                              ),
                              const SizedBox(width: 20),
                              const Text(
                                'Student',
                                style: TextStyle(
                                  fontFamily: "SpaceGrotesk",  
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedRole = 'Co-Worker';
                        });
                      },
                      child: Card(
                        color: Colors.grey[900],
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                            color: selectedRole == 'Co-Worker'
                                ? const Color.fromARGB(255, 255, 196, 0)
                                : Colors.transparent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/select_coworker.png', // Replace with your own image path
                                width: 60,
                                height: 60,
                              ),
                              const SizedBox(width: 20),
                              const Text(
                                'Co-Worker',
                                style: TextStyle(
                                  fontFamily: "SpaceGrotesk",  
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
                

              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 196, 0),
                    foregroundColor: const Color.fromARGB(255, 17, 17, 17),
                    padding: const EdgeInsets.symmetric(horizontal: 125, vertical: 15),
                    
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  
                  onPressed: () {
                    // Handle Continue button press
                  },
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
