// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// import 'package:do_it/views/auth/signin_page.dart';
//
// class VerifyEmailScreen extends StatefulWidget {
//   final String email;
//   const VerifyEmailScreen({super.key, required this.email});
//
//   @override
//   State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
// }
//
// class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
//   final TextEditingController _codeController = TextEditingController();
//   bool _isLoading = false;
//   bool _resendLoading = false;
//   int _resendSeconds = 0;
//   Timer? _timer;
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     _codeController.dispose();
//     super.dispose();
//   }
//
//   void _showMessage(String text) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
//   }
//
//   Future<void> _checkEmailVerified() async {
//     setState(() => _isLoading = true);
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         _showMessage("No user signed in. Please sign in again.");
//         return;
//       }
//
//       await user.reload();
//       user = FirebaseAuth.instance.currentUser;
//
//       if (user != null && user.emailVerified) {
//         _showMessage("Email verified! Redirecting...");
//         // Navigate to sign-in or home screen:
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const SignInScreen()),
//         );
//       } else {
//         _showMessage("Not verified yet. Please click the link in your email.");
//       }
//     } on FirebaseAuthException catch (e) {
//       _showMessage(e.message ?? "Error checking verification");
//     } catch (e) {
//       _showMessage("Error: $e");
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   /// If you extracted the oobCode from the verification link you can paste it here
//   /// and call applyActionCode(code) to complete verification.
//   Future<void> _applyActionCode() async {
//     final code = _codeController.text.trim();
//     if (code.isEmpty) {
//       _showMessage("Enter verification code (oobCode) or use the link and press 'I have clicked'.");
//       return;
//     }
//
//     setState(() => _isLoading = true);
//     try {
//       await FirebaseAuth.instance.applyActionCode(code);
//       // after applying action code, reload user
//       await FirebaseAuth.instance.currentUser?.reload();
//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null && user.emailVerified) {
//         _showMessage("Email verified successfully!");
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const SignInScreen()),
//         );
//       } else {
//         _showMessage("Code applied but verification not confirmed. Try 'I have clicked' button.");
//       }
//     } on FirebaseAuthException catch (e) {
//       _showMessage(e.message ?? "Failed to apply code");
//     } catch (e) {
//       _showMessage("Error: $e");
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   Future<void> _resendVerificationEmail() async {
//     if (_resendSeconds > 0) return;
//     setState(() => _resendLoading = true);
//
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         _showMessage("No signed-in user to resend for. Please sign in again.");
//         return;
//       }
//       await user.sendEmailVerification();
//       _showMessage("Verification email resent. Check your inbox.");
//       _startResendCooldown();
//     } on FirebaseAuthException catch (e) {
//       _showMessage(e.message ?? "Failed to resend");
//     } catch (e) {
//       _showMessage("Error: $e");
//     } finally {
//       setState(() => _resendLoading = false);
//     }
//   }
//
//   void _startResendCooldown() {
//     _timer?.cancel();
//     setState(() => _resendSeconds = 30);
//     _timer = Timer.periodic(const Duration(seconds: 1), (t) {
//       if (_resendSeconds <= 0) {
//         t.cancel();
//       } else {
//         setState(() => _resendSeconds -= 1);
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0D47A1),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const SizedBox(height: 20),
//               Center(
//                 child: Image.asset('assets/Checkmark.png', width: 80, height: 80),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 "Verify Your Email",
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.poppins(
//                   fontSize: 22,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 "A verification link was sent to:",
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
//               ),
//               const SizedBox(height: 6),
//               Text(
//                 widget.email,
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
//               ),
//               const SizedBox(height: 24),
//
//               // Code field (optional: paste oobCode from link)
//               TextFormField(
//                 controller: _codeController,
//                 style: const TextStyle(color: Colors.black),
//                 decoration: InputDecoration(
//                   prefixIcon: const Icon(Icons.verified_outlined),
//                   hintText: "Paste verification code (optional)",
//                   hintStyle: const TextStyle(color: Colors.grey),
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               ElevatedButton(
//                 onPressed: _isLoading ? null : _applyActionCode,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.lightBlueAccent,
//                   minimumSize: const Size.fromHeight(48),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 child: _isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : Text("Verify with Code", style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
//               ),
//               const SizedBox(height: 16),
//
//               // Check link (reload current user)
//               ElevatedButton(
//                 onPressed: _isLoading ? null : _checkEmailVerified,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.white,
//                   minimumSize: const Size.fromHeight(48),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 child: _isLoading
//                     ? const CircularProgressIndicator()
//                     : Text("I clicked the verification link — Check", style: GoogleFonts.poppins(fontSize: 14, color: Colors.blue)),
//               ),
//               const SizedBox(height: 12),
//
//               // Resend
//               TextButton(
//                 onPressed: (_resendSeconds > 0 || _resendLoading) ? null : _resendVerificationEmail,
//                 child: Text(
//                   _resendSeconds > 0 ? "Resend email ($_resendSeconds)" : "Resend verification email",
//                   style: GoogleFonts.poppins(color: Colors.white),
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               Center(
//                 child: TextButton(
//                   onPressed: () {
//                     // If user wants to go back to sign-in
//                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignInScreen()));
//                   },
//                   child: Text("Back to Sign In", style: GoogleFonts.poppins(color: Colors.white70)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:do_it/views/auth/signin_page.dart';
import '../../core/theme/app_colors.dart';
class VerifyEmailScreen extends StatefulWidget {
  final String email;
  const VerifyEmailScreen({super.key, required this.email});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;
  bool _resendLoading = false;
  int _resendSeconds = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _checkEmailVerified() async {
    setState(() => _isLoading = true);
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showMessage("No user signed in. Please sign in again.");
        return;
      }

      await user.reload();
      user = FirebaseAuth.instance.currentUser;

      if (user != null && user.emailVerified) {
        _showMessage("Email verified! Redirecting...");
        // Navigate to sign-in or home screen:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SignInScreen()),
        );
      } else {
        _showMessage("Not verified yet. Please click the link in your email.");
      }
    } on FirebaseAuthException catch (e) {
      _showMessage(e.message ?? "Error checking verification");
    } catch (e) {
      _showMessage("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _applyActionCode() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      _showMessage("Enter verification code (oobCode) or use the link and press 'I have clicked'.");
      return;
    }

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.applyActionCode(code);
      // after applying action code, reload user
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.emailVerified) {
        _showMessage("Email verified successfully!");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SignInScreen()),
        );
      } else {
        _showMessage("Code applied but verification not confirmed. Try 'I have clicked' button.");
      }
    } on FirebaseAuthException catch (e) {
      _showMessage(e.message ?? "Failed to apply code");
    } catch (e) {
      _showMessage("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _resendVerificationEmail() async {
    if (_resendSeconds > 0) return;
    setState(() => _resendLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showMessage("No signed-in user to resend for. Please sign in again.");
        return;
      }
      await user.sendEmailVerification();
      _showMessage("Verification email resent. Check your inbox.");
      _startResendCooldown();
    } on FirebaseAuthException catch (e) {
      _showMessage(e.message ?? "Failed to resend");
    } catch (e) {
      _showMessage("Error: $e");
    } finally {
      setState(() => _resendLoading = false);
    }
  }

  void _startResendCooldown() {
    _timer?.cancel();
    setState(() => _resendSeconds = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendSeconds <= 0) {
        t.cancel();
      } else {
        setState(() => _resendSeconds -= 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Image.asset('assets/Checkmark.png', width: 80, height: 80),
              ),
              const SizedBox(height: 20),
              Text(
                "Verify Your Email",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "A verification link was sent to:",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textWhite70),
              ),
              const SizedBox(height: 6),
              Text(
                widget.email,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textWhite),
              ),
              const SizedBox(height: 24),

              // Code field (optional: paste oobCode from link)
              TextFormField(
                controller: _codeController,
                style: const TextStyle(color: AppColors.textBlack),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.verified_outlined, color: AppColors.iconGrey),
                  hintText: "Paste verification code (optional)",
                  hintStyle: const TextStyle(color: AppColors.textGrey),
                  filled: true,
                  fillColor: AppColors.whiteBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: _isLoading ? null : _applyActionCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightBlueAccent,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: AppColors.textWhite)
                    : Text("Verify with Code", style: GoogleFonts.poppins(fontSize: 16, color: AppColors.textWhite)),
              ),
              const SizedBox(height: 16),

              // Check link (reload current user)
              ElevatedButton(
                onPressed: _isLoading ? null : _checkEmailVerified,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.whiteBackground,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: AppColors.primary)
                    : Text("I clicked the verification link — Check", style: GoogleFonts.poppins(fontSize: 14, color: AppColors.primary)),
              ),
              const SizedBox(height: 12),

              // Resend
              TextButton(
                onPressed: (_resendSeconds > 0 || _resendLoading) ? null : _resendVerificationEmail,
                child: Text(
                  _resendSeconds > 0 ? "Resend email ($_resendSeconds)" : "Resend verification email",
                  style: GoogleFonts.poppins(color: AppColors.textWhite),
                ),
              ),
              const SizedBox(height: 20),

              Center(
                child: TextButton(
                  onPressed: () {
                    // If user wants to go back to sign-in
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignInScreen()));
                  },
                  child: Text("Back to Sign In", style: GoogleFonts.poppins(color: AppColors.textWhite70)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}