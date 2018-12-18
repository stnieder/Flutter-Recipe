
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';



Future<T> showRoundedBottomSheet<T> ({
  @required BuildContext context,
  @required Widget child,
  @required double height
}) {
  assert(context != null);
  assert(child != null);
  return showModalBottomSheet(          
    context: context,            
    builder: (BuildContext context){
      return new Container(
        height: height,
        color: Color(0xFF737373),            
        child: new Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(5.0),
              topRight: const Radius.circular(5.0)
            )
          ),
          child: Builder(
            builder: (BuildContext context){
              return child;
            },
          )
        ),
      );
    }
  );
}