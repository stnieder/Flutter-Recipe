
//Plugins of Dart-Team
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

//Plugins from Dart-Lang
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flare_flutter/flare_actor.dart';

//Plugins of Flutter-Team
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//Own plugins
import '../customizedWidgets/Custom_SideHeaderListView.dart';
import '../customizedWidgets/DatePicker.dart';
import '../customizedWidgets/GoogleColors.dart';
import '../customizedWidgets/HexToColor.dart';
import '../customizedWidgets/SelectableItems.dart';
import '../database/database.dart';
import '../databaseModel/Ingredients.dart';
import '../databaseModel/ListTitle.dart';
import '../databaseModel/Recipes.dart';
import '../databaseModel/Recipe_Ingredient.dart';
import '../databaseModel/Recipe_Steps.dart';
import '../databaseModel/Recipe_Termine.dart';
import '../databaseModel/Shopping.dart';
import '../databaseModel/Shopping_Title.dart';
import '../databaseModel/StepDescription.dart';
import '../databaseModel/Termine.dart';
import '../DialogInterfaces/Dialogs.dart';
import '../Export_Import/recipes.dart';
import '../pages/CalendarTermine/RecipeSelection.dart';
import '../pages/CalendarTermine/calendar_view.dart';
import '../pages/shopping_list.dart';
import '../recipe/new_recipe.dart';

int favoriteCount = 0;


