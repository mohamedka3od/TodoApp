import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/shared/components/components.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
import 'package:todoapp/shared/cubit/states.dart';

class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit,AppStates>(
      listener: (BuildContext context,AppStates  state) {  },
      builder: (BuildContext context, AppStates state) {
        var  tasks = AppCubit.get(context).archiveTasks;
        return tasksBuilder(
            tasks: tasks,
            text: "No Archive Tasks ...",
        );
      },

    );
  }
}
