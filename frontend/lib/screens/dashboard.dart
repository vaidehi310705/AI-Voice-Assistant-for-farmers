import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

void main() {
  runApp(FarmigoApp());
}

class FarmigoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farmigo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Contact {
  final String name;
  final String role;
  final String phone;
  final String expertise;

  Contact({
    required this.name,
    required this.role,
    required this.phone,
    required this.expertise,
  });
}

class GovernmentScheme {
  final String name;
  final String description;
  final String eligibility;
  final String benefit;

  GovernmentScheme({
    required this.name,
    required this.description,
    required this.eligibility,
    required this.benefit,
  });
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  bool isListening = false;
  bool showContacts = false;
  bool showSchemes = false;

  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1))
      ..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleVoice() {
    setState(() {
      isListening = true;
    });

    Future.delayed(Duration(seconds: 3), () {
      if (mounted) setState(() => isListening = false);
    });
  }

  // Mock weather data
  final String weatherCondition = "sunny"; // sunny, cloudy, rainy
  final int temperature = 32;

  List<Contact> contacts = [
    Contact(name: "Dr. Rajesh Patil", role: "Agricultural Expert", phone: "+91 98765 43210", expertise: "Crop Diseases"),
    Contact(name: "Sunita Sharma", role: "Weather Specialist", phone: "+91 98765 43211", expertise: "Weather Forecasting"),
    Contact(name: "Amit Kumar", role: "Market Analyst", phone: "+91 98765 43212", expertise: "Crop Pricing"),
    Contact(name: "Priya Desai", role: "Soil Expert", phone: "+91 98765 43213", expertise: "Soil Health"),
    Contact(name: "Ravi Joshi", role: "Irrigation Specialist", phone: "+91 98765 43214", expertise: "Water Management"),
    Contact(name: "Meera Patel", role: "Organic Farming Expert", phone: "+91 98765 43215", expertise: "Organic Methods"),
  ];

  List<GovernmentScheme> governmentSchemes = [
    GovernmentScheme(name: "PM-KISAN Scheme", description: "Direct income support to farmers", eligibility: "All landholding farmers", benefit: "₹6,000 per year in 3 installments"),
    GovernmentScheme(name: "Pradhan Mantri Fasal Bima Yojana", description: "Crop insurance scheme for farmers", eligibility: "All farmers growing notified crops", benefit: "Insurance coverage for crop losses"),
    GovernmentScheme(name: "Kisan Credit Card", description: "Credit facility for agricultural needs", eligibility: "All farmers with land records", benefit: "Easy access to credit at low interest"),
    GovernmentScheme(name: "Soil Health Card Scheme", description: "Soil testing and health monitoring", eligibility: "All farmers", benefit: "Free soil testing and recommendations"),
    GovernmentScheme(name: "Pradhan Mantri Krishi Sinchai Yojana", description: "Irrigation development program", eligibility: "Farmers with irrigation needs", benefit: "Subsidized irrigation infrastructure"),
  ];

  IconData getWeatherIcon(String condition) {
    switch (condition) {
      case "sunny":
        return Icons.wb_sunny;
      case "cloudy":
        return Icons.cloud;
      case "rainy":
        return Icons.beach_access;
      default:
        return Icons.wb_sunny;
    }
  }

  LinearGradient getWeatherGradient(String condition) {
    switch (condition) {
      case "sunny":
        return LinearGradient(colors: [Colors.orange.shade300, Colors.yellow.shade400]);
      case "cloudy":
        return LinearGradient(colors: [Colors.blueGrey.shade400, Colors.blueGrey.shade200]);
      case "rainy":
        return LinearGradient(colors: [Colors.blue.shade600, Colors.blue.shade300]);
      default:
        return LinearGradient(colors: [Colors.orange.shade300, Colors.yellow.shade400]);
    }
  }

  LinearGradient getAppBackgroundGradient() {
    return LinearGradient(
      colors: [Colors.green.shade50, Colors.teal.shade50, Colors.amber.shade50],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: getAppBackgroundGradient(),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(16),
                color: Colors.green.withOpacity(0.9),
                child: Row(
                  children: [
                    if (showContacts || showSchemes)
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            showContacts = false;
                            showSchemes = false;
                          });
                        },
                      ),
                    Expanded(
                      child: Center(
                        child: Text(
                          showContacts
                              ? "Expert Contacts"
                              : showSchemes
                                  ? "Government Schemes"
                                  : "🌾 Farmigo Voice Assistant",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: !showContacts && !showSchemes
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Full-width Weather Section
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                              decoration: BoxDecoration(
                                gradient: getWeatherGradient(weatherCondition),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5)),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(getWeatherIcon(weatherCondition), size: 50, color: Colors.white),
                                      SizedBox(width: 16),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("${temperature}°C",
                                              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                                          Text(weatherCondition[0].toUpperCase() + weatherCondition.substring(1),
                                              style: TextStyle(color: Colors.white70, fontSize: 16)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Icon(Icons.arrow_forward_ios, color: Colors.white70),
                                ],
                              ),
                            ),

                            // Mic with pulsing animation
                            AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: isListening ? _pulseAnimation.value : 1.0,
                                  child: GestureDetector(
                                    onTap: toggleVoice,
                                    child: Container(
                                      width: 160,
                                      height: 160,
                                      decoration: BoxDecoration(
                                        color: isListening ? Colors.redAccent : Colors.green,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 10,
                                            offset: Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        isListening ? Icons.mic : Icons.mic_none,
                                        color: Colors.white,
                                        size: 80,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 16),
                            if (isListening)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  color: Colors.green.shade100,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      "Listening...",
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green.shade800),
                                    ),
                                  ),
                                ),
                              ),
                            SizedBox(height: 30),
                            // Redesigned Contacts & Schemes Cards
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  // Contacts Card
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => setState(() => showContacts = true),
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 20),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [Colors.green.shade400, Colors.green.shade700]),
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [BoxShadow(color: Colors.green.shade200.withOpacity(0.5), blurRadius: 10, offset: Offset(0, 5))],
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.2),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(Icons.phone, color: Colors.white, size: 30),
                                            ),
                                            SizedBox(height: 10),
                                            Text("Contacts", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                            Text("Connect with experts", style: TextStyle(color: Colors.white70, fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  // Schemes Card
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => setState(() => showSchemes = true),
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 20),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [Colors.orange.shade400, Colors.orange.shade700]),
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [BoxShadow(color: Colors.orange.shade200.withOpacity(0.5), blurRadius: 10, offset: Offset(0, 5))],
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.2),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(Icons.file_copy, color: Colors.white, size: 30),
                                            ),
                                            SizedBox(height: 10),
                                            Text("Schemes", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                            Text("Farmer welfare programs", style: TextStyle(color: Colors.white70, fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : SingleChildScrollView(
                          padding: EdgeInsets.all(16),
                          child: showContacts
                              ? Column(
                                  children: contacts
                                      .map(
                                        (contact) => Card(
                                          margin: EdgeInsets.symmetric(vertical: 8),
                                          child: Padding(
                                            padding: EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(contact.name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade800)),
                                                        Text(contact.role, style: TextStyle(color: Colors.green.shade600)),
                                                      ],
                                                    ),
                                                    Icon(Icons.phone, color: Colors.green.shade600),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Text(contact.phone, style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w500)),
                                                Text("Specializes in: ${contact.expertise}", style: TextStyle(color: Colors.green.shade600)),
                                                SizedBox(height: 8),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                                  onPressed: () => launchUrl(Uri.parse('tel:${contact.phone}')),
                                                  child: Text("Call Now"),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                )
                              : Column(
                                  children: governmentSchemes
                                      .map(
                                        (scheme) => Card(
                                          margin: EdgeInsets.symmetric(vertical: 8),
                                          child: Padding(
                                            padding: EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(scheme.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green.shade800)),
                                                SizedBox(height: 4),
                                                Text(scheme.description, style: TextStyle(color: Colors.green.shade700)),
                                                SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        padding: EdgeInsets.all(8),
                                                        decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
                                                        child: Text("Eligibility: ${scheme.eligibility}", style: TextStyle(color: Colors.green.shade700)),
                                                      ),
                                                    ),
                                                    SizedBox(width: 8),
                                                    Expanded(
                                                      child: Container(
                                                        padding: EdgeInsets.all(8),
                                                        decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(8)),
                                                        child: Text("Benefit: ${scheme.benefit}", style: TextStyle(color: Colors.orange.shade700)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                                  onPressed: () {},
                                                  child: Text("Learn More"),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
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
