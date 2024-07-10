import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../confg/appconfig.dart';
import 'homepage.dart';

class ErrorHandlingScreen extends StatefulWidget {
  static const routeName = "/ErrorHandlingScreen";

  const ErrorHandlingScreen({super.key});

  @override
  State<ErrorHandlingScreen> createState() => _ErrorHandlingScreenState();
}

class _ErrorHandlingScreenState extends State<ErrorHandlingScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 2),
      () {
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Shimmer.fromColors(
              child: Padding(
                padding: const EdgeInsets.all(35.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 70,
                    ),
                    Container(
                      width: 100,
                      height: 110,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    GridView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: 12,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisExtent: 120,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 30,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade200,
                          ),
                          // width: 30,
                        );
                      },
                    ),
                  ],
                ),
              ),
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.white)),
    );
  }
}
