import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutterapplication2/ecommerse/profilePage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';


class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _formKey = GlobalKey<FormState>();
  late String email = '';
  late String password = '';
  late String name = '';
  late String mobile = '';
  File? image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _signUp() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate() && image != null) {
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String imageUrl = await _uploadImage(userCredential.user!.uid);
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': name,
          'mobile': mobile,
          'image': imageUrl,
        });
        Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) =>  ProfilePage(),
    ),
  );
        
      } catch (e) {
        print(e);
      }
    }
  }

  Future<String> _uploadImage(String uid) async {
    TaskSnapshot snapshot = await _storage.ref('user_images/$uid.png').putFile(image!);
    return await snapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  prefixIcon: Icon(Icons.email),
                ),
                onChanged: (value) => email = value,
                validator: (value) => value?.isEmpty ?? true ? 'Enter an email' : null,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  prefixIcon: Icon(Icons.lock),
                ),
                onChanged: (value) => password = value,
                validator: (value) => value?.isEmpty ?? true ? 'Enter a password' : null,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  prefixIcon: Icon(Icons.person),
                ),
                onChanged: (value) => name = value,
                validator: (value) => value?.isEmpty ?? true ? 'Enter a name' : null,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  prefixIcon: Icon(Icons.phone),
                ),
                onChanged: (value) => mobile = value,
                validator: (value) => value?.isEmpty ?? true ? 'Enter a mobile number' : null,
              ),
              SizedBox(height: 20.0),
              image != null
                  ? CircleAvatar(
                      radius: 50,
                      backgroundImage: FileImage(image!),
                    )
                  : Placeholder(
                      fallbackHeight: 100,
                      fallbackWidth: 100,
                    ),
              SizedBox(height: 20.0),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.image),
                label: Text('Choose Image'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _signUp,
                child: Text('Sign Up'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
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
