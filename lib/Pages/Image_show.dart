import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageShow extends StatelessWidget {
  const ImageShow({super.key, required this.img});
  final String img;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors
            .grey.shade700, // Optional: to make the background transparent
        body: Center(
          child: Container(
            width: double.infinity,
            child: FadeInImage(
              image: NetworkImage(img),
              placeholder: const AssetImage('Assets/Images/no_image.jpg'),
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset('Assets/Images/no_image.jpg',
                    fit: BoxFit.cover);
              },
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
