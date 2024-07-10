// import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';

import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:mobizapp/Models/appstate.dart';
import 'package:mobizapp/Pages/ExpensesPage.dart';
import 'package:mobizapp/Pages/homepage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import '../Components/commonwidgets.dart';
import '../Models/ExpenseDrop_model.dart';
import '../Utilities/rest_ds.dart';
import '../confg/appconfig.dart';
import '../confg/sizeconfig.dart';
import 'customerscreen.dart';

class ExpenseAdd extends StatefulWidget {
  static const routeName = "/ExpenseAdd";

  const ExpenseAdd({super.key});

  @override
  State<ExpenseAdd> createState() => _ExpenseAddState();
}

class _ExpenseAddState extends State<ExpenseAdd> {
  late Future<VisitReasonResponse> futureExpenseReason;
  List<File> _attachedImages = [];
  Expense? selectedexpense;
  String? _amount;
  DateTime? _selectedDate = DateTime.now();
  TextEditingController remark = TextEditingController();
  @override
  void initState() {
    super.initState();
    futureExpenseReason = fetchExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Expense',
          style: TextStyle(color: AppConfig.backgroundColor),
        ),
      ),
      body: FutureBuilder(
        future: futureExpenseReason,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Shimmer.fromColors(
              baseColor: AppConfig.buttonDeactiveColor.withOpacity(0.1),
              highlightColor: AppConfig.backButtonColor,
              child: Center(
                child: Column(
                  children: List.generate(
                    6,
                    (index) => CommonWidgets.loadingContainers(
                      height: SizeConfig.blockSizeVertical * 10,
                      width: SizeConfig.blockSizeHorizontal * 90,
                    ),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Date'),
                        Row(
                          children: [
                            SizedBox(
                              width: 30,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: Text(
                                    _selectedDate == null
                                        ? 'Select Date'
                                        : DateFormat('dd/MM/yyyy')
                                            .format(_selectedDate!),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // _selectDate(context);
                              },
                              icon: Icon(CupertinoIcons.calendar_today),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Amount'),
                            SizedBox(width: 20),
                            GestureDetector(
                              onTap: () {
                                _showAmountDialog(context);
                              },
                              child: Container(
                                width: 70,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Center(
                                    child: Text(
                                  _amount ?? 'Amt',
                                )),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Type"),
                        Container(
                          height: MediaQuery.of(context).size.height * .03,
                          width: MediaQuery.of(context).size.width * .72,
                          decoration: BoxDecoration(color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(3),
                            // border: Border.all(color: Colors.grey),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<Expense>(
                                isExpanded: true,
                                hint: Text(
                                  'Select from list',
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                                value: selectedexpense,
                                onChanged: (Expense? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      selectedexpense = newValue;
                                    });
                                  }
                                },
                                items:
                                    snapshot.data!.data.map((Expense expense) {
                                  return DropdownMenuItem<Expense>(
                                    value: expense,
                                    child: Center(
                                      child: Text(expense.name),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Remarks"),
                        SizedBox(
                          child: TextFormField(
                            controller: remark,
                            maxLines: 3,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                hintText: 'Enter here',
                                hintStyle:
                                    TextStyle(fontWeight: FontWeight.w300),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey))),
                          ),
                          // height: MediaQuery.of(context).size.height * .2,
                          width: MediaQuery.of(context).size.width * .72,
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(AppConfig.colorPrimary),
                        shape:
                            WidgetStateProperty.all(BeveledRectangleBorder()),
                        minimumSize: WidgetStateProperty.all(Size(70, 30)),
                      ),
                      onPressed: _attachDocuments,
                      child: SizedBox(
                        width: 120,
                        child: Center(
                          child: Text(
                            "Attach Documents",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _attachedImages.isEmpty
                      ? Container()
                      : Wrap(
                          children: _attachedImages.map((File file) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(
                                file,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            );
                          }).toList(),
                        ),
                  SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(AppConfig.colorPrimary),
                        shape:
                            WidgetStateProperty.all(BeveledRectangleBorder()),
                        minimumSize: WidgetStateProperty.all(Size(70, 30)),
                      ),
                      onPressed: () {
                        postData();
                      },
                      child: SizedBox(
                        width: 120,
                        child: Center(
                          child: Text(
                            "Send for Approval",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No Data Available'));
          }
        },
      ),
    );
  }

  void _attachDocuments() async {
    final picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Photo Library'),
                onTap: () async {
                  final pickedFile = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    final compressedImage =
                        await _compressImage(File(pickedFile.path));
                    setState(() {
                      _attachedImages.add(compressedImage);
                    });
                  }
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () async {
                  final pickedFile = await picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (pickedFile != null) {
                    final compressedImage =
                        await _compressImage(File(pickedFile.path));
                    setState(() {
                      _attachedImages.add(compressedImage);
                    });
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<File> _compressImage(File file) async {
    final image = img.decodeImage(file.readAsBytesSync())!;
    final compressedImage =
        img.copyResize(image, width: 800); // Resize the image
    final compressedBytes =
        img.encodeJpg(compressedImage, quality: 75); // Compress the image

    final tempDir = await getTemporaryDirectory();
    final compressedFile =
        File('${tempDir.path}/compressed_${file.path.split('/').last}');
    await compressedFile.writeAsBytes(compressedBytes);

    // Check file size and further compress if necessary
    if (compressedFile.lengthSync() > 200 * 1024) {
      final furtherCompressedBytes =
          img.encodeJpg(compressedImage, quality: 65);
      await compressedFile.writeAsBytes(furtherCompressedBytes);
    }

    return compressedFile;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _showAmountDialog(BuildContext context) async {
    TextEditingController amountController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Amount'),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Amount"),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppConfig.colorPrimary,
              ),
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                setState(() {
                  _amount = amountController.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void postData() async {
    var url = Uri.parse('${RestDatasource().BASE_URL}/api/expense.store');
    var request = http.MultipartRequest('POST', url);

    request.fields['van_id'] = AppState().vanId.toString();
    request.fields['store_id'] = AppState().storeId.toString();
    request.fields['expense_id'] = selectedexpense!.id.toString();
    request.fields['description'] = remark.text;
    request.fields['amount'] = _amount ?? '0';
    request.fields['in_date'] = DateFormat('dd-MM-yyyy').format(_selectedDate!);
    request.fields['user_id'] = AppState().userId.toString();

    // Add files to the request
    for (var file in _attachedImages) {
      request.files.add(await http.MultipartFile.fromPath(
        'upload_document[]', // API expects an array of files, adjust as per API documentation
        file.path,
      ));
    }

    // Send the request
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      if (mounted) {
        CommonWidgets.showDialogueBox(
                context: context, title: "", msg: "Data Inserted Successfully")
            .then(
                (value) => Navigator.pushNamed(context, HomeScreen.routeName));
      }
      print('Request successful');
      print('Response: ${response.body}');
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  static String url =
      '${RestDatasource().BASE_URL}/api/get_expense_master?store_id=${AppState().storeId}';

  static Future<VisitReasonResponse> fetchExpenses() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return VisitReasonResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
