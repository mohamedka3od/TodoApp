// ignore_for_file: avoid_print
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/shared/components/components.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
import 'package:todoapp/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
   HomeLayout({Key? key}) : super(key: key);



  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final dateController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context,AppStates state) {
          if(state is AppInsertDataBase){
            Navigator.pop(context);
            titleController.clear();
            dateController.clear();
            timeController.clear();
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.black45,
              title: Text(
                  cubit.titles[cubit.currentIndex]
              ),
            ),
            body: ConditionalBuilder(
              condition:state is AppCreateDataBase,
              builder: (BuildContext context) =>const Center(child: CircularProgressIndicator()),
              fallback: (BuildContext context) => cubit.screens[cubit.currentIndex],
            ),
            //tasks.isEmpty? const Center(child: CircularProgressIndicator()) :  screens[currentIndex],
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: (){
                if(cubit.isBottomSheetShown){
                  if(formKey.currentState!.validate()){
                    cubit.insertToDataBase(
                      title: titleController.text ,
                      date: dateController.text ,
                      time: timeController.text ,

                    );
                  }
                }
                else{
                  scaffoldKey.currentState!.showBottomSheet(
                        (context) => Container(
                      padding: const EdgeInsetsDirectional.all(20.0),
                      child: SingleChildScrollView(
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultFormField(
                                controller: titleController,
                                type: TextInputType.text,
                                validate: (value){
                                  if(value.isEmpty) {
                                    return 'title must not be empty';
                                  }
                                  return null;
                                },
                                label: 'Task Title',
                                prefix: Icons.title,
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              defaultFormField(
                                controller: timeController,
                                type: TextInputType.none,
                                onTap: (){
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value) {
                                    if(value!=null) {
                                      timeController.text = value.format(context).toString();
                                    }
                                  });
                                },
                                validate: (value){
                                  if(value.isEmpty) {
                                    return 'time must not be empty';
                                  }
                                  return null;
                                },
                                label: 'Task Time',
                                prefix: Icons.watch_later_outlined,
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              defaultFormField(
                                controller: dateController,
                                type: TextInputType.none,
                                onTap: (){
                                  showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(const Duration(days: 365*100))).then(
                                          (value) {
                                        if(value!=null) {
                                          dateController.text = DateFormat.yMMMd().format(value);
                                        }

                                      });

                                },
                                validate: (value){
                                  if(value.isEmpty) {
                                    return 'date must not be empty';
                                  }
                                  return null;
                                },
                                label: 'Task Date',
                                prefix: Icons.calendar_today,
                              ),
                            ],

                          ),
                        ),
                      ),
                    ),
                    elevation:20.0,
                  ).closed.then((value) {
                    cubit.changeBottomSheetState(isShown: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShown: true, icon: Icons.add);

                }

              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index){
                cubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.menu,),
                    label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline,),
                    label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive,),
                    label: 'Archived'),
              ],
            ),
          );
        },

      ),
    );
  }


}




