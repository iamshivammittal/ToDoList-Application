import 'package:fluttertodolistapp/models/todo.dart';
import 'package:fluttertodolistapp/repositories/repository.dart';

class TodoService{
  Repository _repository;
  TodoService(){
    _repository=Repository();
  }
  //create todos
  saveTodo(Todo todo) async{
    return await _repository.insertData('todos', todo.todoMap());
  }

  //read todos
readTodo()async{
    return await _repository.readData('todos');
}

//read todos by category
readTodoByCategory(category)async{
    return await _repository.readDataByColumnName(
        'todos', 'category', category);
}
}