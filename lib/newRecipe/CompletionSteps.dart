//Created at 26.09.18 by stnieder


import 'package:flutter/material.dart';
import 'package:recipe/interface/PageIndicator.dart';
import 'package:recipe/newRecipe/Allgemein.dart';
import 'package:recipe/newRecipe/Zubereitung.dart';
import 'package:recipe/newRecipe/Zutaten.dart';

class CompletionSteps extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CompletionSteps();
}

class _CompletionSteps extends State<CompletionSteps> with TickerProviderStateMixin{
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Media: "+MediaQuery.of(context).size.width.toString());

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          child: Container(),
          preferredSize: Size.fromHeight(2.0),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Allgemein(),

          ],
        ),
        resizeToAvoidBottomPadding: false,
      ),
    );
  }
}