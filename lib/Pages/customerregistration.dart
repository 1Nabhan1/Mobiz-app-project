import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobizapp/Components/commonwidgets.dart';
import 'package:mobizapp/Models/appstate.dart';
import 'package:mobizapp/Pages/homepage.dart';
import 'package:mobizapp/Utilities/rest_ds.dart';
import 'package:mobizapp/confg/appconfig.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import '../Models/Store_model.dart';
import '../Models/customercodemodel.dart';
import '../Models/provincemodelclass.dart';
import '../Models/routedatamodelclass.dart';
import '../confg/sizeconfig.dart';

class CustomerRegistration extends StatefulWidget {
  static const routeName = "/CustomerRegistartion";
  const CustomerRegistration({super.key});

  @override
  State<CustomerRegistration> createState() => _CustomerRegistrationState();
}

class _CustomerRegistrationState extends State<CustomerRegistration> {
  File? _image;
  bool showFields = false;
  bool _initDone = false;
  int cud = 0;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String> _loadImage(String img) async {
    String productUrl = '${RestDatasource().Product_URL}/uploads/customer/$img';
    String baseUrl = '${RestDatasource().BASE_URL}/uploads/customer/$img';

    // Try loading the image from the product URL first
    try {
      final response = await http.head(Uri.parse(productUrl));
      if (response.statusCode == 200) {
        return productUrl;
      }
    } catch (e) {
      // Log error if needed
    }

    // If the product URL fails, try loading from the base URL
    try {
      final response = await http.head(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        return baseUrl;
      }
    } catch (e) {
      // Log error if needed
    }

    // If both fail, return an empty string or throw an error
    throw Exception('Image not found');
  }

