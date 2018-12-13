import 'package:Time2Eat/DialogClasses/Dialogs.dart';
import 'package:Time2Eat/Termine/RecipeSelection.dart';
import 'package:Time2Eat/interface/DatePicker.dart';
import 'package:Time2Eat/model/ListTitle.dart';
import 'package:Time2Eat/model/Recipe_Termine.dart';
import 'package:Time2Eat/model/Shopping.dart';
import 'package:Time2Eat/model/Shopping_Title.dart';
import 'package:Time2Eat/model/Termine.dart';
import 'package:Time2Eat/recipe/new_recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Constants.dart';
import '../database/database.dart';
import '../interface/Custom_SideHeaderListView.dart';
import '../interface/GoogleColors.dart';
import '../interface/HexToColor.dart';
import '../interface/SelectableItems.dart';
import '../model/Recipes.dart';
import '../pages/calendar_view.dart';
import '../pages/shopping_list.dart';



Future<List<Recipes>> fetchRecipes(bool searched, String recipeName) async{
  var dbHelper = DBHelper();
  await dbHelper.create();
  Future<List<Recipes>> recipes;
  if(searched) recipes = dbHelper.filterRecipes(recipeName);
  else recipes = dbHelper.getRecipes();

  return recipes;
}


class Recipebook extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return RecipebookState();
  }
}

class RecipebookState extends State<Recipebook> with TickerProviderStateMixin{
  var dbHelper = new DBHelper();
  var googleMaterialColors = new GoogleMaterialColors();
  final GlobalKey<ScaffoldState> _drawerKey = new GlobalKey<ScaffoldState>();
  SharedPreferences prefs;
  GlobalKey<State<PopupMenuButton>> _buttonKey = new GlobalKey<State<PopupMenuButton>>();
  bool popup = false;

  //LongPress
  bool longPressFlag = false;
  List<String> indexList = new List();
  Map<int, GlobalKey<StateSelectableItem>> map = new Map();
  var key = new GlobalKey<StateSelectableItem>();

  //Search
  bool searchActive = false;
  TextEditingController searchController = new TextEditingController();
  bool searchPerformed = false;
  String searchCondition;


  ConvertColor convertColor = new ConvertColor();
  List<String> save_recipes = new List();

  //Body
  int _currentTab = 0;

  //AppBar
  final List<String> _tabTitle =  [
    "Rezeptbuch",
    "Terminübersicht",
    "Einkaufsliste"
  ];

  List<FloatingActionButton> _fabs = new List();

  

  @override
    void initState() {
      super.initState();
      dbHelper.create(); 
      setPrefs();     
    }
      
