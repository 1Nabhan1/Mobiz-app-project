import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobizapp/Models/appstate.dart';
import 'package:mobizapp/Pages/homepage.dart';
import 'package:mobizapp/Utilities/rest_ds.dart';
import 'package:mobizapp/confg/appconfig.dart';
import 'package:http/http.dart'as http;
import 'package:mobizapp/confg/sizeconfig.dart';

class ChequeCollectionPage extends StatefulWidget {
  static const routeName = "/ChequeCollection";
  @override
  State<ChequeCollectionPage> createState() => _ChequeCollectionPageState();
}

class _ChequeCollectionPageState extends State<ChequeCollectionPage> {
  List<String> groupNames = [];
  String? selectedGroup;
  int?selectedId;
  List<int> groupIds = [];
  String selectedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
  String collectionType = 'Cheque';
  TextEditingController bankController = TextEditingController();
  TextEditingController chequeNoController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();


  @override
  void initState() {
    super.initState();
    fetchGroups();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Default to current date
      firstDate: DateTime(2000), // Earliest date
      lastDate: DateTime(2100), // Latest date
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate =
            DateFormat('dd-MMM-yyyy').format(pickedDate); // Format the selected date
      });
    }
  }


  Future<void> fetchGroups() async {
    final url = Uri.parse('${RestDatasource().BASE_URL}/api/get_group?store_id=${AppState().storeId}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            groupIds = List<int>.from(data['data'].map((group) => group['id']));
            groupNames = List<String>.from(data['data'].map((group) => group['name']));
          });
        }
      }
    } catch (e) {print(e);}
  }


  Future<void> saveChequeCollection() async {
    if (selectedId == null || bankController.text.isEmpty || chequeNoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final url = Uri.parse('${RestDatasource().BASE_URL}/api/check_group_post');
    final body = {
      "customer_group_id": selectedId,
      "collection_type": "Cheque",
      "cheque_date": selectedDate,
      "bank": bankController.text,
      "amount":amountController.text,
      "cheque_no": chequeNoController.text,
      "description": descriptionController.text,
      "van_id": AppState().vanId,
      "store_id":AppState().storeId,
      "user_id": AppState().userId,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        print("Data: $body");
        print("Body: ${response.body}");
        print("Bosssssdy: ${amountController.text}");
        final data = json.decode(response.body);
        if (data['success'] == true) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Success'),
                content: const Text('Cheque collection saved successfully!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName); // Navigate to the home screen
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Show error snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Something went wrong')),
          );
        }
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save cheque collection')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cheque Collection',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppConfig.colorPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Group Customer Dropdown
              const Text(
                'Group Customer',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                items: groupNames
                    .map((name) => DropdownMenuItem(
                  value: name,
                  child: Text(name),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGroup = value;
                    selectedId = groupIds[groupNames.indexOf(value!)];
                  });
                  print(selectedId);
                },
                value: selectedGroup,
                hint: Text('Select Group Customer Name'),
              ),
              const SizedBox(height: 20),

              // Form Fields
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Collection Type Dropdown
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Amount',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: SizeConfig.blockSizeHorizontal*8,),
                                  Container(
                                    width: SizeConfig.blockSizeHorizontal*20,
                                    child: TextField(
                                      controller: amountController,
                                      readOnly: true, // Make the TextField non-editable directly
                                      onTap: () async {
                                        String? result = await showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            String tempValue = amountController.text;

                                            return AlertDialog(
                                              title: const Text('Enter Amount'),
                                              content: TextField(
                                                keyboardType: TextInputType.number,
                                                controller: TextEditingController(text: tempValue), // Set initial text
                                                onChanged: (value) {
                                                  tempValue = value; // Update temporary value
                                                },
                                                decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  hintText: 'Enter amount',
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(null); // Close without saving
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(tempValue); // Return the input value
                                                  },
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                        if (result != null && result.isNotEmpty) {
                                          // Update the TextField with the entered data
                                          setState(() {
                                            amountController.text = result;
                                          });
                                        }
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              // Row(
                              //   children: [
                              //     Text(
                              //       'Collection Type',
                              //       style:
                              //           TextStyle(fontWeight: FontWeight.bold),
                              //     ),
                              //     Container(
                              //       width: 80,
                              //       child: DropdownButtonFormField<String>(
                              //         decoration: const InputDecoration(
                              //           border: OutlineInputBorder(),
                              //           contentPadding: EdgeInsets.symmetric(
                              //               horizontal: 10),
                              //           isDense: true,
                              //         ),
                              //         items: ['Cheque', 'Cash']
                              //             .map((type) => DropdownMenuItem(
                              //                   value: type,
                              //                   child: Text(type),
                              //                 ))
                              //             .toList(),
                              //         onChanged: (value) {
                              //           setState(() {
                              //             collectionType = value!;
                              //           });
                              //         },
                              //         value: collectionType,
                              //         icon: SizedBox.shrink(),
                              //       ),
                              //     )
                              //   ],
                              // ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Cheque Date',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  Container(
                                    width: 95,
                                    height: 30,
                                    child: GestureDetector(
                                      onTap: () => _selectDate(context),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 5),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(4.0),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              selectedDate,
                                              // style: TextStyle(fontSize: 12),
                                            ),
                                            // Icon(Icons.calendar_today, size: 16),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),

                        Row(
                          children: [
                            const Column(
                              children: [
                                Text(
                                  'Bank',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10,),
                                Text(
                                  'Cheque No',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  width: 80,
                                  child: TextField(
                                    controller: bankController,
                                    readOnly: true, // Make the TextField non-editable directly
                                    onTap: () async {
                                      String? result = await showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          // Get the current value from the TextField to pre-fill the dialog's input
                                          String tempValue = bankController.text;

                                          return AlertDialog(
                                            title: const Text('Enter Bank Name'),
                                            content: TextField(
                                              controller: TextEditingController(text: tempValue), // Set initial text
                                              onChanged: (value) {
                                                tempValue = value; // Update temporary value
                                              },
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: 'Enter bank name',
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(null); // Close without saving
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(tempValue); // Return the input value
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                      if (result != null && result.isNotEmpty) {
                                        // Update the TextField with the entered data
                                        setState(() {
                                          bankController.text = result;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                      isDense: true,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  width: 80,
                                  child: TextField(
                                    controller: chequeNoController,
                                    readOnly: true, // Make the TextField non-editable directly
                                    onTap: () async {
                                      String? result = await showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          String tempValue = chequeNoController.text; // Pre-fill the dialog with current text

                                          return AlertDialog(
                                            title: const Text('Enter Here'),
                                            content: TextField(
                                              keyboardType: TextInputType.number, // Use number keyboard for cheque number
                                              controller: TextEditingController(text: tempValue), // Set initial text from controller
                                              onChanged: (value) {
                                                tempValue = value; // Update temporary value
                                              },
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: 'Enter here',
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(null); // Close without saving
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(tempValue); // Return the input value
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                      if (result != null && result.isNotEmpty) {
                                        // Update the TextField with the entered data
                                        setState(() {
                                          chequeNoController.text = result;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Remarks
              const Text(
                'Remarks',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextField(controller: descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: const EdgeInsets.all(10.0),
                ),
              ),
              const SizedBox(height: 20),

              // Save Button
              Center(
                child: SizedBox(
                  // width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      saveChequeCollection();
                    },
                    style: ElevatedButton.styleFrom(fixedSize: Size(150, 50),
                      backgroundColor: AppConfig.colorPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
