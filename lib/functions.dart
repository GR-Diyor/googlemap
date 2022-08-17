import 'package:flutter/material.dart';

About(BuildContext context){
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Dastu haqida"),
          content: Text(txt(),
            style: const TextStyle(fontSize: 12, color: Colors.black26,fontStyle: FontStyle.italic),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("ok"),),
          ],
        );
      }
  );
}

String txt(){
  return
    "Dastur Nizomiddinov Diyorbekning 'Google Maps'ni o'rganishi davomida yaratilgan dastur.\n"
        "Dasturda turli xildagi xatoliklar yuzaga kelishi mumkin.";
}