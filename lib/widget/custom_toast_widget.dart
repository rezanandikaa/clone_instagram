import 'package:flutter/material.dart';

class CustomToast extends StatelessWidget {
  const CustomToast({
    @required this.message,
    @required this.backgroundColor,
    @required this.isSuccess,
  });

  final String message;
  final Color backgroundColor;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            height: 40.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        message,
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                    visible: isSuccess,
                    child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: const Icon(Icons.check_circle,
                            size: 22.0, color: Colors.white))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
