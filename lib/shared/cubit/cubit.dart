


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todoapp/modules/done_tasks/done_tasks_screen.dart';
import 'package:todoapp/modules/new_tasks/new_tasks_screen.dart';
import 'package:todoapp/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit():super(AppInitState());

 static AppCubit get(context)=> BlocProvider.of(context);
  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archiveTasks=[];

  int currentIndex= 0;
  List <Widget> screens =[
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen(),
  ];
  List <String> titles=[
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index){
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }
  late Database database;
  void createDataBase(){
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database ,version){
        print('database created');
        database.execute('create table tasks (id integer primary key , title text, date text , time text , status text )')
            .then((value) => print('table created'))
            .catchError((error){
          print('error wen creating table ${error.toString()}');
        });
      },
      onOpen: (database){
        getDataFromDataBase(database);
        print('database opened');

      },
    ).then((value){
      database =value;
      emit(AppCreateDataBase());
    });
  }

  Future insertToDataBase({
    required String title,
    required String time,
    required String date,
  }) async{
    return await database.transaction((txn) async{
      txn.rawInsert(
          'insert into tasks(title , date , time , status) values ("$title","$date","$time","new")'
      ).then((value) {
        print('$value inserted successfully');
        emit(AppInsertDataBase());
        getDataFromDataBase(database);
      }).catchError((error){
        print('error wen inserting new record ${error.toString()}');
      });
    });
  }

  void getDataFromDataBase(database) async{
    emit(AppGetDataBaseLoadingState());
    // await Future.delayed(const Duration(seconds: 5), (){print("done---");});
    database.rawQuery('select * from tasks').then((value) {
      newTasks=[];
      doneTasks=[];
      archiveTasks=[];
      value.forEach((element){
        if(element['status']=='new'){
          newTasks.add(element);
        }
        else if(element['status']=='done'){
          doneTasks.add(element);
        }
        else {
          archiveTasks.add(element);
        }
      });
      emit(AppGetDataBase());
    });

  }

  void updateData({
    required String status,
    required int id ,
})async{
     database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        [status, id]).then((value) {
          emit(AppUpdateDataBase());
     }).then((value) {
       getDataFromDataBase(database);
     });

  }

  void deleteData({
    required int id ,
  })async{
    database.rawDelete(
        'DELETE FROM tasks WHERE id = ?',
        [id]).then((value) {
      emit(AppDeleteDataBase());
    }).then((value) {
      getDataFromDataBase(database);
    });

  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  void changeBottomSheetState({
  required bool isShown,
  required IconData icon,
}){
    isBottomSheetShown = isShown;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }


}