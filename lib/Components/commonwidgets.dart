import 'package:flutter/material.dart';
import 'package:mobizapp/confg/appconfig.dart';
import 'package:mobizapp/confg/sizeconfig.dart';

class CommonWidgets {
  CommonWidgets._();

  static horizontalSpace(double size) {
    return SizedBox(
      width: SizeConfig.blockSizeHorizontal * size,
    );
  }

  static verticalSpace(double size) {
    return SizedBox(
      height: SizeConfig.blockSizeVertical * size,
    );
  }

  static Widget heading(String title, double size, bool mandatory) {
    return Container(
      padding: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal * 2,
          top: SizeConfig.blockSizeVertical * 1),
      child: Text.rich(
        TextSpan(
          text: title,
          style: TextStyle(
            color: Colors.black54,
            fontSize: AppConfig.textHeadlineSize * size,
            fontWeight: FontWeight.bold,
          ),
          children: <InlineSpan>[
            TextSpan(
              text: (mandatory == false) ? "" : " \*",
              style: const TextStyle(
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget commontextfields(
      {required String labelText,
      required double width,
      required double height,
      required TextEditingController textController,
      required TextInputType keyBoardType,
      required double radius}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: AppConfig.backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(radius))),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: textController,
            keyboardType: keyBoardType,
            onChanged: (value) {
              textController.text = value;
            },
            decoration: InputDecoration.collapsed(
              hintText: labelText,
            ),
          ),
        ),
      ),
    );
  }

  static Widget button(
      {required String title,
      required double width,
      required double height,
      required Color bgColor,
      required Color textColor,
      required double radius,
      required VoidCallback function}) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(radius),
              ),
            ),
          ),
          backgroundColor: WidgetStatePropertyAll(bgColor),
        ),
        onPressed: function,
        child: Text(
          title,
          style: TextStyle(color: textColor, fontSize: AppConfig.headLineSize),
        ),
      ),
    );
  }

  static Future<void> showDialogueBox(
      {required BuildContext context,
      required String title,
      required String msg}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Widget loadingContainers(
      {required double height, required double width}) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: AppConfig.buttonDeactiveColor,
      ),
      height: height,
      width: width,
    );
  }

  static Widget loadingWidget() {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }
}
