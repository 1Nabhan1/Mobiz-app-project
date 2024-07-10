import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../confg/appconfig.dart';

class VanTransfer extends StatefulWidget {
  static const routeName = "/VanTransfer";

  const VanTransfer({super.key});

  @override
  State<VanTransfer> createState() => _VanTransferState();
}

class _VanTransferState extends State<VanTransfer> {
  int _selectedValue = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppConfig.colorPrimary,
        title: const Text(
          'Van Transfer Request',
          style: TextStyle(color: AppConfig.backgroundColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.deepPurple.shade100
                    // Color(0xFF4B58AC),
                    ),
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Transform.flip(
                            flipX: true,
                            child: Image.asset(
                              'Assets/Images/van stock.png',
                              width: 60,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'D 87550',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppConfig.colorPrimary),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.person,
                            size: 30,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'SHAKKIR P P',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppConfig.colorPrimary),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    CupertinoIcons.arrow_right_arrow_left,
                    color: AppConfig.backgroundColor,
                  ),
                ),
                decoration: BoxDecoration(
                    color: AppConfig.colorPrimary,
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Row(
                              children: <Widget>[
                                Row(
                                  children: [
                                    Radio(
                                      value: 1,
                                      groupValue: _selectedValue,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedValue = value!;
                                        });
                                      },
                                    ),
                                    Text('N 87395'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Radio(
                                      value: 2,
                                      groupValue: _selectedValue,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedValue = value!;
                                        });
                                      },
                                    ),
                                    Text('N 87395'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Radio(
                                      value: 3,
                                      groupValue: _selectedValue,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedValue = value!;
                                        });
                                      },
                                    ),
                                    Text('N 87395'),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: 4,
                                  groupValue: _selectedValue,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedValue = value!;
                                    });
                                  },
                                ),
                                Text('N 87395'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'Assets/Images/van stock.png',
                                width: 60,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'A 23301',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppConfig.colorPrimary),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                CupertinoIcons.person,
                                size: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'MAHAMOOD KHAN',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppConfig.colorPrimary),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: Text(
                'Stock Detail',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Container(
              width: double.infinity,
              height: 400,
              color: Colors.grey.shade200,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              child: Text(
                'Remarks',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppConfig.colorPrimary),
                  onPressed: () {},
                  child: Text(
                    'TRANSFER',
                    style: TextStyle(color: AppConfig.backgroundColor),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
