import 'package:flutter/material.dart';
import 'package:fluttertodolistapp/screens/categories_screen.dart';
import 'package:fluttertodolistapp/screens/home_screen.dart';
import 'package:fluttertodolistapp/screens/todo_by_category.dart';
import 'package:fluttertodolistapp/services/category_service.dart';

class DrawerNavigation extends StatefulWidget {
  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  List<Widget> _categoryList=List<Widget>();
  CategoryService _categoryService = CategoryService();
  @override
  initState(){
    super.initState();
    getAllCategories();
  }
  getAllCategories()async{
    var categories=await _categoryService.readCategories();
    categories.forEach((category){
      setState(() {
        _categoryList.add(InkWell(
          onTap: ()=>Navigator.push(
              context,
              new MaterialPageRoute(
                  builder:(context)=> new TodoByCategory(category:category['name'],))),
          child: ListTile(
            title: Text(category['name']),
          ),
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage:NetworkImage('https://photos.app.goo.gl/8bvgKi1Q1c7wYfGK7'),
              ),
                accountName: Text('Shivam Mittal'),
                accountEmail: Text('admin@shivammittal'),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: ()=>Navigator.of(context)
                  .push(MaterialPageRoute(builder:(context)=>HomeScreen())),
            ),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text('Categories'),
              onTap: ()=>Navigator.of(context)
                  .push(MaterialPageRoute(builder:(context)=>CategoriesScreen())),
            ),
            Divider(),
            Column(
              children: _categoryList,
            ),
          ],
        ),
      )
    );
  }
}
