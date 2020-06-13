import 'package:flutter/material.dart';
import 'package:fluttertodolistapp/models/todo.dart';
import 'package:fluttertodolistapp/services/todo_service.dart';
class TodoByCategory extends StatefulWidget {
  final String category;
  TodoByCategory({ this.category});

  @override
  _TodoByCategoryState createState() => _TodoByCategoryState();
}

class _TodoByCategoryState extends State<TodoByCategory> {
  List<Todo> _todoList=List<Todo>();
  TodoService _todoService= TodoService();
  @override
  void initState(){
    super.initState();
    getTodoByCategories();
  }
  getTodoByCategories()async{
    var todos = await _todoService.readTodoByCategory(this.widget.category);
    todos.forEach((todo){
      setState(() {
        var model=Todo();
        model.title=todo['title'];
        model.description=todo['description'];
        model.todoDate=todo['todoDate'];
        _todoList.add(model);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos by Category'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child:ListView.builder(
                  itemCount:_todoList.length,
                  itemBuilder: (context,index){
            return Padding(
              padding: EdgeInsets.only(top:8.0,right: 8.0,left:8.0 ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)
                ),
                elevation: 8,
                child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(_todoList[index].title)
                        ],
                      ),
                      subtitle: Text(_todoList[index].description),
                      trailing: Text(_todoList[index].todoDate),
                    ),
              ),
            );
          }))
        ],
      ),
    );
  }
}
