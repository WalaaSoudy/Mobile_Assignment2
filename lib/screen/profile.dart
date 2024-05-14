// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider_2/databse_helper.dart';
// import 'package:provider_2/screen/Add_Favorite_Store_Screen.dart';
// import 'package:provider_2/screen/Favorite_Store_List_Screen.dart';
// import 'package:provider_2/screen/Store_List_Screen.dart'; // Import your database helper file here

// class EditProfileScreen extends StatefulWidget {
//   final String userName;
//   final String userEmail;

//   const EditProfileScreen({
//     required this.userName,
//     required this.userEmail,
//   });

//   @override
//   _EditProfileScreenState createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   late File? _imageFile; // Initialize _imageFile to null

//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();

//   String _nameError = '';
//   String _passwordError = '';
//   String _confirmPasswordError = '';

//   @override
//   void initState() {
//     super.initState();
//     _nameController.text = widget.userName;
//   }

//   Future<void> _getImage(ImageSource source) async {
//     final pickedFile = await ImagePicker().pickImage(source: source);

//     setState(() {
//       if (pickedFile != null) {
//         _imageFile = File(pickedFile.path);
//       }
//     });
//   }

//   Future<void> _uploadImage() async {
//     // You can implement local storage logic here if needed
//   }

//   Future<void> _updateProfile() async {
//     String name = _nameController.text;
//     String password = _passwordController.text;
//     String confirmPassword = _confirmPasswordController.text;

//     // Validate fields
//     if (name.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
//       // Show an error message or handle the case where fields are empty
//       return;
//     }

//     if (password != confirmPassword) {
//       // Show an error message for password mismatch
//       setState(() {
//         _confirmPasswordError = 'Passwords do not match';
//       });
//       return;
//     }

//     await DatabaseHelper().updateUser(widget.userEmail, name, password);

//     // Navigate back to the previous screen and pass the updated name
//     Navigator.pop(context, {'name': name});
//   }

//   void _signOut() {
//     // Implement sign out logic here
//     // For demonstration purposes, let's navigate to the home page
//     Navigator.pushReplacementNamed(context, '/');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Profile'),
//         actions: [
//           IconButton(
//             onPressed: _signOut,
//             icon: Icon(Icons.logout),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   _getImage(ImageSource.gallery);
//                 },
//                 child: Stack(
//                   children: [
//                     Container(
//                       width: 200,
//                       height: 200,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.grey[300],
//                       ),
//                       child: _imageFile != null
//                           ? ClipOval(
//                               child: Image.file(
//                                 _imageFile!,
//                                 width: 200,
//                                 height: 200,
//                                 fit: BoxFit.cover,
//                               ),
//                             )
//                           : Center(
//                               child: Icon(
//                                 Icons.person,
//                                 size: 100,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                     ),
//                     Positioned(
//                       bottom: 0,
//                       right: 0,
//                       child: Container(
//                         padding: EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Theme.of(context).primaryColor,
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(
//                           Icons.camera_alt,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   _getImage(ImageSource.gallery);
//                 },
//                 child: Text('Select Image from Gallery'),
//               ),
//               SizedBox(height: 20),
//               TextField(
//                 controller: _nameController,
//                 decoration: InputDecoration(
//                   labelText: 'Name',
//                   errorText: _nameError,
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 20),
//               TextField(
//                 controller: _passwordController,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   errorText: _passwordError,
//                   border: OutlineInputBorder(),
//                 ),
//                 obscureText: true,
//               ),
//               SizedBox(height: 20),
//               TextField(
//                 controller: _confirmPasswordController,
//                 decoration: InputDecoration(
//                   labelText: 'Confirm Password',
//                   errorText: _confirmPasswordError,
//                   border: OutlineInputBorder(),
//                 ),
//                 obscureText: true,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _updateProfile,
//                 child: Text('Save Profile'),
//               ),
//               ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => StoreListScreen(),
//                   ),
//                 );
//               },
//               child: Text('View All Stores'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => FavoriteStoreListScreen(),
//                   ),
//                 );
//               },
//               child: Text('View Favorite Stores'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => AddFavoriteStoreScreen(),
//                   ),
//                 );
//               },
//               child: Text('Add Favorite Store'),
//             ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
