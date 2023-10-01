import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Logo {
  late Widget logoIcon;
  Logo({required double size, required bool inverted}){
    logoIcon = SizedBox(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: inverted == true ? Colors.indigo : Colors.white,
              borderRadius: BorderRadius.circular(1000),
            ),
            width: size,
            height: size,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.phone_iphone,
                    size: size/3,
                    color: inverted == true ? Colors.white : Colors.indigo,
                  ),
                  Icon(
                    Icons.list_alt,
                    size: size/2,
                    color: inverted == true ? Colors.white : Colors.indigo,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              'Chamada Inteligente',
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                color: inverted == true ? Colors.indigo : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: size/7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}