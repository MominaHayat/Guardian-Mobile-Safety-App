import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'edit.dart';

class UserProfile {
  String userId = '';
  String name = '';
  String email = '';
  String phoneNumber = '';
  String profilePicUrl = '';
  String address = '';
  String city = '';
  String cnic = '';
  String emergencyContacts = '';
  String gender = '';

  UserProfile({
    required this.userId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.profilePicUrl,
    required this.address,
    required this.city,
    required this.cnic,
    required this.emergencyContacts,
    required this.gender,
  });

  factory UserProfile.fromJson(Map<dynamic, dynamic> json) {
    return UserProfile(
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profilePicUrl: json['profilePicUrl'] ?? '',
      address: json['address'] is List ? (json['address'] as List).join(', ') : json['address'] ?? '',
      city: json['city'] is List ? (json['city'] as List).join(', ') : json['city'] ?? '',
      cnic: json['cnic'] ?? '',
      emergencyContacts: json['emergencyContacts'] is List ? (json['emergencyContacts'] as List).join(', ') : json['emergencyContacts'] ?? '',
      gender: json['gender'] ?? '',
    );
  }
}

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late DatabaseReference _userProfilesRef;

  @override
  void initState() {
    super.initState();
    _userProfilesRef = FirebaseDatabase.instance.reference().child('user_profiles');
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.green, // Set primary color to green
        appBarTheme: const AppBarTheme(
          color: Colors.green, // Set app bar color to green
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User Profile'),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CustomUserProfilePage()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(Icons.edit),
              ),
            ),
          ],
        ),
        body: FirebaseAnimatedList(
          query: _userProfilesRef,
          itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
            if (snapshot.value != null) {
              final userProfileData = snapshot.value as Map<dynamic, dynamic>;
              final userProfile = UserProfile.fromJson(userProfileData);
              return buildUserProfile(userProfile);
            } else {
              return const Center(
                child: Text('No data available'),
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildUserProfile(UserProfile userProfile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.green[50], // Set background color of the container
              borderRadius: BorderRadius.circular(10.0), // Add border radius
            ),
            padding: const EdgeInsets.all(10.0),
            child: CircleAvatar(
              backgroundColor: Colors.green, // Set the background color of the avatar to green
              backgroundImage: userProfile.profilePicUrl.isNotEmpty ? NetworkImage(userProfile.profilePicUrl) : null,
              radius: 50,
              child: userProfile.profilePicUrl.isEmpty ? const Icon(Icons.person) : null,
            ),
          ),
          const SizedBox(height: 20.0),
          buildTextField('Name', userProfile.name),
          const SizedBox(height: 10.0),
          buildTextField('Email', userProfile.email),
          const SizedBox(height: 10.0),
          buildTextField('Phone Number', userProfile.phoneNumber),
          const SizedBox(height: 10.0),
          buildTextField('Address', userProfile.address),
          const SizedBox(height: 10.0),
          buildTextField('City', userProfile.city),
          const SizedBox(height: 10.0),
          buildTextField('CNIC', userProfile.cnic),
          const SizedBox(height: 10.0),
          buildEmergencyContacts(userProfile.emergencyContacts),
          const SizedBox(height: 10.0),
          buildTextField('Gender', userProfile.gender),
          // Add other user profile fields as needed
        ],
      ),
    );
  }

  Widget buildEmergencyContacts(String contacts) {
    final emergencyContacts = contacts.split(', ');
    return Container(
      height: 150.0, // Set a fixed height for the container
      decoration: BoxDecoration(
        color: Colors.green[100], // Set background color of the container
        borderRadius: BorderRadius.circular(10.0), // Add border radius
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Emergency Contacts:',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5.0),
          Expanded(
            child: ListView.builder(
              itemCount: emergencyContacts.length,
              itemBuilder: (context, index) {
                return Text(
                  emergencyContacts[index],
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  Widget buildTextField(String label, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[100], // Set background color of the container
        borderRadius: BorderRadius.circular(5.0), // Add border radius
      ),
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}