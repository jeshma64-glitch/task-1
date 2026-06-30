import 'package:car/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'main.dart';
import 'main_shell.dart';
import 'providers/auth_provider.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {

  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(

      create: (context)=>AuthProvider(),

      child: MaterialApp(

        debugShowCheckedModeBanner:false,

        theme:ThemeData(

          textTheme:GoogleFonts.poppinsTextTheme(),

        ),

        home:const LoginPage(),

      ),

    );

  }

}



class LoginPage extends StatefulWidget {

  const LoginPage({super.key});


  @override
  State<LoginPage> createState()=>_LoginPageState();

}



class _LoginPageState extends State<LoginPage>{


  final _formKey = GlobalKey<FormState>();


  final emailPhoneController = TextEditingController();

  final passwordController = TextEditingController();



  Future<void> login() async {

    if(!_formKey.currentState!.validate()){
      return;
    }


    bool result = await Provider.of<AuthProvider>(
      context,
      listen:false,
    ).login(
      emailPhoneController.text.trim(),
      passwordController.text.trim(),
    );


    if(result) {
      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content: Text(
            "Login Successful",
            textAlign: TextAlign.center,
          ),
        ),

      );


      // GO TO HOME PAGE AFTER LOGIN


      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const MainShell()));
    }
    else{


      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content:Text(
              "Invalid Email or Password"
          ),

        ),

      );


    }


  }





  bool isEmail(String value)=>

      RegExp(r'^[a-z0-9]+@gmail\.com$')

          .hasMatch(value);




  bool isStrongPassword(String value) {
    return RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).+$',
    ).hasMatch(value);
  }






  @override

  Widget build(BuildContext context){



    final size=MediaQuery.of(context).size;



    double cardWidth=size.width<500

        ?size.width*.88

        :size.width<1100?450:500;



    return Scaffold(



      body:Stack(


        children:[



          Positioned.fill(

            child:Image.asset(

              "assets/images/carr.png",

              fit:BoxFit.cover,

            ),

          ),




          Positioned.fill(

            child:Container(

              color:Colors.black.withOpacity(.55),

            ),

          ),





          Center(


            child:SingleChildScrollView(


              physics:const BouncingScrollPhysics(),


              child:Container(


                width:cardWidth,


                margin:const EdgeInsets.all(20),


                padding:EdgeInsets.all(

                    size.width<500?25:40

                ),



                decoration:BoxDecoration(


                  color:Colors.black.withOpacity(.6),


                  borderRadius:BorderRadius.circular(25),


                ),




                child:Form(


                  key:_formKey,


                  child:Column(


                    mainAxisSize:MainAxisSize.min,


                    children:[



                      Text(

                        "LUXURY GARAGE",

                        style:GoogleFonts.poppins(

                          color:Color(0xFFFFD700),

                          fontSize:30,

                          fontWeight:FontWeight.bold,

                        ),

                      ),



                      const SizedBox(height:10),



                      Text(

                        "Premium Car Service & Maintenance",

                        style:GoogleFonts.poppins(

                          color:Colors.white70,

                        ),

                      ),



                      const SizedBox(height:35),





                      TextFormField(

                        controller:emailPhoneController,

                        style:const TextStyle(color:Colors.white),

                        decoration:inputDecoration(

                            "Enter email",

                            Icons.email_outlined

                        ),



                        validator:(value){


                          if(value==null||value.isEmpty){

                            return "Enter Email";

                          }


                          if(!isEmail(value)){

                            return "Enter valid gmail";

                          }


                          return null;


                        },

                      ),




                      const SizedBox(height:20),




                      TextFormField(


                        controller:passwordController,

                        obscureText:true,

                        style:const TextStyle(color:Colors.white),


                        decoration:inputDecoration(

                            "Password",

                            Icons.lock_outline

                        ),



                        validator:(value){

                          if(value==null||value.isEmpty){

                            return "Enter Password";

                          }


                          if(!isStrongPassword(value)){

                            return "Password must contain capital, small, number & symbol";

                          }


                          return null;


                        },


                      ),




                      Align(

                        alignment:Alignment.centerRight,

                        child:TextButton(

                          onPressed:(){},

                          child:const Text(

                            "Forgot Password?",

                            style:TextStyle(

                              color:Color(0xFFFFD700),

                            ),

                          ),

                        ),

                      ),




                      const SizedBox(height:15),




                      SizedBox(

                        width:double.infinity,

                        height:55,


                        child:ElevatedButton(

                          onPressed: login,


                          style:ElevatedButton.styleFrom(

                            backgroundColor:Color(0xFFFFD700),

                            shape:RoundedRectangleBorder(

                                borderRadius:BorderRadius.circular(15)

                            ),

                          ),



                          child:Text(

                            "LOGIN",

                            style:GoogleFonts.poppins(

                              color:Colors.black,

                              fontWeight:FontWeight.bold,

                              fontSize:18,

                            ),

                          ),


                        ),


                      ),





                      const SizedBox(height:25),




                      Row(

                        mainAxisAlignment:MainAxisAlignment.center,

                        children:[


                          const Text(

                            "Don't have an account? ",

                            style:TextStyle(

                              color:Colors.white70,

                            ),

                          ),



                          TextButton(

                            onPressed:(){
                              // NAVIGATION ADDED HERE
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const RegisterPage()),
                              );
                            },


                            child:const Text(

                              "Sign Up",

                              style:TextStyle(

                                color:Color(0xFFFFD700),

                                fontWeight:FontWeight.bold,

                                decoration:TextDecoration.underline,

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






  InputDecoration inputDecoration(String hint,IconData icon){


    return InputDecoration(


      hintText:hint,


      hintStyle:const TextStyle(

          color:Colors.white60

      ),


      prefixIcon:Icon(

        icon,

        color:Color(0xFFFFD700),

      ),


      filled:true,


      fillColor:Colors.white.withOpacity(.08),



      border:OutlineInputBorder(

        borderRadius:BorderRadius.circular(15),

        borderSide:BorderSide.none,

      ),


    );


  }



}