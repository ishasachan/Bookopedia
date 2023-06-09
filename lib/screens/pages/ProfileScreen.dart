import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../theme.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? currentName;

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.email)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error occurred: ${snapshot.error}'),
            );
          }
          final userData = snapshot.data?.data();
          final profileImage = userData?['profileImage'];
          final email = userData?['email'];
          var currentName = userData?['name'];

          void _updateProfile() {
            final newName = _nameController.text;
            final newPassword = _passwordController.text;

            if (newName.isNotEmpty) {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(user?.email)
                  .update({'name': newName})
                  .then((_) {
                setState(() {
                  currentName = newName;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile updated'),
                  ),
                );
              }).catchError((error) {
                print('Error updating profile: $error');
              });
            }

            if (newPassword.isNotEmpty) {
              // You can implement the password update logic here
              // using FirebaseAuth.currentUser.updatePassword method
            }

            // Clear the text fields after updating
            _nameController.clear();
            _passwordController.clear();
          }

          final initials = currentName != null && currentName!.isNotEmpty
              ? currentName![0].toUpperCase()
              : '';

          _nameController.text = currentName ?? '';

          return ListView(
            children: [
              Container(
                color: Colors.brown,
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const SizedBox(height: 20,),
                    if (profileImage != null)
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: NetworkImage(profileImage),
                      ),
                    if (profileImage == null)
                      CircleAvatar(
                        radius: 80,
                        child: Text(
                          initials,
                          style: const TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.email),
                title: Text(
                  email ?? '',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: currentName ?? 'Enter your name',
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.lock),
                title: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    hintText: 'Enter new password',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _updateProfile,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: myTheme.primaryColor, // Adjust the color to your preference
                  ),
                  child: const Center(
                    child: Text(
                      "Update Profile",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
