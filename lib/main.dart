import 'package:car/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'providers/auth_provider.dart';


void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegisterPage(),
        ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  String? selectedRole;

  // State state for toggling password visibility
  bool _obscurePassword = true;

  bool isStrongPassword(String value) {
    return RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).+$',
    ).hasMatch(value);
  }

  Future<void> register() async {


    if(!_formKey.currentState!.validate()){

      return;

    }


    bool result = await Provider.of<AuthProvider>(

      context,

      listen:false,

    ).register(

      nameController.text.trim(),

      emailController.text.trim(),

      phoneController.text.trim(),

      passwordController.text.trim(),

      selectedRole!,

    );


    if(result){


      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content: Text(
              "Registration Successful"
          ),

        ),

      );


      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder:(context)=> const LoginPage(),

        ),

      );


    }

    else{


      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content: Text(
              "Registration Failed"
          ),

        ),

      );


    }




      // Navigate to Login Page if needed
      // Navigator.pop(context);

}

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    double cardWidth = size.width < 500
        ? size.width * .88
        : (size.width < 1100 ? 450 : 500);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/images/carr.png",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: Colors.black),
            ),
          ),

          // Dark Overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(.55),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                vertical: size.height * .05,
              ),
              child: Container(
                width: cardWidth,
                padding: EdgeInsets.all(
                  size.width < 500 ? 25 : 40,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.6),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white10,
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "CREATE ACCOUNT",
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFFFD700),
                          fontSize: size.width < 500 ? 24 : 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Join Luxury Garage Today",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: size.width < 500 ? 11 : 14,
                        ),
                      ),

                      const SizedBox(height: 35),

                      // Name Field
                      TextFormField(
                        controller: nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: inputDecoration(
                          hint: "Full Name",
                          icon: Icons.person_outline,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Enter your name";
                          }

                          if (!RegExp(r'^[A-Za-z ]+$').hasMatch(value)) {
                            return "Only letters and spaces allowed";
                          }

                          if (value.trim().length < 3) {
                            return "Name must be at least 3 characters";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Email Field
                      TextFormField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: inputDecoration(
                          hint: "Email Address",
                          icon: Icons.email_outlined,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter Email";
                          }

                          if (value != value.toLowerCase()) {
                            return "Email must not contain uppercase";
                          }

                          if (!value.contains('@')) {
                            return "Enter valid gmail";
                          }

                          String username = value.split('@')[0];

                          if (RegExp(r'^[0-9]+$').hasMatch(username)) {
                            return "Email cannot be only numbers";
                          }

                          if (!RegExp(r'^[a-z0-9]+$').hasMatch(username)) {
                            return "Only lowercase letters & numbers allowed";
                          }

                          if (!RegExp(r'^[a-z0-9]+@gmail\.com$').hasMatch(value)) {
                            return "Enter valid gmail";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Phone Field
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        style: const TextStyle(color: Colors.white),
                        decoration: inputDecoration(
                          hint: "Phone Number",
                          icon: Icons.phone_outlined,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Enter Phone Number";
                          }
                          // Validates standard 10 digit number. Adjust regex if needed.
                          if (!RegExp(r'^[0-9]{10}$').hasMatch(value.trim())) {
                            return "Enter a valid 10-digit phone number";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Password Field
                      const SizedBox(height: 20),


                      DropdownButtonFormField<String>(

                        value: selectedRole,

                        dropdownColor: Colors.black87,

                        style: const TextStyle(
                          color: Colors.white,
                        ),

                        hint: const Text(
                          "Select Role",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),

                        decoration: inputDecoration(
                          hint: "",
                          icon: Icons.work_outline,
                        ),

                        items: const [

                          DropdownMenuItem(

                            value: "user",

                            child: Text(
                              "User",
                              style: TextStyle(color: Colors.white),
                            ),

                          ),


                          DropdownMenuItem(

                            value: "technician",

                            child: Text(
                              "Technician",
                              style: TextStyle(color: Colors.white),
                            ),

                          ),


                          DropdownMenuItem(

                            value: "mechanic",

                            child: Text(
                              "Mechanic",
                              style: TextStyle(color: Colors.white),
                            ),

                          ),

                        ],


                        onChanged: (value){

                          setState(() {

                            selectedRole = value;

                          });

                        },


                        validator: (value){

                          if(value == null){

                            return "Select your role";

                          }

                          return null;

                        },

                      ),


                      const SizedBox(height: 20),


// Password Field
                      TextFormField(
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(color: Colors.white),
                        decoration: inputDecoration(
                          hint: "Password",
                          icon: Icons.lock_outline,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: const Color(0xFFFFD700),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter Password";
                          }

                          if (!isStrongPassword(value)) {
                            return "Password must contain capital, small, number & symbol";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 30),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFFD700),
                                  Color(0xFFB8860B),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                "REGISTER",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigates back to the Login Page (main.dart)
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginPage()),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: Color(0xFFFFD700),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Refactored helper method to accept an optional suffix icon
  InputDecoration inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.white60,
      ),
      prefixIcon: Icon(
        icon,
        color: const Color(0xFFFFD700),
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white.withOpacity(.08),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 15,
      ),
    );
  }
}