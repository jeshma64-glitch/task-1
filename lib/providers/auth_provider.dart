import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class AuthProvider extends ChangeNotifier {


  String? name;
  String? email;
  String? token;



  // ================= LOGIN API =================

  Future<bool> login(String email, String password) async {


    try {


      var response = await http.post(

        Uri.parse(
          "http://dev-carservice.dextragroups.com/api/login",
        ),


        headers: {


          "Accept": "application/json",


          "Content-Type": "application/json",


        },


        body: jsonEncode({


          "email": email,


          "password": password,


        }),


      );



      print("LOGIN STATUS CODE:");
      print(response.statusCode);


      print("LOGIN API RESPONSE:");
      print(response.body);




      if(response.statusCode == 200){


        var data = jsonDecode(response.body);



        if(data["user"] != null){


          name = data["user"]["name"];


          this.email = data["user"]["email"];


        }




        if(data["token"] != null){


          token = data["token"];


        }




        notifyListeners();


        return true;


      }



      return false;



    }

    catch(e){


      print("LOGIN ERROR: $e");


      return false;


    }


  }







  // ================= REGISTER API =================


  Future<bool> register(

      String name,

      String email,

      String phone,

      String password,

      String role,

      ) async {



    try {



      var response = await http.post(



        Uri.parse(

          "http://dev-carservice.dextragroups.com/api/register",

        ),




        headers: {



          "Accept": "application/json",


          "Content-Type": "application/json",



        },




        body: jsonEncode({



          "name": name,


          "email": email,


          "phone": phone,


          "password": password,


          "role": role,



        }),




      );






      print("REGISTER STATUS CODE:");

      print(response.statusCode);




      print("REGISTER API RESPONSE:");

      print(response.body);






      if(response.statusCode == 200 ||

          response.statusCode == 201){



        return true;



      }




      return false;




    }


    catch(e){



      print("REGISTER ERROR: $e");



      return false;



    }




  }



}