import 'package:flutter/material.dart';
import 'package:flutter_application_7/databse_helper.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _selectedGender;
  String? _selectedLevel;

  String? _nameError;
  String? _emailError;
  String? _studentIdError;
  String? _passwordError;
  String? _confirmPasswordError;

  // Function to validate FCI Email structure
  bool _isFCIEmail(String email) {
    RegExp regex = RegExp(r'^\d{8}@stud\.fci-cu\.edu\.eg$');
    return regex.hasMatch(email);
  }

  // Function to validate password length
  bool _isValidPassword(String password) {
    return password.length >= 8;
  }

  // Function to validate if passwords match
  bool _passwordsMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  // Function to check if email is already taken
  Future<bool> _isEmailTaken(String email) async {
    // Check if email exists in the database
    return await DatabaseHelper().isEmailExists(email);
  }

  // Function to check if student ID is already taken
  Future<bool> _isStudentIdTaken(String studentId) async {
    // Check if student ID exists in the database
    return await DatabaseHelper().isStudentIdExists(studentId);
  }

  // Function to handle signup process
  void _signUp() async {
    setState(() {
      _nameError = _nameController.text.isEmpty ? 'Name is required' : null;
      _emailError = _emailController.text.isEmpty ? 'Email is required' : null;
      _studentIdError =
          _studentIdController.text.isEmpty ? 'Student ID is required' : null;
      _passwordError =
          _passwordController.text.isEmpty ? 'Password is required' : null;
      _confirmPasswordError = _confirmPasswordController.text.isEmpty
          ? 'Confirm Password is required'
          : null;

      if (_emailController.text.isNotEmpty && !_isFCIEmail(_emailController.text)) {
        _emailError = 'Please enter a valid FCI email.';
      }
      
      if (!_emailController.text
      .startsWith(_studentIdController.text)) {
    setState(() {
      _emailError = 'Email ID must start with your Student ID.';
    });
    return;
  }

      if (_passwordController.text.isNotEmpty &&
          !_isValidPassword(_passwordController.text)) {
        _passwordError = 'Password must be at least 8 characters.';
      }

      if (_confirmPasswordController.text.isNotEmpty &&
          !_passwordsMatch(
              _passwordController.text, _confirmPasswordController.text)) {
        _confirmPasswordError = 'Passwords do not match.';
      }
    });
     bool isEmailTaken = await _isEmailTaken(_emailController.text);
    if (isEmailTaken) {
      setState(() {
        _emailError = 'This email is already taken.';
      });
      return;
    }

    bool isStudentIdTaken = await _isStudentIdTaken(_studentIdController.text);
    if (isStudentIdTaken) {
      setState(() {
        _studentIdError = 'This student ID is already taken.';
      });
      return;
    }

    if (_nameError != null ||
        _emailError != null ||
        _studentIdError != null ||
        _passwordError != null ||
        _confirmPasswordError != null ||
        _selectedGender == null ||
        _selectedLevel == null) {
      return;
    }
    

   

    // Insert user data into the database
    Map<String, dynamic> userData = {
      'name': _nameController.text,
      'email': _emailController.text,
      'student_id': _studentIdController.text,
      'gender': _selectedGender,
      'level': int.parse(_selectedLevel!),
      'password': _passwordController.text,
    };

    int userId = await DatabaseHelper().insertUser(userData);

    if (userId != 0) {
      // User inserted successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign up successful'),
          duration: Duration(seconds: 3),
        ),
      );
      // Optionally, navigate to another screen after successful signup
      Navigator.pop(context, 'Signup success');
    } else {
      // Error occurred while inserting user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign up. Please try again.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                errorText: _nameError,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Gender: ',
                  style: TextStyle(fontSize: 16), // Adjust font size here
                ),
                Radio<String>(
                  value: 'Female',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
                Text('Female'),
                SizedBox(width: 20),
                Radio<String>(
                  value: 'Male',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
                Text('Male'),
              ],
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: _emailError,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _studentIdController,
              decoration: InputDecoration(
                labelText: 'Student ID',
                errorText: _studentIdError,
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedLevel,
              hint: Text('Select Level'),
              items: ['1', '2', '3', '4']
                  .map((level) => DropdownMenuItem<String>(
                        child: Text(level),
                        value: level,
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLevel = value;
                });
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: _passwordError,
              ),
              obscureText: true,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                errorText: _confirmPasswordError,
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signUp,
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
