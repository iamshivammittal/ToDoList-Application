import 'package:flutter/material.dart';
import 'package:fluttertodolistapp/models/todo.dart';
import 'package:fluttertodolistapp/services/category_service.dart';
import 'package:fluttertodolistapp/services/todo_service.dart';
import 'package:intl/intl.dart';

class ToDoScreen extends StatefulWidget {
  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  var _todoTitleController=TextEditingController();

  var _todoDateController=TextEditingController();
  var _todoDescriptionController=TextEditingController();

  var _selectedValue;

  var _categories=List<DropdownMenuItem>();
  final GlobalKey<ScaffoldState> _globalKey=GlobalKey<ScaffoldState>();
@override
  void   initState(){
  super.initState();
  _loadCategories();
}
  _loadCategories()async{
    var _categoryService=CategoryService();
    var categories=await _categoryService.readCategories();
    // ignore: unnecessary_statements
    categories.forEach((category){
      setState((){
        _categories.add(DropdownMenuItem(
          child:Text(category['name']),
          value: category['name'],
        ));
      });
    });
  }
 DateTime _dateTime= DateTime.now();
_selectedTodoData(BuildContext context) async{
  var _pickedDate= await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100));
   if(_pickedDate!=null){
     setState(() {
       _dateTime=_pickedDate;
       _todoDateController.text=DateFormat('yyyy-MM-dd').format(_pickedDate);
     });
   }
}
  _showSuccessSnackBar(message){
    var _snakeBar=SnackBar(content:message);
    _globalKey.currentState.showSnackBar(_snakeBar);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar:AppBar(
        title: Text('Create ToDo'),
      ),
      body: Padding(
        padding:  EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _todoTitleController,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Write ToDo title'
              ),
            ),
            TextField(
              controller: _todoDescriptionController,
              decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Write ToDo description'
              ),
            ),
            TextField(
              controller: _todoDateController,
              decoration: InputDecoration(
                  labelText: 'Date',
                  hintText: 'Pick a Date',
                prefixIcon: InkWell(
                  onTap: (){
                    _selectedTodoData(context);
                  },
                  child: Icon(Icons.calendar_today),
                ),
              ),
            ),
            DropdownButtonFormField(
              value: _selectedValue,
              items: _categories,
              hint:Text('Category'),
              onChanged: (value){
                setState(() {
                  _selectedValue=value;
                });
              },
            ),
            SizedBox(
              height:20,
            ),
            RaisedButton(
                onPressed:() async{
                  var todoObject= Todo();
                  todoObject.title= _todoTitleController.text;
                  todoObject.description= _todoDescriptionController.text;
                  todoObject.isFinished=0;
                  todoObject.category= _selectedValue.toString();
                  todoObject.todoDate= _todoDateController.text;

                  var _todoService=TodoService();
                  var result=await _todoService.saveTodo(todoObject);
                  if(result>1)
                    {
                      _showSuccessSnackBar(Text('Created'));
                    }
                  print(result);
                  },
                color:Colors.blue,
                child:Text('Save',
                  style:TextStyle(color:Colors.white),)
            )
          ],
        ),
      ),
    );
  }
}
