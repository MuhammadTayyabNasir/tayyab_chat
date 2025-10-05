import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tayyab_chat/widgets/glass_container.dart'; // Import our new widget
import '../main.dart';
import '../widgets/user_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firebase = FirebaseAuth.instance;

// A decorative background for our neon theme
class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // ... (Your existing state variables and _submit function are fine)
  final _form = GlobalKey<FormState>();
  var _isLogin = true;
  var _username = '';
  var _email = '';
  var _password = '';
  Uint8List? _selectedImage;
  var _isAuthenticating = false;

  void _submit() async {
    final isValid = _form.currentState!.validate();
    if (!isValid || !_isLogin && _selectedImage == null) {
      if (!_isLogin && _selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please pick an image.')),
        );
      }
      return;
    }
    _form.currentState!.save();
    try {
      setState(() { _isAuthenticating = true; });
      if (_isLogin) {
        await _firebase.signInWithEmailAndPassword(email: _email, password: _password);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(email: _email, password: _password);
        final storageRef = FirebaseStorage.instance.ref().child('user_images').child('${userCredentials.user!.uid}.jpg');
        await storageRef.putData(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();
        await FirebaseFirestore.instance.collection('users').doc(userCredentials.user!.uid).set({
          'username': _username, 'email': _email, 'image_url': imageUrl,
        });
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String message = 'An error occurred, please check your credentials!';
      if (e.code == 'email-already-in-use') { message = 'This email address is already in use.'; }
      else if (e.code == 'invalid-email') { message = 'Please enter a valid email address.'; }
      else if (e.code == 'weak-password') { message = 'The password is too weak.'; }
      else if (e.code == 'user-not-found' || e.code == 'wrong-password') { message = 'Invalid credentials. Please try again.'; }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(message)), );
      setState(() { _isAuthenticating = false; });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground( // Use our decorative background
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  width: 150, // Smaller logo for a sleeker look
                  // Add a glow effect to the logo
                  child: ShaderMask(
                    shaderCallback: (bounds) =>
                        const LinearGradient(
                          colors: [kNeonColor, Colors.pinkAccent],
                          tileMode: TileMode.mirror,
                        ).createShader(bounds),
                    child: Image.asset('assets/images/chat.png'),
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: GlassContainer( // Here is our Glass UI!
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _form,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!_isLogin)
                              UserImagePicker(onPickImage: (pickedImage) { _selectedImage = pickedImage; }),
                            if (!_isLogin)
                              TextFormField(
                                decoration: const InputDecoration(labelText: 'Username'),
                                enableSuggestions: false,
                                validator: (v) => (v == null || v.trim().length < 4) ? 'Please enter at least 4 characters.' : null,
                                onSaved: (v) { _username = v!; },
                              ),
                            const SizedBox(height: 12),
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Email Address'),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (v) => (v == null || !v.contains('@')) ? 'Please enter a valid email address.' : null,
                              onSaved: (v) { _email = v!; },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Password'),
                              obscureText: true,
                              validator: (v) => (v == null || v.trim().length < 6) ? 'Password must be at least 6 characters long.' : null,
                              onSaved: (v) { _password = v!; },
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: _isAuthenticating ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 36),
                              ),
                              child: _isAuthenticating
                                  ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black,))
                                  : Text(_isLogin ? 'Login' : 'Sign Up'),
                            ),
                            const SizedBox(height: 12),
                            if (!_isAuthenticating)
                              TextButton(
                                onPressed: () => setState(() { _isLogin = !_isLogin; }),
                                child: Text(_isLogin ? 'Create New Account' : 'I already have an account'),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}