  void _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
    });
    _updateLocationTextField(_latitude!, _longitude!);
  }

  void _updateLocationTextField(double latitude, double longitude) {
    _locationController.text = '$latitude, $longitude';
  }

  double? _latitude;
  double? _longitude;

  bool _isUpdate = false;

  final _formKey = GlobalKey<FormState>();
  var _nameController = TextEditingController();
  var _codeController = TextEditingController();
  var _addressController = TextEditingController();
  var _contactNumberController = TextEditingController();
  var _whatsappNumberController = TextEditingController();
  var _emailController = TextEditingController();
  var _buildingController = TextEditingController();
  var _flatNumberController = TextEditingController();
  var _locationController = TextEditingController();
  final _trnController = TextEditingController();
  final _creditDays = TextEditingController();
  final _creditLimit = TextEditingController();

  late FocusNode namefocus;
  late FocusNode addressfocus;
  late FocusNode contactfocus;
  late FocusNode whatsappfocus;
  late FocusNode emailfocus;
  late FocusNode buildingfocus;
  late FocusNode flatfocus;
  late FocusNode trnfocus;

  String? _selectPaymentTerms;
  String? _customercode;
  String? _location;
  String? img;
  int? id;
  String? _selectedRoute;
  String? _selectCuCode;
  // String? _selectedProvince;
  int? _selectedProvinceid;
  int? _selectedrouteid;

  RouteDataModel route = RouteDataModel();
  ProvinceDataModel province = ProvinceDataModel();
  CustomerCodeModel cuCode = CustomerCodeModel();

  final List<String> paymentTerms = ['CASH', 'CREDIT', 'BILLTOBILL'];
  // final List<String> routes = ['a'];
  final List<Map<String, dynamic>> routes = [
    {'id': 1, 'name': 'routes 1'},
    {'id': 2, 'name': 'routes 2'},
  ];
  final List<Map<String, dynamic>> provinces = [
    {'id': 1, 'name': 'Province 1'},
    {'id': 3, 'name': 'Province 2'},
  ];
  final List<String> cuCodeData = [
    'Province 1',
  ];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Map<String, dynamic>? params =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      if (params != null) {
        _nameController.text = params['name'] ?? '';
        _customercode = params['code'];
        _addressController.text = params['address'] ?? '';
        _buildingController.text = params['building'] ?? '';
        _flatNumberController.text = params['flat_no'] ?? '';
        _contactNumberController.text = params['phone'] ?? '';
        _whatsappNumberController.text = params['whatsappNumber'] ?? '';
        _trnController.text = params['trn'] ?? '';
        img = params['cust_image'];
        _location = params['location'] ?? 'Click the icon to fetch the data';
        _selectPaymentTerms =
            params['paymentTerms'] == '' ? null : params['paymentTerms'];
        _selectedProvinceid =
            params['provinceId'] == 0 ? null : params['provinceId'];
        print('object');
        print(params['provinceId']);
        _selectedrouteid = params['routeId'];
        id = params['id'];
        if (params['credit_days'] != null && params['credit_days'] != '') {
          _creditDays.text = params['credit_days'].toString();
        }
        if (params['credit_limit'] != null && params['credit_limit'] != '') {
          _creditLimit.text = params['credit_limit'].toString();
        }
        _emailController.text = params['email'] ?? '';
        _isUpdate = true;
      }
      print("Code${_customercode}");
    });
    namefocus = FocusNode();
    addressfocus = FocusNode();
    contactfocus = FocusNode();
    whatsappfocus = FocusNode();
    emailfocus = FocusNode();
    buildingfocus = FocusNode();
    flatfocus = FocusNode();
    trnfocus = FocusNode();

    super.initState();
    _getRoutes()
        .then((value) => _getProvince())
        .then((value) => _getCodeData())
        .then((value) => fetchStoreDetail())
        .then((storeDetail) {
      if (storeDetail != null && storeDetail.comapny_id == 5) {
        setState(() {
          showFields = true; // Show fields for company_id 5
        });
      } else {
        setState(() {
          showFields = false; // Hide fields otherwise
        });
      }
      print("SSSSS${storeDetail!.comapny_id}");
    });
    // fetchStoreDetail();
    // _getProvince();
    // print(_selectPaymentTerms);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _codeController.dispose();
    _addressController.dispose();
    _contactNumberController.dispose();
    _whatsappNumberController.dispose();
    _emailController.dispose();
    _buildingController.dispose();
    _flatNumberController.dispose();
    _trnController.dispose();
    _creditDays.dispose();
    _creditLimit.dispose();
    trnfocus.dispose();
    buildingfocus.dispose();
    flatfocus.dispose();
    namefocus.dispose();
    contactfocus.dispose();
    addressfocus.dispose();
    emailfocus.dispose();
    whatsappfocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (ModalRoute.of(context)!.settings.arguments != null) {
    //   final Map<String, dynamic>? params =
    //   ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    //   _nameController.text = params!['name'] ?? '';
    //   _customercode = params['code'];
    //   _addressController.text = params['address'] ?? '';
    //   _contactNumberController.text = params['phone'] ?? '';
    //   _whatsappNumberController.text = params['whatsappNumber'] ?? '';
    //   _trnController.text = params['trn'] ?? '';
    //   _location = params['location'] ?? 'Click the icon to fetch the data';
    //   _selectPaymentTerms = params['paymentTerms'] ?? '';
    //   _selectedProvinceid = params['provinceId'];
    //   _selectedrouteid = params['routeId'];
    //   id = params['id'];
    //   if (params['credit_days'] != null && params['credit_days'] != '') {
    //     _creditDays.text = params['credit_days'].toString();
    //   }
    //   if (params['credit_limit'] != null && params['credit_limit'] != '') {
    //     _creditLimit.text = params['credit_limit'].toString();
    //   }
    //
    //   _emailController.text = params['email'] ?? '';
    //   // print(_trnController.text);
    //   // print('dddddddddddddddddddddddddddddddddddddd');
    //   _isUpdate = true;
    // }
    return Scaffold(
        appBar: AppBar(
            title: const Text(
              'Registration',
              style: TextStyle(color: AppConfig.backButtonColor),
            ),
            backgroundColor: AppConfig.colorPrimary,
            iconTheme: const IconThemeData(color: AppConfig.backButtonColor)),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: (!_initDone)
                ? Shimmer.fromColors(
                    baseColor: AppConfig.buttonDeactiveColor.withOpacity(0.1),
                    highlightColor: AppConfig.backButtonColor,
                    child: Center(
                      child: Column(
                        children: [
                          CommonWidgets.loadingContainers(
                              height: SizeConfig.blockSizeVertical * 10,
                              width: SizeConfig.blockSizeHorizontal * 90),
                          CommonWidgets.loadingContainers(
                              height: SizeConfig.blockSizeVertical * 10,
                              width: SizeConfig.blockSizeHorizontal * 90),
                          CommonWidgets.loadingContainers(
                              height: SizeConfig.blockSizeVertical * 10,
                              width: SizeConfig.blockSizeHorizontal * 90),
                          CommonWidgets.loadingContainers(
                              height: SizeConfig.blockSizeVertical * 10,
                              width: SizeConfig.blockSizeHorizontal * 90),
                          CommonWidgets.loadingContainers(
                              height: SizeConfig.blockSizeVertical * 10,
                              width: SizeConfig.blockSizeHorizontal * 90),
                          CommonWidgets.loadingContainers(
                              height: SizeConfig.blockSizeVertical * 10,
                              width: SizeConfig.blockSizeHorizontal * 90),
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: SizedBox(
                              width: 150,
                              height: 150,
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 2,
                                      ),
                                      image: _image != null
                                          ? DecorationImage(
                                              image: FileImage(_image!),
                                              fit: BoxFit.cover,
                                            )
                                          : null, // Set image only when _image is available
                                    ),
                                    child: _image == null
                                        ? (img != null && img!.isNotEmpty)
                                            ? FutureBuilder(
                                                future: _loadImage(img!),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return const Center(
                                                        child: Text(
                                                            'Select Image'));
                                                  } else {
                                                    return ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      child: Image.network(
                                                        snapshot.data!,
                                                        width: 150,
                                                        height: 150,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return const Center(
                                                              child: Text(
                                                                  'Select Image'));
                                                        },
                                                      ),
                                                    );
                                                  }
                                                },
                                              )
                                            : const Center(
                                                child: Text('Select Image'))
                                        : null,
                                  ),
                                  if (_image != null)
                                    Positioned(
                                      bottom: 5,
                                      right: 5,
                                      child: GestureDetector(
                                        onTap: _pickImage,
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: const BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  focusNode: namefocus,
                                  onEditingComplete: () {
                                    addressfocus.requestFocus();
                                  },
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppConfig.colorPrimary)),
                                    labelText: 'Name',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) =>
                                      _validateNotEmpty(value, 'Name'),
                                ),
                                CommonWidgets.verticalSpace(2),
                                // _buildDropdownField(
                                //   label: 'Code',
                                //   items: cuCodeData,
                                //   value: _selectCuCode,
                                //   onChanged: (value) {
                                //     setState(() {
                                //       _selectCuCode = value;
                                //     });
                                //   },
                                // ),
                                TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  enabled: false, // Disable user interaction
                                  controller: TextEditingController(
                                    text: _isUpdate
                                        ? _customercode
                                        : cuCodeData.isNotEmpty
                                            ? cuCodeData
                                                .map((data) => data.toString())
                                                .join(
                                                    ', ') // Join elements with a comma
                                            : '',
                                  ),
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppConfig.colorPrimary),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    labelText: 'Code',
                                    border: OutlineInputBorder(),
                                    // Add style for text color
                                    labelStyle: TextStyle(
                                        color: Colors
                                            .black), // Change label text color
                                    hintStyle: TextStyle(color: Colors.black),
                                  ),
                                ),

                                // TextFormField(
                                //   controller: _codeController,
                                //   decoration: const InputDecoration(
                                //     focusedBorder: OutlineInputBorder(
                                //         borderSide: BorderSide(
                                //             color: AppConfig.colorPrimary)),
                                //     labelText: 'Code',
                                //     border: OutlineInputBorder(),
                                //   ),
                                //   validator: (value) =>
                                //       _validateNotEmpty(value, 'Code'),
                                // ),
                                CommonWidgets.verticalSpace(2),
                                TextFormField(
                                  focusNode: addressfocus,
                                  onEditingComplete: () {
                                    contactfocus.requestFocus();
                                  },
                                  controller: _addressController,
                                  decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppConfig.colorPrimary)),
                                    labelText: 'Address',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) =>
                                      _validateNotEmpty(value, 'Address'),
                                ),
                                CommonWidgets.verticalSpace(2),
                                if (showFields) ...[
                                  TextFormField(
                                    // keyboardType: TextInputType.phone,
                                    focusNode: buildingfocus,
                                    onEditingComplete: () {
                                      buildingfocus.requestFocus();
                                    },
                                    controller: _buildingController,
                                    decoration: const InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppConfig.colorPrimary)),
                                      labelText: 'Building',
                                      border: OutlineInputBorder(),
                                    ),
                                    // validator: (value) => _validateNotEmpty(
                                    //     value, 'Building'),
                                  ),
                                  CommonWidgets.verticalSpace(2),
                                  TextFormField(
                                    // keyboardType: TextInputType.phone,
                                    focusNode: flatfocus,
                                    onEditingComplete: () {
                                      flatfocus.requestFocus();
                                    },
                                    controller: _flatNumberController,
                                    decoration: const InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppConfig.colorPrimary)),
                                      labelText: 'Flat Number',
                                      border: OutlineInputBorder(),
                                    ),
                                    // validator: (value) => _validateNotEmpty(
                                    //     value, 'Flat Number'),
                                  ),
                                  CommonWidgets.verticalSpace(2),
                                ],
                                // CommonWidgets.verticalSpace(2),
                                TextFormField(
                                  keyboardType: TextInputType.phone,
                                  focusNode: contactfocus,
                                  onEditingComplete: () {
                                    whatsappfocus.requestFocus();
                                  },
                                  controller: _contactNumberController,
                                  decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppConfig.colorPrimary)),
                                    labelText: 'Contact Number',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) =>
                                      _validateNumber(value, 'Contact Number'),
                                ),
                                CommonWidgets.verticalSpace(2),
                                TextFormField(
                                  keyboardType: TextInputType.phone,
                                  focusNode: whatsappfocus,
                                  onEditingComplete: () {
                                    emailfocus.requestFocus();
                                  },
                                  controller: _whatsappNumberController,
                                  decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppConfig.colorPrimary)),
                                    labelText: 'WhatsApp Number',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) => _validateWhatsappNumber(
                                      value, 'WhatsApp Number'),
                                ),
                                CommonWidgets.verticalSpace(2),
                                TextFormField(
                                  onEditingComplete: () {
                                    trnfocus.requestFocus();
                                  },
                                  focusNode: emailfocus,
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppConfig.colorPrimary)),
                                    labelText: 'Email',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: _validateEmail,
                                ),
                                CommonWidgets.verticalSpace(2),
                                // decoration: const InputDecoration(
                                //   focusedBorder: OutlineInputBorder(
                                //       borderSide: BorderSide(
                                //           color: AppConfig.colorPrimary)),
                                //   labelText: 'Address',
                                //   border: OutlineInputBorder(),
                                // ),
                                TextField(
                                  controller: _locationController,
                                  readOnly:
                                      true, // Make the text field read-only
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppConfig.colorPrimary)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppConfig.colorPrimary)),
                                    hintText: _location,
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.my_location),
                                      onPressed: _getLocation,
                                    ),
                                  ),
                                  // onTap: _openMapScreen,
                                ),
                                CommonWidgets.verticalSpace(2),
                                TextFormField(
                                  focusNode: trnfocus,
                                  controller: _trnController,
                                  decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppConfig.colorPrimary)),
                                    labelText: 'TRN',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) =>
                                      _validateNotEmpty(value, 'TRN'),
                                ),
                                CommonWidgets.verticalSpace(2),
                                _buildDropdownField(
                                  label: 'Payment Terms',
                                  items: paymentTerms,
                                  value: _selectPaymentTerms,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectPaymentTerms = value;
                                    });
                                  },
                                ),

                                (_selectPaymentTerms == "CREDIT")
                                    ? CommonWidgets.verticalSpace(2)
                                    : Container(),
                                (_selectPaymentTerms == "CREDIT")
                                    ? TextFormField(
                                        controller: _creditLimit,
                                        decoration: const InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                      AppConfig.colorPrimary)),
                                          labelText: 'Credit Limit',
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) => _validateNotEmpty(
                                            value, 'Credit Limit'),
                                      )
                                    : Container(),
                                (_selectPaymentTerms == "CREDIT")
                                    ? CommonWidgets.verticalSpace(2)
                                    : Container(),
                                (_selectPaymentTerms == "CREDIT")
                                    ? TextFormField(
                                        controller: _creditDays,
                                        decoration: const InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                      AppConfig.colorPrimary)),
                                          labelText: 'Credit Days',
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) => _validateNotEmpty(
                                            value, 'Credit Days'),
                                      )
                                    : Container(),
                                CommonWidgets.verticalSpace(2),

                                CustomDropdown(
                                  items: routes,
                                  selectedValue: _selectedrouteid != null
                                      ? routes.firstWhere(
                                        (element) => element['id'] == _selectedrouteid,
                                    orElse: () => {} // Return null if no match is found
                                  )
                                      : null,
                                  onChanged: (selectedroute) {
                                    setState(() {
                                      _selectedrouteid = selectedroute?['id']; // Safely handle null values
                                    });
                                  },
                                  hint: 'Select Routes',
                                  label: 'Route',
                                ),

                                CommonWidgets.verticalSpace(2),
                                CustomDropdown(
                                  items: provinces,
                                  selectedValue: _selectedProvinceid != null
                                      ? provinces.firstWhere(
                                        (element) => element['id'] == _selectedProvinceid,
                                    orElse: () => {}, // Return null if no match is found
                                  )
                                      : null,
                                  onChanged: (selectedProvince) {
                                    setState(() {
                                      _selectedProvinceid = selectedProvince?['id'];
                                    });
                                  },
                                  hint: 'Select Province',
                                  label: 'Province',
                                ),

                                // CustomDropdown(
                                //   items: provinces,
                                //   selectedValue: _selectedProvinceid != null
                                //       ? provinces.firstWhere(
                                //         (element) => element['id'] == _selectedProvinceid,
                                //     orElse: () => {'id': null, 'name': 'Unknown'}, // Return a default map
                                //   )
                                //       : {'id': null, 'name': 'Select a province'}, // Default value when null
                                //   onChanged: (selectedProvince) {
                                //     setState(() {
                                //       _selectedProvinceid = selectedProvince!['id'];
                                //     });
                                //     // print(_selectedProvinceid);
                                //   },
                                //   hint: 'Select Province',
                                //   label: 'Province',
                                // ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: SizeConfig.blockSizeHorizontal * 35,
                                  height: SizeConfig.blockSizeVertical * 5,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      backgroundColor:
                                          const WidgetStatePropertyAll(
                                              AppConfig.colorPrimary),
                                    ),
                                    onPressed:
                                        //     () {
                                        //   print(_selectedrouteid);
                                        // },
                                        _submitForm,
                                    child: Text(
                                      _isUpdate ? 'UPDATE' : 'CREATE',
                                      style: TextStyle(
                                          fontSize: AppConfig.textCaption3Size,
                                          color: AppConfig.backgroundColor,
                                          fontWeight: AppConfig.headLineWeight),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ));
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _postRecord();
    }
  }

  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value != null && value.isNotEmpty) {
      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
      if (!emailRegex.hasMatch(value)) {
        return 'Please enter a valid email';
      }
    }
    // If value is null or empty, no error message is returned
    return null;
  }

  String? _validateNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter $fieldName';
    }
    final numberRegex = RegExp(r'^\+?[0-9]+$');
    if (!numberRegex.hasMatch(value)) {
      return 'Please enter a valid $fieldName';
    }
    return null;
  }

  String? _validateWhatsappNumber(String? value, String fieldName) {
    if (value != null && value.isNotEmpty) {
      final numberRegex = RegExp(r'^[0-9]+$');
      if (!numberRegex.hasMatch(value)) {
        return 'Please enter a valid $fieldName';
      }
    }
    // If value is null or empty, no error message is returned
    return null;
  }

  Widget _buildDropdownField(
      {required String label,
      required List<String> items,
      required String? value,
      required void Function(String?) onChanged}) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppConfig.colorPrimary)),
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      value: value,
      onChanged: onChanged,
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      validator: (value) => value == null ? 'Please select $label' : null,
    );
  }

  Future<StoreDetail?> fetchStoreDetail() async {
    final url = Uri.parse(
        '${RestDatasource().BASE_URL}/api/get_store_detail?store_id=${AppState().storeId}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("data:::${data['company_id']}");
        print(showFields);
        if (data['company_id'] == 5) {
          setState(() {
            showFields = true;
          });
        } else {
          setState(() {
            showFields = false;
          });
        }
        return StoreDetail.fromJson(data);
      } else {
        // Handle error
        print('Failed to fetch data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<void> _getRoutes() async {
    RestDatasource api = RestDatasource();
    dynamic resJson = await api.getDetails(
        '/api/get_route?store_id=${AppState().storeId}', AppState().token);
    route = RouteDataModel.fromJson(resJson);
    if (route.data != null) {
      print(resJson);
      routes.clear();
      for (var i in route.data!) {
        routes.add({'id': i.id, 'name': i.name});
      }
    }
  }

  Future<void> _getProvince() async {
    RestDatasource api = RestDatasource();
    dynamic resJson =
        await api.getDetails('/api/get_province/', AppState().token);

    province = ProvinceDataModel.fromJson(resJson);
    if (province.data != null) {
      provinces.clear();
      for (var i in province.data!) {
        provinces.add({'id': i.id, 'name': i.name});
      }
    }
  }

  Future<void> _getCodeData() async {
    RestDatasource api = RestDatasource();
    dynamic resJson = await api.getDetails(
        '/api/get_customer_code?store_id=${AppState().storeId}',
        AppState().token);
    cuCode = CustomerCodeModel.fromJson(resJson);
    if (cuCode.result!.data != null) {
      cuCodeData.clear();
      // for (var i in cuCode.result.data) {
      cuCodeData.add(cuCode.result!.data!);
      // }
    }
    // print(cuCodeData);
    // print('///////////////////////////////////////');
    setState(() {
      _initDone = true;
    });
  }

  Future _postRecord() async {
    int? pId;
    int? rId;
    for (var data in province.data!) {
      if (data.name == _selectedProvinceid) {
        pId = data.id;
        break;
      }
    }
    for (var data in route.data!) {
      if (data.code == _selectedrouteid) {
        rId = data.id;
        break;
      }
    }

    RestDatasource api = RestDatasource();
    String codeToPost = _customercode ??
        (cuCodeData.isNotEmpty ? cuCodeData.join(', ') : '');
    Map<String, dynamic> bodyJson = {
      'id': id,
      'name': _nameController.text,
      'code': codeToPost,
      'address': _addressController.text,
      'contact_number': _contactNumberController.text,
      'whatsapp_number': _whatsappNumberController.text,
      'email': _emailController.text,
      'Building': _buildingController.text,
      'Flat_no': _flatNumberController.text,
      'location': _locationController.text.isNotEmpty
          ? _locationController.text
          : _location,
      'trn': _trnController.text,
      'payment_terms': _selectPaymentTerms,
      'route_id': _selectedrouteid,
      'provience_id': _selectedProvinceid,
      'store_id': AppState().storeId,
      if (_creditLimit.text.isNotEmpty) 'credi_limit': _creditLimit.text,
      if (_creditDays.text.isNotEmpty) 'credi_days': _creditDays.text,
    };

    print('Body data: $bodyJson');
    print('Image: $codeToPost');

    try {
      dynamic resJson = await api.customerRegister(
        AppState().token,
        bodyJson,
        _image,
        context,
        _isUpdate,
      );
      print("Body${bodyJson}");
      print('Response: $resJson');

      if (mounted) {
        CommonWidgets.showDialogueBox(
          context: context,
          title: "Success",
          msg: "Data Inserted Successfully",
        ).then(
              (value) => Navigator.pushReplacementNamed(context, HomeScreen.routeName),
        );
      }
    } catch (e) {
      print("Error: $e");
      if (mounted) {
        CommonWidgets.showDialogueBox(
          context: context,
          title: "Error",
          msg: "Something went wrong. Please try again.",
        );
      }
    }
  }

}

class CustomDropdown extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final Map<String, dynamic>? selectedValue;
  final ValueChanged<Map<String, dynamic>?> onChanged;
  final String hint;
  final String label;

  CustomDropdown({
    required this.items,
    required this.onChanged,
    this.selectedValue,
    required this.hint,
    required this.label,
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  Map<String, dynamic>? selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.selectedValue;
  }

  @override
  void didUpdateWidget(covariant CustomDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update selectedItem when selectedValue changes in the parent widget
    if (widget.selectedValue != selectedItem) {
      setState(() {
        selectedItem = widget.selectedValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Map<String, dynamic>>(
      hint: Text(widget.hint),
      value: widget.items.contains(selectedItem) ? selectedItem : null, // Ensure selectedItem matches an item or is null
      onChanged: (Map<String, dynamic>? newValue) {
        setState(() {
          selectedItem = newValue;
        });
        widget.onChanged(newValue);
      },
      items: widget.items.map((item) {
        return DropdownMenuItem<Map<String, dynamic>>(
          value: item,
          child: Text(item['name']),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: widget.label,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        border: OutlineInputBorder(),
      ),
      validator: (value) =>
      value == null ? 'Please select ${widget.label}' : null,
    );

  }
}