    @override
    Widget build(BuildContext context) {
      save_recipes = [];
      setPrefs();
      _fabs = [
          FloatingActionButton(
            onPressed: (){
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context)=> NewRecipe())
              );
            },
            child: Icon(
              Icons.add
            ),
          ),
          FloatingActionButton(
            //Add recipe
            onPressed: (){
              openTermin(context);
            },
            child: Icon(
              Icons.add
            ),
          ),
          FloatingActionButton(
            onPressed: (){
              newShoppingItem();
            },
            child: Icon(
              Icons.add
            ),
          )
        ];
  
      return Scaffold(
        appBar: PreferredSize(
          child: AnimatedCrossFade(
            firstChild: longPressedAppBar(),
            secondChild: (searchActive
              ? searchAppBar()
              : defaultAppBar()
            ),
            crossFadeState: longPressFlag
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
            duration: Duration(milliseconds: 200),
          ),
          preferredSize: Size(MediaQuery.of(context).size.width, 56.0),
        ),
        key: _drawerKey,
        body: pageView(_currentTab),
        bottomNavigationBar: BottomNavigationBar(
            onTap: onTabTapped,
            type: BottomNavigationBarType.fixed,            
            currentIndex: _currentTab,            
            items: [
              BottomNavigationBarItem( 
                activeIcon: Icon(Icons.collections_bookmark, color: Colors.blue[600]),             
                icon: Icon(OMIcons.collectionsBookmark),
                title: const Text(
                  'Rezeptbuch',
                  style: TextStyle(
                      fontFamily: 'Google-Sans', fontWeight: FontWeight.w600),
                )
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.calendar_today, color: Colors.blue[600]),
                icon: Icon(OMIcons.calendarToday),
                title: const Text(
                  'Kalender',
                  style: TextStyle(
                      fontFamily: 'Google-Sans', fontWeight: FontWeight.w600),
                )
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.shopping_basket, color: Colors.blue[600]),
                icon: Icon(OMIcons.shoppingBasket),
                title: Text(
                  _tabTitle[2],
                  style: TextStyle(
                      fontFamily: 'Google-Sans', fontWeight: FontWeight.w600),
                )
              )
            ],
        ),
        floatingActionButton: _fabs[_currentTab],        
      );
    }
  
  
    /*
      Different functions
    */
  
    void onTabTapped(int index){
      setState(() {
        _currentTab = index;
      });
    }
  
    void showBottomSnack(String value, ToastGravity toastGravity){
      Fluttertoast.showToast(
        msg: value,
        toastLength: Toast.LENGTH_SHORT,
        gravity: toastGravity,
        timeInSecForIos: 2,            
      );
    }
  
    void longPress() {
      setState(() {
        if (indexList.length == 0) {
          longPressFlag = false;
        } else {
          longPressFlag = true;
        }
      });
    }
  
    void searchOperation(String searchText) async{    
      if(searchText != null && searchText != ""){
        setState(() {
          searchCondition = searchText;
          searchController.text = searchCondition;
          fetchRecipes(true, searchText);
          searchPerformed = true;
        });
      } else {
        setState((){
          searchCondition = "";
          searchController.text = "";
          fetchRecipes(false, null);
          searchPerformed = false;
        });
      }
    }  
  
    popUpMenu(String text){
      if(text == Constants.listPopUp[2]){
        setState(() {
          longPressFlag = true;
        });
      }
    }
  
  
  
    /*
      Different important widgets
    */
    Widget recipeName(String searchCondition, String name){
  
      Widget wholeName;
      List<Widget> letters = [];
  
      //Save name
      String oldName = name;
  
      //Make the search case insensitive
      name = name.toUpperCase().trim();
      searchCondition = searchCondition.toUpperCase().trim();
  
      if(name.contains(searchCondition)){
        int start = name.indexOf(searchCondition);
        int end = start + searchCondition.length;
  
        if(start != 0){
          //undo the case insensitive
          Text firstPart = Text(
              oldName.substring(0, start)
          );
          letters.add(firstPart);
  
          Text searchedFor = Text(
              oldName.substring(start,end),
              style: TextStyle(
                color: googleMaterialColors.primaryColor(),
                fontWeight: FontWeight.bold,
              )
          );
          letters.add(searchedFor);
  
          Text endPart = Text(
              oldName.substring(end, name.length)
          );
          letters.add(endPart);
        } else {
          Text firstPart = Text(
              oldName[0],
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )
          );
          letters.add(firstPart);
  
          Text middlePart = Text(
              oldName.substring(1, end),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )
          );
          letters.add(middlePart);
  
          Text endPart = Text(
              oldName.substring(end, name.length)
          );
          letters.add(endPart);
        }
      }
  
      wholeName = Row(
          children: letters
      );
  
      return wholeName;
    }
  
    List<Widget> actionList(int currentPage){
      List<Widget> iconButtons = new List();
      if(currentPage == 0){
        iconButtons = [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black54),
            onPressed: (){
              setState(() {
                searchActive = true;
              });
            },
            tooltip: "Search",
          ),
          PopupMenuButton(
            key: _buttonKey,
            icon: Icon(Icons.more_vert, color: Colors.black54),
            itemBuilder: (_){
              return _popUpMenu();
            },
            onSelected: (value){
              switch(value){
                case "einzeln":
                  setState(() {
                    longPressFlag = true;
                    popup = true;
                  });
                  break;
                case "alle":
                  setState(() {
                    indexList = save_recipes;
                    longPressFlag = true;
                  });
                  break;
                case "rezept":
                  Navigator.push(context, MaterialPageRoute(builder: (_) => new NewRecipe()));
                  break;
                case "termin":
                  setState(() {
                    currentPage = 1;
                    openTermin(context);
                  });
                  break;
                case "item":
                  setState(() {
                    currentPage = 2;
                    newShoppingItem();
                  });
                  break;
              }
            },
          )
        ];
      } else if(currentPage == 2){
        iconButtons = [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black54),
            onPressed: (){
              asyncHamMenu();
            },
            tooltip: "Select all",
          ) 
        ];
      }
      return iconButtons; 
    }
  
    Widget defaultAppBar(){ 
      return AppBar(
        actions: actionList(_currentTab),
        backgroundColor: Color(0xFFfafafa),
        centerTitle: true,
        elevation: 0.0,
        leading: leadingWidget(_currentTab),
        title: Text(
          _tabTitle[_currentTab],
          style: TextStyle(
            color: Colors.black54,
            fontFamily: "Google-Sans",
            fontSize: 17.0
          ),
        ),
      );
    }
  
    Widget searchAppBar(){
      return AppBar(
        backgroundColor: Color(0xFFfafafa),
        elevation: 6.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black54,
          ),
          onPressed:(){
            setState(() {
              searchActive = false;
              searchOperation(null);
            }); 
          }
        ),
        title: TextField(        
          autofocus: true,
          autocorrect: true,
          cursorColor: googleMaterialColors.primaryColor(),
          cursorRadius: Radius.circular(16.0),
          cursorWidth: 2.0,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Rezepte suchen",
            hintStyle: TextStyle(
              fontFamily: "Google-Sans"
            )
          ),
          onChanged: (String input){
            if(input.trim().length > 0) {
              setState(() {
                searchOperation(input);
              });
            } else if(input.trim().length == 0){
              setState(() {
                searchOperation(null);
              });
            }
          },
          style: TextStyle(
            color: Colors.black54,
            fontFamily: "Google-Sans"          
          ),
        ),
      );
    }
  
    Widget longPressedAppBar(){
      return AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: Colors.black54,
            ),
            onPressed: (){
              deleteDialog(indexList);
            },
          )
        ],
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.close, 
            color: Colors.black54
          ),
          onPressed: (){
            setState(() {
              popup = false;
              indexList.clear();
              longPress();      
              searchController = new TextEditingController();
            });
          },
        ),
        title: Text(
          (popup && indexList.isEmpty
            ? "Rezepte auswählen"
            : indexList.length.toString()
          ),
          style: TextStyle(
            color: Colors.black54
          ),
        ),
      );
    }
  
    Widget pageView(int currentPage){
      switch (currentPage) {      
        case 1:
            return CalendarView();
          break;  
        case 2:
            return ShoppingPage();
          break;
        default:
          return listPage();
        break;
      }
    }
  
  
    Widget listPage(){
      return new Container(
        child: new FutureBuilder<List<Recipes>>(
          initialData: [],
          future: fetchRecipes(searchPerformed, searchCondition),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              if(snapshot.data.length == 0){
                return Center(
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            width: 200.0,
                            height: 200.0,
                            child: Image.asset("images/nothingFound.png"),
                        ),
                        Container(
                          child: Padding(
                            padding: EdgeInsets.only(left: 75.0),
                            child: Text("Es wurden keine Rezepte gefunden."),
                          ),
                          width: 300.0,
                        )
                      ],
                    )
                );
              } 
              return changeList(snapshot);
            } else if(snapshot.hasError) {
              GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
              SnackBar snackBar = new SnackBar(
                key: _key,
                content: Text("Die Fehlermeldung kopieren?"),
                action: SnackBarAction(
                  label: "Kopieren",
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: snapshot.error.toString()));
                    showBottomSnack("Fehlermeldung wurde kopiert", ToastGravity.BOTTOM);
                  },
                ),
              );
              _key.currentState.showSnackBar(snackBar);
              return Text("Something went wrong. Send an email with the description of the error to: stefan.niederwanger@outlook.com. Or post it at www.github.com/stnieder/Flutter-Recipe marked as issue");
            } else if(snapshot.connectionState == ConnectionState.waiting){
              return Container(
                child: Text(""),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      );
    }

    changeList(AsyncSnapshot snapshot){
      if(searchActive == true && searchController.text.trim() != "" && searchController.text.trim() != null){
        return normalList(snapshot);
      } else return sideHeaderList(snapshot);
    }
  

    normalList(AsyncSnapshot snapshot){
      return ListView.builder(

          itemBuilder: (BuildContext context, int index){
            return _selectableItems(snapshot, index);

          },
          itemCount: snapshot.data.length,
          itemExtent: 70.0,
        );
    }

    sideHeaderList(AsyncSnapshot snapshot){
      return SideHeaderListView(
          hasSameHeader: (int a, int b){
            if(!searchActive) return snapshot.data[a].name[0] == snapshot.data[b].name[0];
            else return false;
          },
          itemCount: snapshot.data.length,
          headerBuilder: (BuildContext context, int index){
              return new Padding(
                padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 25.0),
                child: Container(
                  width: 10.0,
                  child: Text(
                    snapshot.data[index].name[0].toUpperCase(),
                    style: TextStyle(
                        color: googleMaterialColors.primaryColor().withGreen(120),
                        fontFamily: "Google-Sans",
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              );
          },
          itemExtend: 70.0,
          itemBuilder: (BuildContext context, int index){

            return _selectableItems(snapshot, index);
          },
        );
    }

    _selectableItems(AsyncSnapshot snapshot, int index) {
      if(!save_recipes.contains(snapshot.data[index].name)){
        save_recipes.add(snapshot.data[index].name);
      }
      Color usedColor = convertColor.convertToColor(snapshot.data[index].backgroundColor);
      String image = snapshot.data[index].image;

      key = new GlobalKey<StateSelectableItem>();

      map.putIfAbsent(index, () => key);

      return SelectableItems(
        key: key,
        color: usedColor,
        name: snapshot.data[index].name,
        title: (searchController.text.isEmpty
          ? Text(snapshot.data[index].name)
          : recipeName(searchCondition, snapshot.data[index].name)
        ),
        index: index,
        image: image,
        isSelected: indexList.contains(snapshot.data[index].name),
        longPressEnabled: longPressFlag,
        callback: () {
          if (indexList.contains(snapshot.data[index].name)) {
            indexList.remove(snapshot.data[index].name);
          } else {
            indexList.add(snapshot.data[index].name);
          }
          longPress();
        },
      );
    }
  
  
    openTermin(BuildContext context)async {
      var returned = await Navigator.push(
          context,
          MaterialPageRoute(builder:  (context)=>RecipeSelection())
      );
      if(returned != null){
        DateTime _date = DateTime.now();
        final DateTime picked = await showMyDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(DateTime.now().year-2),
            lastDate: DateTime(DateTime.now().year+50)
        );
  
        if(picked != null && picked !=  _date){
          final dateFormat = new DateFormat('dd-MM-yyyy');
          for(int i=0; i<returned.length; i++){
            await saveTermin(returned[i], dateFormat.format(picked));
          }
          showBottomSnack("Termin wurde erfolgreich gespeichert", ToastGravity.BOTTOM);
        }
      }
    }
  
    saveTermin(String recipe, String date)async{
      DBHelper db = new DBHelper();
      await db.create();
  
  
      TermineDB termine = new TermineDB();
  
      termine.termin = date;
      termine = await db.insertTermine(termine);
  
      RecipeTermine recipeTermine = new RecipeTermine();
  
      recipeTermine.idRecipes = await fetchSpecRecipe(recipe);
      recipeTermine.idTermine = termine.id;
      recipeTermine = await db.insertRecipeTermine(recipeTermine);
    }
  
    fetchSpecRecipe(String recipeName)async {
      DBHelper dbHelper = new DBHelper();
      var parsedRecipe = await dbHelper.getSpecRecipe(recipeName);
      List<Recipes> recipe = List<Recipes>();
      int id;
      for(int i=0; i < parsedRecipe.length; i++){
        recipe.add(parsedRecipe[i]);
        id = recipe[i].id;
      }
      return id;
    }
  
    asyncHamMenu() async{
      var dialogReturn = await Dialogs().showPopupMenu(context, _currentTab);
      if(dialogReturn == "Liste umbenennen"){
        var rename = await Dialogs().renameShopping(context);
        if(rename != null){
          if(rename != "abbrechen") {
            String oldTitle = rename[0];
            String newTitle = rename[1];              
            await dbHelper.updateTitle(newTitle, oldTitle);
            prefs.setString("currentList", newTitle);
          }
        }


      } else if(dialogReturn == "Liste löschen") {
        
        String prefsList = prefs.getString("currentList");
        await dbHelper.deleteListTitle(prefsList);
        await prefs.remove("currentList");
        String newTitle = await dbHelper.getFirstTitle();
        setState(() {
          prefs.setString("currentList", newTitle);
          setPrefs();
        });



      } else if(dialogReturn == "Alle erledigten Einkäufe löschen"){
        
        var delete = await Dialogs().deleteCheckedItems(
          context, 
          await dbHelper.countCheckedItems(prefs.getString("order"), prefs.getString("currentList"))
        );

        if(delete == "löschen"){
          String list = prefs.getString("currentList");
          await dbHelper.deleteCheckedItems(list);          
        }       

        setState(() {
          setPrefs();
        });
      }
    }
  
  setPrefs() async{
    prefs = await SharedPreferences.getInstance();
    _tabTitle[2] = prefs.getString("currentList");
  }


  leadingWidget(int page) {
    switch (page) {
      case 2:
        return IconButton(
          icon: Icon(Icons.dehaze, color: Colors.black54),
          onPressed: (){
            asyncBottomSheet();
          },
        );
        break;
    }
  }

  asyncBottomSheet() async{
    var returnStatement = await Dialogs().showShoppingMenu(context);
    if(returnStatement == "neue Liste"){
      returnStatement = await Dialogs().createNewList(context);
      if(returnStatement != null && returnStatement != "abbrechen"){
        await dbHelper.create();

        ListTitleDB titles = new ListTitleDB();
        titles.titleName = returnStatement;
        titles = await dbHelper.insertList(titles);

        setState(() {
          prefs.setString("currentList", titles.titleName);
        });
      }
    } else if(returnStatement == "feedback"){
      returnStatement = await _launchMail();
    } else if(returnStatement != null){      
      setState(() {
        prefs.setString("currentList", returnStatement);
        _tabTitle[2] = returnStatement;
      });
    }

    setState(() {
      print("Finished");
    });
  }

  _launchMail() async{
    const url = "mailto:stefan.niederwanger@outlook.com?subject=Feedback%20on%20the%20app";
    if(await canLaunch(url)){
      await launch(url);
    } else {
      throw "Konnte Email leider nicht starten";
    }
  }

  deleteDialog(List<String> recipeNames) async{
    var delete = await Dialogs().deleteRecipes(context, recipeNames.length);
    FlutterLocalNotificationsPlugin notificationsPlugin = new FlutterLocalNotificationsPlugin();
    if(delete == "löschen"){
      int deleted;
      for (var i = 0; i < recipeNames.length; i++) {
        int recipeID = await dbHelper.getRecipeID(recipeNames[i]);
        deleted = await dbHelper.deleteRecipe(recipeNames[i]);    
        await notificationsPlugin.cancel(recipeID);
      }
      if(recipeNames.length == 1) showBottomSnack(recipeNames[0]+" wurde gelöscht", ToastGravity.BOTTOM);
      else if(recipeNames.length > 1) showBottomSnack("$deleted Rezepte wurden gelöscht", ToastGravity.BOTTOM);
      setState(() {
        indexList.clear();
        longPress();
      });
    } 
  }

  saveTitleShopping(int shoppingID, int titleID, DBHelper dbHelper) async{
    await dbHelper.create();

    ShoppingTitlesDB shoppingTitle = new ShoppingTitlesDB();
    shoppingTitle.idShopping = shoppingID;
    shoppingTitle.idTitles = titleID;

    shoppingTitle = await dbHelper.insertShoppingTitles(shoppingTitle);
  }

  newShoppingItem() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var item = await Dialogs().newShoppingItem(context);
    if(item != null && item != "abbrechen"){
      String name = item[0];
      String number = item[1];
      String mass = item[2];

      ShoppingDB shopping = new ShoppingDB();
      shopping.item = name;
      shopping.number = number;
      shopping.measure = mass;
      shopping.checked = 0;
      shopping.timestamp = DateTime.now().toString();

      int titleCount = await dbHelper.countAllTitles();
      print("TitleCount: $titleCount");
      if(titleCount > 0){
        var titles = await Dialogs().addToShoppingList(context);
        if(titles != null && titles != "abbrechen") {
          shopping = await dbHelper.linkShoppingTitles(shopping, titles);
          int titleID = await dbHelper.getTitleID(titles);
          await saveTitleShopping(shopping.id, titleID, dbHelper);
        } else return;        
      } else if(titleCount == 0){
        shopping = await dbHelper.newShoppingItem(shopping);
        int titleID = await dbHelper.getTitleID(prefs.getString("currentList"));
        await saveTitleShopping(shopping.id, titleID, dbHelper);
      }

      setState(() {});
    }
  }

  _popUpMenu(){
    return [
      PopupMenuItem(
        child: Row(
          children: <Widget>[
            Icon(OMIcons.checkCircleOutline),
            Padding(
              padding: EdgeInsets.only(top: 3.0, bottom: 3.0, left: 10.0),
              child: Text(
                "Auswählen",
                style: TextStyle(
                  fontFamily: "Google-Sans"
                ),
              ),
            )
          ],
        ),
        value: "einzeln",
      ),
      PopupMenuItem(
        child: Row(
          children: <Widget>[
            Icon(OMIcons.doneAll),
            Padding(
              padding: EdgeInsets.only(top: 3.0, bottom: 3.0, left: 10.0),
              child: Text(
                "Alle auswählen",
                style: TextStyle(
                  fontFamily: "Google-Sans"
                ),
              ),
            )
          ],
        ),
        value: "alle",
      ),
      PopupMenuItem(
        enabled: false,
        height: 40.0,
        child: Container(child: Text("")),
      ),
      PopupMenuItem(
        height: 15.0,
        enabled: false,
        child: Text(
          "NEU ERSTELLEN",
          style: TextStyle(
            fontFamily: "Google-Sans",
            fontSize: 12.0,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      PopupMenuItem(
        height: 50.0,
        child: Row(
          children: <Widget>[
            Icon(OMIcons.book),
            Padding(
              padding: EdgeInsets.only(bottom: 3.0, left: 10.0),
              child: Text(
                "Rezept",
                style: TextStyle(
                  fontFamily: "Google-Sans"
                ),
              ),
            )
          ],
        ),
        value: "rezept",
      ),
      PopupMenuItem(
        child: Row(
          children: <Widget>[
            Icon(OMIcons.calendarToday),
            Padding(
              padding: EdgeInsets.only(top: 3.0, bottom: 3.0, left: 10.0),
              child: Text(
                "Termin",
                style: TextStyle(
                  fontFamily: "Google-Sans"
                ),
              ),
            )
          ],
        ),
        value: "termin",
      ),
      PopupMenuItem(
        child: Row(
          children: <Widget>[
            Icon(OMIcons.shoppingBasket),
            Padding(
              padding: EdgeInsets.only(top: 3.0, bottom: 3.0, left: 10.0),
              child: Text(
                "Einkaufsartikel",
                style: TextStyle(
                  fontFamily: "Google-Sans"
                ),
              ),
            )
          ],
        ),
        value: "item",
      ),
    ];
  }
}