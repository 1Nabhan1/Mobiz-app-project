import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../confg/appconfig.dart';

class Visiit extends StatefulWidget {
  static const routeName = "/Visiit";

  const Visiit({super.key});

  @override
  State<Visiit> createState() => _VisiitState();
}

class _VisiitState extends State<Visiit> {
  bool isSelected = true;
  void toggleSelection() {
    setState(() {
      isSelected = !isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          backgroundColor: AppConfig.colorPrimary,
          title: Text(
            'Attendance',
            style: TextStyle(color: AppConfig.backgroundColor),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "AR0034 | AL MADINA TRADING LLC | Bill to Bill\nJurf Industrial Area\nAjman\n+97156465476",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (!isSelected) {
                      toggleSelection();
                    }
                  },
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 100.0,
                      minHeight: 25.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: isSelected
                          ? AppConfig.colorPrimary
                          : Colors.transparent,
                      border: Border.all(
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Visit",
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (isSelected) {
                      toggleSelection();
                    }
                  },
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 100.0,
                      minHeight: 25.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: !isSelected
                          ? AppConfig.colorPrimary
                          : Colors.transparent,
                      border: Border.all(
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Non Visit",
                        style: TextStyle(
                          color: !isSelected ? Colors.white : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Reason"),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all()),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 100,
                      ),
                      child: Text("Select from list"),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Remarks"),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    height: 100,
                    width: 295,
                    decoration: BoxDecoration(border: Border.all()),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(AppConfig.colorPrimary),
                  shape: WidgetStatePropertyAll(BeveledRectangleBorder()),
                  minimumSize: WidgetStateProperty.all(Size(70, 30)),
                ),
                onPressed: () {},
                child: SizedBox(
                  width: 120,
                  child: Center(
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),

            ),
          ],
        ),
      ),
    );
  }
}