//Get all Recipes inside a List
Future<List<Recipes>> fetchRecipes(bool searched, String recipeName) async{
  var dbHelper = DBHelper();
  await dbHelper.create();
  Future<List<Recipes>> recipes;
  if(searched) recipes = dbHelper.filterRecipes(recipeName);
  else recipes = dbHelper.getRecipes();

  favoriteCount = await dbHelper.countFavorites();

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
  bool _dialVisible = true;
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

  List _fabs = new List();

  AnimationController animationController;
  Animation colorAnimation;


  @override
    void initState() {
      super.initState();
      dbHelper.create(); 
      setPrefs();  

      animationController = new AnimationController(vsync: this, duration: Duration(milliseconds: 200))
        ..addStatusListener((status){})..addListener(()=>setState((){}));

      colorAnimation = new ColorTween(begin: Color(0xFF4285f4), end: Color(0xFFea4335))
        .animate(CurvedAnimation(curve: Curves.linear, parent: animationController));
    }
      
    @override
    Widget build(BuildContext context) {
      save_recipes = [];
      _fabs = [
          SpeedDial(
            child: new AnimatedBuilder(
              animation: animationController,              
              child: Icon(Icons.add, color: Colors.white),
              builder: (BuildContext context, Widget _widget) {
                return new Transform.rotate(
                  angle: animationController.value * 0.75,
                  child: _widget,
                );
              },
            ),           
            animatedIconTheme: IconThemeData(size: 22.0),
            curve: Curves.fastOutSlowIn,
            backgroundColor: colorAnimation.value,
            children: [
              SpeedDialChild(
                child: Icon(Icons.create, color: Colors.white),
                backgroundColor: GoogleMaterialColors().getLightColor(0),
                label: "Erstellen",
                labelStyle: TextStyle(
                  fontFamily: "Google-Sans",
                  fontWeight: FontWeight.w500
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => new NewRecipe())
                  );
                }
              ),
              SpeedDialChild(
                child: Icon(Icons.save_alt, color: Colors.white),
                backgroundColor: GoogleMaterialColors().getLightColor(5),
                label: "Importieren",
                labelStyle: TextStyle(
                  fontFamily: "Google-Sans",
                  fontWeight: FontWeight.w500
                ),
                onTap: (){
                  getPath();
                }
              )
            ],
            onOpen: (){
              animationController.forward();
            },
            onClose: (){
              animationController.reverse();
            },
            tooltip: "Neues Rezept",
            visible: _dialVisible,            
          ),
          FloatingActionButton(            
            //Add recipe
            onPressed: (){
              openTermin(context);
            },
            child: Icon(
              Icons.add
            ),
            tooltip: "Neuer Termin",
          ),
          FloatingActionButton(
            onPressed: (){
              newShoppingItem();
            },
            child: Icon(
              Icons.add
            ),
            tooltip: "Neuer Artikel",
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
     * Save json file to app 
     */
    Future saveRecIngreIDs(int recipeID, int ingredientID, DBHelper db) async{
      RecIngre recIngre = new RecIngre();
      recIngre.idRecipes = recipeID;
      recIngre.idIngredients = ingredientID;

      await db.insertRecIngre(recIngre);
    }

    saveZutaten(List<ZutatenModel> zutaten, int recipeID, DBHelper db) async{
      IngredientsDB ingredients = new IngredientsDB();
      for(int i=0; i < zutaten.length; i++){
        ingredients.id = null;
        ingredients.number = zutaten[i].number;
        ingredients.measure = zutaten[i].measure;
        ingredients.name = zutaten[i].zutat;

        ingredients = await db.insertIngre(ingredients);
        await saveRecIngreIDs(recipeID, ingredients.id, db);
      }
    }

    saveRecStepsIDs(int recipeID, int stepsID, DBHelper db) async{
      RecipeSteps recipeSteps = new RecipeSteps();
      recipeSteps.idRecipes = recipeID;
      recipeSteps.idSteps = stepsID;

      recipeSteps = await db.insertRecipeSteps(recipeSteps);
    }

    saveZubereitung(List<ZubereitungModel> zubereitung, int recipeID, DBHelper db) async{
      StepsDB steps = new StepsDB();
      for(int i=0; i < zubereitung.length; i++){
        steps.id = null;
        steps.number = i;
        steps.description = zubereitung[i].steps;

        steps = await db.insertSteps(steps);
        await saveRecStepsIDs(recipeID, steps.id, db);
      }
    }

    saveRecipe(RecipesModel recipe, String filePath, DBHelper db) async{
      String imagepath;
      if(recipe.image != "no image") {
        Uint8List image = base64.decode(recipe.image).buffer.asUint8List();
        Directory directory = await getApplicationDocumentsDirectory();
        String imageName = recipe.name.replaceAll(new RegExp(r"\s+\b|\b\s"), "_");
        final file = await new File(directory.path+"/$imageName.png").create();
        await file.writeAsBytes(image);
        imagepath = directory.path+"/$imageName.png";
      } else {
        imagepath = recipe.image;
      }

      RecipesDB recipes = new RecipesDB();
      recipes.name = recipe.name;
      recipes.image = imagepath;
      recipes.definition = recipe.description;
      recipes.timestamp = DateTime.now().toString();
      recipes.pre_duration = recipe.preperation;
      recipes.cre_duration = recipe.creation;
      recipes.resting_time= recipe.resting;
      recipes.people = recipe.people;
      recipes.backgroundColor = recipe.backgroundColor;
      recipes.favorite = recipe.favorite; 

      recipes = await db.insertRecipe(recipes);
    }

    saveJsonToRecipe(RecipesModel recipe, List<ZubereitungModel> zubereitung, List<ZutatenModel> zutaten, String filePath) async{
      bool update = false;

      DBHelper db = new DBHelper();
      await db.create();
      int recipeCount = await db.checkRecipe(recipe.name);

      print("ZubereitungLength: ${zubereitung.length}");
      print("ZutatenLength: ${zutaten.length}");

      if(recipeCount == 0){
        await saveRecipe(recipe, filePath, db);
        int recipeID = await db.getRecipeID(recipe.name);
        await saveZubereitung(zubereitung, recipeID, db);
        await saveZutaten(zutaten, recipeID, db);
        if(prefs.getString("firstStart") == "false"){
          showBottomSnack("Rezept wurde erfolgreich importiert", ToastGravity.BOTTOM);
        } else {
          prefs.setString("firstStart", "false");
        }
      } else {
        showBottomSnack("Ein Rezept mit dem Namen ${recipe.name} existiert bereits", ToastGravity.BOTTOM);
      } 
      setState(() {
        update = true;
      });
    }

    createRecipeJson(File path) async{
      Map<String,dynamic> jSON;
      if(prefs.getString("firstStart") == "true") {
        jSON = json.decode(await rootBundle.loadString("start_recipe/Thunfischfilet.json"));              
      } else {
        jSON = json.decode(path.readAsStringSync());      
      }
      var recipe = RecipesModel.fromJson(jSON);
      var zubereitungJSON = recipe.zubereitung;
      var zutatenJSON = recipe.zutaten;    
      await saveJsonToRecipe(recipe, zubereitungJSON, zutatenJSON, path.path);
      setState(() {});
    }

    getPath() async{
      FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
        allowedFileExtensions: ['recipe'],
        invalidFileNameSymbols: ['/']
      );
      final path = await FlutterDocumentPicker.openDocument(params: params);
      File file = new File(path);
      createRecipeJson(file);
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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
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
        backgroundColor: Colors.white,
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
          Tooltip(
            message: "Löschen",
            child: Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                child: SvgPicture.asset(
                  "images/trash.svg",
                  color: Colors.black54,
                  height: 24.0,
                  width: 24.0,
                ),
                onTap: () => deleteDialog(indexList),
              ),
            ),
          )
        ],
        backgroundColor: Colors.white,
        leading: IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
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
          tooltip: "Abbrechen",
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          child: FlareActor(
                            "images/Sushi.flr",
                            alignment: Alignment.center,
                            fit: BoxFit.contain,
                            animation: 'Sushi Bounce',
                          )
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
          if(!searchActive) {
            return snapshot.data[a].name[0] == snapshot.data[b].name[0];
          }
          else return false;
        },
        itemCount: snapshot.data.length,
        headerBuilder: (BuildContext context, int index){
          if(snapshot.data[index].favorite == 1) {
            return Padding(
              padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 25.0),
              child: Icon(
                Icons.star,
                color: googleMaterialColors.primaryColor(),
              ),
            );
          } else {
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
          }
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

      Widget favorite;
      if(snapshot.data[index].favorite == 1) {
        favorite = Icon(Icons.star, color: googleMaterialColors.getLightColor(1));
      } else {
        favorite = Container();
      }

      key = new GlobalKey<StateSelectableItem>();

      map.putIfAbsent(index, () => key);

      return SelectableItems(
        key: key,
        color: usedColor,
        name: snapshot.data[index].name,
        title: (searchController.text.isEmpty
          ? Container(
            width: 300.0,
            child: Text(
              snapshot.data[index].name,
              overflow: TextOverflow.ellipsis,
            ),
          )
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
      DBHelper db = new DBHelper();
      var recipeCount = await db.countRecipes();
      if(recipeCount == 0) showBottomSnack("Um diese Aktion durchzuführen, müssen Rezepte vorhanden sein.", ToastGravity.BOTTOM);
      else {
        var returned = await Navigator.push(
            context,
            MaterialPageRoute(builder:  (context)=>RecipeSelection(recipeCount: recipeCount))
        );
        if(returned != null){
          DateTime _date = DateTime.now();
          final DateTime picked = await showMyDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(DateTime.now().day),
              lastDate: DateTime(DateTime.now().year+50)
          );
    
          if(picked != null && picked !=  _date && picked.isAfter(DateTime.now())){
            final dateFormat = new DateFormat('dd-MM-yyyy');
            for(int i=0; i<returned.length; i++){
              await saveTermin(returned[i], dateFormat.format(picked));
            }
            showBottomSnack("Termin wurde erfolgreich gespeichert", ToastGravity.BOTTOM);
          }
        }
      }
    }
  
    saveTermin(String recipe, String date)async{
      DBHelper db = new DBHelper();
      await db.create();
  
  
      TermineDB termine = new TermineDB();
  
      termine.terminDate = date;
      termine.notificationID = "0";
      termine.terminIntervall = await db.getIntervallID("onetime");
      termine = await db.insertTermine(termine);
  
      RecipeTermine recipeTermine = new RecipeTermine();  
      recipeTermine.idRecipes = await fetchSpecRecipe(recipe);
      recipeTermine.idTermine = termine.id;
      recipeTermine.intervallTyp = await db.getIntervallID("onetime");
      recipeTermine.createdTimestamp = DateTime.now().toString();
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
    String startUp = prefs.getString("firstStart");
    if(startUp == "true") {
      createRecipeJson(File("start_recipe/Thunfisch.json"));      
    }
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