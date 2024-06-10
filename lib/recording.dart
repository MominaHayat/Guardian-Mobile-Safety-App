import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SafetySuggestionsPage extends StatelessWidget {
  final List<Map<String, dynamic>> safetySuggestions = [
    {"text": "Always be aware of your surroundings.", "icon": Icons.visibility},
    {"text": "Do not display valuables publicly.", "icon": Icons.lock_outline},
    {"text": "Stay in well-lit areas during nighttime.", "icon": Icons.lightbulb_outline},
    {"text": "Keep your friends or family informed about your whereabouts.", "icon": Icons.contact_phone},
    {"text": "Research the area you're visiting thoroughly.", "icon": Icons.map},
    {"text": "Carry a first-aid kit and emergency supplies.", "icon": Icons.local_hospital},
    {"text": "Avoid traveling alone at night.", "icon": Icons.nightlight_round},
    {"text": "Know the local emergency numbers.", "icon": Icons.phone},
    {"text": "Keep a backup of important documents.", "icon": Icons.backup},
    {"text": "Stay connected with local authorities.", "icon": Icons.security},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Safety Suggestions"),
        backgroundColor: Colors.green[800],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[100]!, Colors.green[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: CarouselSlider.builder(
            itemCount: safetySuggestions.length,
            itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.green[700],
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        safetySuggestions[itemIndex]['icon'],
                        size: 50,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Text(
                        safetySuggestions[itemIndex]['text']!,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: 300.0,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              enlargeCenterPage: true,
              enableInfiniteScroll: true,
            ),
          ),
        ),
      ),
    );
  }
}


