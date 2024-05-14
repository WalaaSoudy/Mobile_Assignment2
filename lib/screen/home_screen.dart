import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_7/screen/DistanceScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_7/databse_helper.dart';
import 'package:flutter_application_7/screen/Add_Favorite_Store_Screen.dart';
import 'package:flutter_application_7/screen/Favorite_Store_List_Screen.dart';
import 'package:flutter_application_7/screen/Store_List_Screen.dart';
import 'package:flutter_application_7/store_model.dart';


class HomeScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String ImagePath;

  const HomeScreen({
    required this.userName,
    required this.userEmail,
    required this.ImagePath,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  late String _userImagePath = '';
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  String? _nameError;
  String? _passwordError;
  String? _confirmPasswordError;
  
  String? _validateName(String value) {
    if (value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validatePassword() {
    String value = _passwordController.text;
    if (value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  String? _validateConfirmPassword(String value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      _nameController.text = widget.userName;
      Map<String, dynamic> user =
          await DatabaseHelper().getUserByEmail(widget.userEmail);
      _passwordController.text = user['password'] as String;
      _confirmPasswordController.text = user['password'] as String;

      // Set the user image path using the passed parameter
      if (widget.ImagePath.isNotEmpty) {
        setState(() {
          _userImagePath = widget.ImagePath;
        });
      }
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  void _updateUserProfile() {
    String name = _nameController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (_nameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _confirmPasswordController.text = '';
      });
      return;
    }

    DatabaseHelper().updateUser(widget.userEmail, name, password);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile updated successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _userImagePath = pickedFile.path;
      });

      // Update user profile with new image path using email
      DatabaseHelper().insertImage(_userImagePath);
    }
  }

  void _toggleShowPassword() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _toggleShowConfirmPassword() {
    setState(() {
      _showConfirmPassword = !_showConfirmPassword;
    });
  }

  void _logout() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () {
                  // Show options to take a new image or upload from the gallery
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.camera),
                              title: Text('Take a new photo'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(ImageSource.camera);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.image),
                              title: Text('Choose from gallery'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(ImageSource.gallery);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: 20),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: _userImagePath.isNotEmpty
                                ? FileImage(File(_userImagePath))
                                : null,
                            child: _userImagePath.isEmpty
                                ? Icon(Icons.person, size: 50)
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.email),
                        SizedBox(width: 5),
                        Text(
                          widget.userEmail,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  errorText: _nameError,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: !_showPassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  errorText: _passwordError,
                  suffixIcon: IconButton(
                    icon: Icon(_showPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: _toggleShowPassword,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_showConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  errorText: _confirmPasswordError,
                  suffixIcon: IconButton(
                    icon: Icon(_showConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: _toggleShowConfirmPassword,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _nameError = _validateName(_nameController.text);
                    _passwordError = _validatePassword();
                    _confirmPasswordError =
                        _validateConfirmPassword(_confirmPasswordController.text);
                  });
                  if (_nameError == null &&
                      _passwordError == null &&
                      _confirmPasswordError == null) {
                    _updateUserProfile();
                  }
                },
                child: Text('Save'),
              ),
              ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoreListScreen(),
                  ),
                );
              },
              child: Text('View All Stores'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoriteStoreListScreen(userEmail: widget.userEmail),
                  ),
                );
              },
              child: Text('View Favorite Stores'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddFavoriteStoreScreen(userEmail: widget.userEmail),
                  ),
                );
              },
              child: Text('Add Favorite Store'),
            ),
            
          
          
            ],
          ),
        ),
      ),
    );
  }
}
