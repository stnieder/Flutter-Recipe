new PopupMenuButton( 
              tooltip: "Weitere Optionen",                 
              child: Icon(Icons.more_vert, color: Colors.black45),
              key: _menuKey,

              itemBuilder: (_) => <PopupMenuItem<String>>[
                new PopupMenuItem<String>(                      
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 15.0),
                        child: Icon(Icons.sync, size: 20.0, color: Colors.black45,),
                      ),
                      Text(
                        Constants.listPopUp[1],
                        style: TextStyle(
                          fontSize: 15.0
                        ),
                      ),
                    ],
                  ), 
                  value: Constants.listPopUp[1]
                ),
                new PopupMenuItem<String>(
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 15.0),
                        child: Icon(Icons.check_circle_outline, size: 20.0, color: Colors.black45,),
                      ),
                      Text(
                        Constants.listPopUp[2],
                        style: TextStyle(
                          fontSize: 15.0
                        ),
                      ),
                    ],
                  ), 
                  value: Constants.listPopUp[2]
                )
              ],
              onSelected: (String text)=>popUpMenu(text)
            )