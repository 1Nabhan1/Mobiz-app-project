import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../Models/appstate.dart';
import '../confg/appconfig.dart';
import 'homepage.dart';
import 'homepage_Driver.dart';

class ErrorHandlingScreen extends StatefulWidget {
  static const routeName = "/ErrorHandlingScreen";

  const ErrorHandlingScreen({super.key});

  @override
  State<ErrorHandlingScreen> createState() => _ErrorHandlingScreenState();
}

class _ErrorHandlingScreenState extends State<ErrorHandlingScreen> {
  late Future<void> _loadRole;

  @override
  void initState() {
    super.initState();
    _loadRole = _getRoleId();
  }

  Future<void> _getRoleId() async {
    await Future.delayed(Duration(seconds: 3)); // Simulate loading delay
    while (AppState().rolId == null) {
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  void _navigateBasedOnRole() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (AppState().rolId == 2 || AppState().rolId == 5) {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        }
      } else if (AppState().rolId == 4) {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(HomepageDriver.routeName);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<void>(
          future: _loadRole,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingScreen();
            } else {
              _navigateBasedOnRole();
              return Container(); // Empty container as the screen will navigate away
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.white,
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
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Expanded(
              child: GridView.builder(
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
