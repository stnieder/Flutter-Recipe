import 'dart:convert';

import 'package:Time2Eat/Import/Imported.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImportRecipe extends StatefulWidget {
  @override
  _ImportRecipeState createState() => _ImportRecipeState();
}

class _ImportRecipeState extends State<ImportRecipe> {
  TextEditingController searchController = new TextEditingController();
  List<Post> postList = new List();

  @override
    void dispose() {
      super.dispose();
      searchController.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,        
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black54),
          onPressed: (){
            Navigator.pop(context);
          },       
        ),
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Ein Rezept suchen",            
          ),
          onChanged: (String text){
            //call to the api and list results

          },
        ),
      ),
      body: FutureBuilder<Post>(
        future: fetchPost(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return Text(snapshot.data.title);
          } else if(snapshot.hasError){
            return Text("${snapshot.error}");
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }

  Future<Post> fetchPost() async {
    final response = await http.get('https://jsonplaceholder.typicode.com/posts/1');

    if(response.statusCode == 200){
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load");
    }
  }

}