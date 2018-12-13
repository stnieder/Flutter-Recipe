import 'dart:async';

import 'package:flutter/material.dart';

Future<T> showDynamicBottomSheet<T> ({
  @required BuildContext context,
  @required Widget child,
  @required double minHeight,
  double maxHeight
}) {
  assert(context != null);
  assert(child != null);
  assert(minHeight != null && minHeight > 0);
  if(maxHeight != null) assert(maxHeight < 450.0);

  double position = 0.0;
  StreamController<double> controller = StreamController.broadcast();

  return showModalBottomSheet(          
    context: context,            
    builder: (BuildContext context){
      return new StreamBuilder(
        stream: controller.stream,
        builder: (context, snapshot) {
          return new GestureDetector(
            onVerticalDragUpdate: (DragUpdateDetails details){
              position = MediaQuery.of(context).size.height - details.globalPosition.dy;
              if(maxHeight == null){
                if(position > minHeight){
                  controller.add(position);
                } else if(position.isNegative) Navigator.pop(context);
              } else {
                if(position > minHeight && position < maxHeight){
                  controller.add(position);
                } else if(position.isNegative) Navigator.pop(context);
              }
            },
            behavior: HitTestBehavior.translucent,
            child: Container(
              height: snapshot.hasData ? snapshot.data : minHeight,
              color: Color(0xFF737373),            
              child: new Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: (position > (maxHeight == null ? 400.0 : maxHeight)
                    ? BorderRadius.circular(0.0)
                    : new BorderRadius.only(
                        topLeft: const Radius.circular(5.0),
                        topRight: const Radius.circular(5.0)
                      )
                  )
                ),
                child: Builder(
                  builder: (BuildContext context){
                    return Stack(
                      children: <Widget>[
                        AnimatedOpacity(
                          duration: Duration(milliseconds: 300),
                          opacity: (position > (maxHeight == null ? 400.0 : maxHeight)
                            ? 0.0
                            : 1.0
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: 10.0, left: MediaQuery.of(context).size.width/2.2),
                            child: Container(
                              width: 15.0,
                              height: 5.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                color: Colors.grey[300]
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: child,
                        )
                      ],
                    );
                  },
                )
              ),
            ),
          );
        },
      );
    },
  );
}