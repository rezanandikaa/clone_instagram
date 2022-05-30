import 'package:flutter/material.dart';
import 'package:flutter_ds_bfi/flutter_ds_bfi.dart';

class NoConnection extends StatelessWidget {
  const NoConnection({this.onTap});

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/imgs/no_connection.png',
                  width: MediaQuery.of(context).size.width -
                      MediaQuery.of(context).size.height * 0.15),
              const SizedBox(height: 12),
              const Text('Maaf, koneksi Anda terputus nih',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Pastikan dulu koneksinya ya',
                    style: TextStyle(color: Color(0xFF8d8d8d), fontSize: 14),
                    textAlign: TextAlign.center),
              ),
              const SizedBox(height: 16),
              DSFilledButton(
                text: 'Coba lagi',
                fontSize: 14,
                buttonState: DSButtonState.Active,
                fontWeight: FontWeight.normal,
                onTap: onTap,
              )
            ],
          ),
        ));
  }
}