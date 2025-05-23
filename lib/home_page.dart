import 'package:animated_text_kit/animated_text_kit.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:health/monitoring_page.dart';
import 'package:health/login_page.dart';

class hame_page extends StatelessWidget {
  const hame_page({super.key});
 Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      // Navigate to login page after sign out
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error signing out: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color.fromRGBO(79, 137, 113, 1),
      appBar: AppBar(
          leading: IconButton(
    onPressed: () => _signOut(context),
    

    icon: Icon(Icons.logout_sharp),
  ),
  
        backgroundColor: Color.fromRGBO(217, 217, 217, 1),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.only( left: 15, right: 15, top:30),
            child: Column(
              
              children: [
               Container(
                height: 200,
                width: 200,
                child: Image.asset('assets/image1.png')),
              
                SizedBox(
                  height:25 ,
                ),
                Text('Welcome ', 
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.w400
                ),), 
                SizedBox(
                   height: 25,),
                   Container(
                    padding: const EdgeInsets.only(left: 25,right: 25),
                      width: double.infinity,
                      height: 100,
                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(backgroundColor:const Color.fromARGB(47, 61, 96, 62)),
                        onPressed: () {
                            Navigator.push(
                             context,
                               MaterialPageRoute(builder: (context) =>  HealthMonitor()),
                            );

                        },
                        child: const Text('Monitoring',
                        style: TextStyle(
                          fontSize: 45,
                          color: Colors.white, fontWeight: FontWeight.w400
                        ),
        
                        ),
                      ),
                    ),
                    SizedBox(
                   height: 25,),
                  
                    Container(
                      padding:  const EdgeInsets.only(left: 25,right: 25),
                      child: Column(
                        children: [
                          AnimatedTextKit(animatedTexts: [TyperAnimatedText("WARNING",
                                         textStyle: TextStyle(
                                          fontSize: 40,fontWeight: FontWeight.w400,
                                          color: Colors.red
                                         )  )
                                          ],),
                                Text("When you do heavy work  run this test after FIVE minutes of rest",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white
                                ),  ),
                        ],
                      ),
                    )
              ],
            ),
          ),),
      ),
    );
  }
}