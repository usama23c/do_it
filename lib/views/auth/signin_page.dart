// //
// // import 'package:do_it/views/auth/signup_page.dart';
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:email_validator/email_validator.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import '../../widgets/main_widget.dart';
// //
// // class SignInScreen extends StatefulWidget {
// //   const SignInScreen({super.key});
// //
// //   @override
// //   _SignInScreenState createState() => _SignInScreenState();
// // }
// //
// // class _SignInScreenState extends State<SignInScreen> {
// //   final _emailController = TextEditingController();
// //   final _passwordController = TextEditingController();
// //   final _formKey = GlobalKey<FormState>();
// //
// //   bool _obscurePassword = true;
// //   bool _loading = false;
// //
// //   Future<void> _signIn() async {
// //     if (!_formKey.currentState!.validate()) return;
// //
// //     setState(() => _loading = true);
// //
// //     try {
// //       UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
// //         email: _emailController.text.trim(),
// //         password: _passwordController.text.trim(),
// //       );
// //
// //       SharedPreferences prefs = await SharedPreferences.getInstance();
// //       await prefs.setBool('isLoggedIn', true);
// //
// //       String uid = userCredential.user!.uid;
// //       DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
// //
// //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainScreen()));
// //     } on FirebaseAuthException catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text(e.message ?? 'Login failed')),
// //       );
// //     } finally {
// //       setState(() => _loading = false);
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Container(
// //         decoration: const BoxDecoration(
// //           gradient: LinearGradient(
// //             colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
// //             begin: Alignment.topLeft,
// //             end: Alignment.bottomRight,
// //           ),
// //         ),
// //         child: SafeArea(
// //           child: Center(
// //             child: ConstrainedBox(
// //               constraints: const BoxConstraints(maxWidth: 400),
// //               child: SingleChildScrollView(
// //                 padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
// //                 child: Form(
// //                   key: _formKey,
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.stretch,
// //                     children: [
// //                       const SizedBox(height: 20),
// //                       Center(child: Image.asset('assets/Checkmark.png', width: 80)),
// //                       const SizedBox(height: 20),
// //                       Text("Welcome Back to ",
// //                           textAlign: TextAlign.center,
// //                           style: GoogleFonts.poppins(fontSize: 22, color: Colors.white)),
// //                       Text("DO IT",
// //                           textAlign: TextAlign.center,
// //                           style: GoogleFonts.poppins(
// //                               fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
// //                       const SizedBox(height: 8),
// //                       Text("Have another productive day!",
// //                           textAlign: TextAlign.center,
// //                           style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70)),
// //                       const SizedBox(height: 32),
// //                       _buildTextField(
// //                         controller: _emailController,
// //                         icon: Icons.email_outlined,
// //                         hint: 'E-mail',
// //                         validator: (value) {
// //                           if (value == null || value.isEmpty) return 'Please enter your email';
// //                           if (!EmailValidator.validate(value)) return 'Enter valid email';
// //                           return null;
// //                         },
// //                       ),
// //                       const SizedBox(height: 16),
// //                       _buildTextField(
// //                         controller: _passwordController,
// //                         icon: Icons.lock_outline,
// //                         hint: 'Password',
// //                         obscureText: _obscurePassword,
// //                         suffixIcon: IconButton(
// //                           icon: Icon(
// //                             _obscurePassword ? Icons.visibility_off : Icons.visibility,
// //                             color: Colors.grey[700],
// //                           ),
// //                           onPressed: () {
// //                             setState(() => _obscurePassword = !_obscurePassword);
// //                           },
// //                         ),
// //                         validator: (value) {
// //                           if (value == null || value.isEmpty) return 'Enter password';
// //                           return null;
// //                         },
// //                       ),
// //                       const SizedBox(height: 10),
// //                       Align(
// //                         alignment: Alignment.centerRight,
// //                         child: Text(
// //                           "Forget password?",
// //                           style: GoogleFonts.poppins(
// //                               fontSize: 12,
// //                               color: Colors.lightBlueAccent,
// //                               decoration: TextDecoration.underline),
// //                         ),
// //                       ),
// //                       const SizedBox(height: 20),
// //                       ElevatedButton(
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: Colors.lightBlueAccent,
// //                           minimumSize: const Size.fromHeight(48),
// //                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
// //                         ),
// //                         onPressed: _loading ? null : _signIn,
// //                         child: _loading
// //                             ? const CircularProgressIndicator(color: Colors.white)
// //                             : Text('Sign In',
// //                             style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
// //                       ),
// //                       const SizedBox(height: 16),
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         children: [
// //                           Text("Don’t have an account? ",
// //                               style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70)),
// //                           GestureDetector(
// //                             onTap: () => Navigator.push(
// //                                 context, MaterialPageRoute(builder: (_) => const SignupScreen())),
// //                             child: Text("Sign up",
// //                                 style: GoogleFonts.poppins(
// //                                     fontSize: 12,
// //                                     color: Colors.lightBlueAccent,
// //                                     fontWeight: FontWeight.bold)),
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildTextField({
// //     required TextEditingController controller,
// //     required IconData icon,
// //     required String hint,
// //     bool obscureText = false,
// //     String? Function(String?)? validator,
// //     Widget? suffixIcon,
// //   }) {
// //     return TextFormField(
// //       controller: controller,
// //       obscureText: obscureText,
// //       style: const TextStyle(color: Colors.black),
// //       decoration: InputDecoration(
// //         prefixIcon: Icon(icon, color: Colors.grey[700]),
// //         suffixIcon: suffixIcon,
// //         hintText: hint,
// //         hintStyle: const TextStyle(color: Colors.grey),
// //         filled: true,
// //         fillColor: Colors.white,
// //         border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
// //       ),
// //       validator: validator,
// //     );
// //   }
// // }
// import 'package:do_it/views/auth/signup_page.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:email_validator/email_validator.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import '../../widgets/main_widget.dart';
//
// class SignInScreen extends StatefulWidget {
//   const SignInScreen({super.key});
//
//   @override
//   _SignInScreenState createState() => _SignInScreenState();
// }
//
// class _SignInScreenState extends State<SignInScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   bool _obscurePassword = true;
//   bool _loading = false;
//   bool _googleLoading = false;
//
//   Future<void> _signIn() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => _loading = true);
//
//     try {
//       UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );
//
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('isLoggedIn', true);
//
//       String uid = userCredential.user!.uid;
//       await FirebaseFirestore.instance.collection('users').doc(uid).get();
//
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainScreen()));
//     } on FirebaseAuthException catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.message ?? 'Login failed')),
//       );
//     } finally {
//       setState(() => _loading = false);
//     }
//   }
//
//   Future<void> _signInWithGoogle() async {
//     setState(() => _googleLoading = true);
//
//     try {
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//       if (googleUser == null) {
//         setState(() => _googleLoading = false);
//         return; // User canceled sign in
//       }
//
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//
//       UserCredential userCredential =
//       await FirebaseAuth.instance.signInWithCredential(credential);
//
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('isLoggedIn', true);
//
//       String uid = userCredential.user!.uid;
//       DocumentSnapshot userDoc =
//       await FirebaseFirestore.instance.collection('users').doc(uid).get();
//
//       // Create user in Firestore if doesn't exist
//       if (!userDoc.exists) {
//         await FirebaseFirestore.instance.collection('users').doc(uid).set({
//           'email': userCredential.user!.email,
//           'name': userCredential.user!.displayName,
//           'photoUrl': userCredential.user!.photoURL,
//           'createdAt': DateTime.now(),
//         });
//       }
//
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainScreen()));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Google sign-in failed: $e')),
//       );
//     } finally {
//       setState(() => _googleLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: SafeArea(
//           child: Center(
//             child: ConstrainedBox(
//               constraints: const BoxConstraints(maxWidth: 400),
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       const SizedBox(height: 20),
//                       Center(child: Image.asset('assets/Checkmark.png', width: 80)),
//                       const SizedBox(height: 20),
//                       Text("Welcome Back to ",
//                           textAlign: TextAlign.center,
//                           style: GoogleFonts.poppins(fontSize: 22, color: Colors.white)),
//                       Text("DO IT",
//                           textAlign: TextAlign.center,
//                           style: GoogleFonts.poppins(
//                               fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 8),
//                       Text("Have another productive day!",
//                           textAlign: TextAlign.center,
//                           style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70)),
//                       const SizedBox(height: 32),
//                       _buildTextField(
//                         controller: _emailController,
//                         icon: Icons.email_outlined,
//                         hint: 'E-mail',
//                         validator: (value) {
//                           if (value == null || value.isEmpty) return 'Please enter your email';
//                           if (!EmailValidator.validate(value)) return 'Enter valid email';
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextField(
//                         controller: _passwordController,
//                         icon: Icons.lock_outline,
//                         hint: 'Password',
//                         obscureText: _obscurePassword,
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _obscurePassword ? Icons.visibility_off : Icons.visibility,
//                             color: Colors.grey[700],
//                           ),
//                           onPressed: () {
//                             setState(() => _obscurePassword = !_obscurePassword);
//                           },
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) return 'Enter password';
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 10),
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: Text(
//                           "Forget password?",
//                           style: GoogleFonts.poppins(
//                               fontSize: 12,
//                               color: Colors.lightBlueAccent,
//                               decoration: TextDecoration.underline),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.lightBlueAccent,
//                           minimumSize: const Size.fromHeight(48),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                         ),
//                         onPressed: _loading ? null : _signIn,
//                         child: _loading
//                             ? const CircularProgressIndicator(color: Colors.white)
//                             : Text('Sign In',
//                             style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
//                       ),
//                       const SizedBox(height: 20),
//
//                       // Google Sign In Button
//                       OutlinedButton.icon(
//                         icon: _googleLoading
//                             ? const SizedBox(
//                             height: 18, width: 18,
//                             child: CircularProgressIndicator(strokeWidth: 2))
//                             : Image.asset('assets/google.png', height: 18),
//                         label: Text(
//                           _googleLoading ? "Signing in..." : "Sign in with Google",
//                           style: GoogleFonts.poppins(color: Colors.white),
//                         ),
//                         style: OutlinedButton.styleFrom(
//                           backgroundColor: Colors.redAccent,
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                           minimumSize: const Size.fromHeight(48),
//                         ),
//                         onPressed: _googleLoading ? null : _signInWithGoogle,
//                       ),
//
//                       const SizedBox(height: 16),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text("Don’t have an account? ",
//                               style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70)),
//                           GestureDetector(
//                             onTap: () => Navigator.push(
//                                 context, MaterialPageRoute(builder: (_) => const SignupScreen())),
//                             child: Text("Sign up",
//                                 style: GoogleFonts.poppins(
//                                     fontSize: 12,
//                                     color: Colors.lightBlueAccent,
//                                     fontWeight: FontWeight.bold)),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
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
//     String? Function(String?)? validator,
//     Widget? suffixIcon,
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
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
//       ),
//       validator: validator,
//     );
//   }
// }
// lib/views/auth/sign_in_screen.dart
import 'package:do_it/views/auth/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/main_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _loading = false;
  bool _googleLoading = false;

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      String uid = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).get();

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainScreen()));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Login failed')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _googleLoading = true);

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _googleLoading = false);
        return; // User canceled sign in
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      String uid = userCredential.user!.uid;
      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();

      // Create user in Firestore if doesn't exist
      if (!userDoc.exists) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'email': userCredential.user!.email,
          'name': userCredential.user!.displayName,
          'photoUrl': userCredential.user!.photoURL,
          'createdAt': DateTime.now(),
        });
      }

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign-in failed: $e')),
      );
    } finally {
      setState(() => _googleLoading = false);
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
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
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
                      Text("Welcome Back to ",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 22, color: AppColors.textWhite)),
                      Text("DO IT",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 22, color: AppColors.textWhite, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text("Have another productive day!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textWhite70)),
                      const SizedBox(height: 32),
                      _buildTextField(
                        controller: _emailController,
                        icon: Icons.email_outlined,
                        hint: 'E-mail',
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter your email';
                          if (!EmailValidator.validate(value)) return 'Enter valid email';
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
                          onPressed: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Enter password';
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Forget password?",
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.lightBlueAccent,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lightBlueAccent,
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed: _loading ? null : _signIn,
                        child: _loading
                            ? const CircularProgressIndicator(color: AppColors.textWhite)
                            : Text('Sign In',
                            style: GoogleFonts.poppins(fontSize: 16, color: AppColors.textWhite)),
                      ),
                      const SizedBox(height: 20),
                      // Google Sign In Button
                      OutlinedButton.icon(
                        icon: _googleLoading
                            ? const SizedBox(
                            height: 18, width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2))
                            : Image.asset('assets/google.png', height: 18),
                        label: Text(
                          _googleLoading ? "Signing in..." : "Sign in with Google",
                          style: GoogleFonts.poppins(color: AppColors.textWhite),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.googleButton,
                          foregroundColor: AppColors.textWhite,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          minimumSize: const Size.fromHeight(48),
                        ),
                        onPressed: _googleLoading ? null : _signInWithGoogle,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account? ",
                              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textWhite70)),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context, MaterialPageRoute(builder: (_) => const SignupScreen())),
                            child: Text("Sign up",
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppColors.lightBlueAccent,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
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
    String? Function(String?)? validator,
    Widget? suffixIcon,
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
      ),
      validator: validator,
    );
  }
}