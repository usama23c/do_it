// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:do_it/views/auth/verify_email_page.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:email_validator/email_validator.dart';
//
// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});
//
//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }
//
// class _SignupScreenState extends State<SignupScreen> {
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   bool _loading = false;
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//
//   Future<void> _signUp() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => _loading = true);
//
//     try {
//       // Create user in Firebase Auth
//       final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );
//
//       User? user = credential.user;
//
//       if (user != null) {
//         // Set display name in Firebase Auth
//         await user.updateDisplayName(_nameController.text.trim());
//
//         // Store user details in Firestore
//         await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
//           'name': _nameController.text.trim(),
//           'email': _emailController.text.trim(),
//           'uid': user.uid,
//           'timestamp': FieldValue.serverTimestamp(),
//         });
//
//         // Send verification email
//         await user.sendEmailVerification();
//       }
//
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => VerifyEmailScreen(email: _emailController.text.trim()),
//         ),
//       );
//     } on FirebaseAuthException catch (e) {
//       String message = 'Something went wrong';
//       if (e.code == 'email-already-in-use') {
//         message = 'This email is already registered';
//       } else if (e.code == 'weak-password') {
//         message = 'Password is too weak';
//       }
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//     } finally {
//       setState(() => _loading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0D47A1),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const SizedBox(height: 20),
//                 Center(child: Image.asset('assets/Checkmark.png', width: 80)),
//                 const SizedBox(height: 20),
//                 Text("Welcome to ", textAlign: TextAlign.center,
//                     style: GoogleFonts.poppins(fontSize: 22, color: Colors.white)),
//                 Text("DO IT", textAlign: TextAlign.center,
//                     style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
//                 const SizedBox(height: 8),
//                 Text("Create an account and join us now!", textAlign: TextAlign.center,
//                     style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70)),
//                 const SizedBox(height: 32),
//                 _buildTextField(
//                   controller: _nameController,
//                   icon: Icons.person,
//                   hint: 'Name',
//                   validator: (v) => v!.isEmpty ? 'Enter your name' : null,
//                 ),
//                 const SizedBox(height: 16),
//                 _buildTextField(
//                   controller: _emailController,
//                   icon: Icons.email_outlined,
//                   hint: 'E-mail',
//                   validator: (v) {
//                     if (v!.isEmpty) return 'Enter your email';
//                     if (!EmailValidator.validate(v)) return 'Enter a valid email';
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 _buildTextField(
//                   controller: _passwordController,
//                   icon: Icons.lock_outline,
//                   hint: 'Password',
//                   obscureText: _obscurePassword,
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscurePassword ? Icons.visibility_off : Icons.visibility,
//                       color: Colors.grey[700],
//                     ),
//                     onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
//                   ),
//                   validator: (v) {
//                     if (v!.isEmpty) return 'Enter password';
//                     if (v.length < 8 || !v.contains(RegExp(r'[A-Z]'))) {
//                       return 'Password must be at least 8 chars and include a capital letter';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 _buildTextField(
//                   controller: _confirmPasswordController,
//                   icon: Icons.lock,
//                   hint: 'Confirm Password',
//                   obscureText: _obscureConfirmPassword,
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
//                       color: Colors.grey[700],
//                     ),
//                     onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
//                   ),
//                   validator: (v) {
//                     if (v!.isEmpty) return 'Confirm your password';
//                     if (v != _passwordController.text) return 'Passwords do not match';
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 24),
//                 ElevatedButton(
//                   onPressed: _loading ? null : _signUp,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.lightBlueAccent,
//                     minimumSize: const Size.fromHeight(48),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                   ),
//                   child: _loading
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : Text('Sign Up', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text("Already have an account? ",
//                         style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70)),
//                     GestureDetector(
//                       onTap: () => Navigator.pop(context),
//                       child: Text("Sign In",
//                           style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent)),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required IconData icon,
//     required String hint,
//     bool obscureText = false,
//     Widget? suffixIcon,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       obscureText: obscureText,
//       style: const TextStyle(color: Colors.black),
//       decoration: InputDecoration(
//         prefixIcon: Icon(icon, color: Colors.grey[700]),
//         suffixIcon: suffixIcon,
//         hintText: hint,
//         hintStyle: const TextStyle(color: Colors.grey),
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
//       ),
//       validator: validator,
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_it/views/auth/verify_email_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import '../../core/theme/app_colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      // Create user in Firebase Auth
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = credential.user;

      if (user != null) {
        // Set display name in Firebase Auth
        await user.updateDisplayName(_nameController.text.trim());

        // Store user details in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'uid': user.uid,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Send verification email
        await user.sendEmailVerification();
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyEmailScreen(email: _emailController.text.trim()),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Something went wrong';
      if (e.code == 'email-already-in-use') {
        message = 'This email is already registered';
      } else if (e.code == 'weak-password') {
        message = 'Password is too weak';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Center(child: Image.asset('assets/Checkmark.png', width: 80)),
                const SizedBox(height: 20),
                Text("Welcome to ",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 22, color: AppColors.textWhite)),
                Text("DO IT",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textWhite)),
                const SizedBox(height: 8),
                Text("Create an account and join us now!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textWhite70)),
                const SizedBox(height: 32),
                _buildTextField(
                  controller: _nameController,
                  icon: Icons.person,
                  hint: 'Name',
                  validator: (v) => v!.isEmpty ? 'Enter your name' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _emailController,
                  icon: Icons.email_outlined,
                  hint: 'E-mail',
                  validator: (v) {
                    if (v!.isEmpty) return 'Enter your email';
                    if (!EmailValidator.validate(v)) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _passwordController,
                  icon: Icons.lock_outline,
                  hint: 'Password',
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.iconGrey,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) {
                    if (v!.isEmpty) return 'Enter password';
                    if (v.length < 8 || !v.contains(RegExp(r'[A-Z]'))) {
                      return 'Password must be at least 8 chars and include a capital letter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _confirmPasswordController,
                  icon: Icons.lock,
                  hint: 'Confirm Password',
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.iconGrey,
                    ),
                    onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                  validator: (v) {
                    if (v!.isEmpty) return 'Confirm your password';
                    if (v != _passwordController.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _loading ? null : _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightBlueAccent,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: AppColors.textWhite)
                      : Text('Sign Up',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: AppColors.textWhite)),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ",
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.textWhite70)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text("Sign In",
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.lightBlueAccent)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: AppColors.textBlack),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.iconGrey),
        suffixIcon: suffixIcon,
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textGrey),
        filled: true,
        fillColor: AppColors.whiteBackground,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none),
      ),
      validator: validator,
    );
  }
}