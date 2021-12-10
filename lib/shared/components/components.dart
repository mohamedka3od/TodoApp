import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/shared/cubit/cubit.dart';

/////////TextFormField//////////////////
Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  bool isPassword = false,
  TextInputAction onSubmit = TextInputAction.done,
  required FormFieldValidator validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function? suffixPressed,
  Function()? onTap,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onFieldSubmitted: (value) {
        onSubmit;
      },
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(onPressed: () => suffixPressed!(), icon: Icon(suffix))
            : null,
      ),
    );

/////////////////TaskItem/////////////////////
Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      onDismissed: (direction) {
        if(direction==DismissDirection.startToEnd ) {
          if(model['status']=='new' || model['status']=='archive') {
            AppCubit.get(context).updateData(status: "done", id: model['id']);
          }
          else{
            AppCubit.get(context).updateData(status: "archive", id: model['id']);
          }

        }
        else {
          AppCubit.get(context).deleteData(id: model['id']);
        }
      },
      background: Container(
        color: model['status']=='done'?Colors.grey:Colors.green,
        child: model['status']=='done'? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const[
            Icon(
              Icons.archive,
              size: 40.0,
            ),
            Text(
              "Archive",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ): Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const[
            Icon(
              Icons.done,
              size: 40.0,
            ),
            Text(
              "done",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        alignment: AlignmentDirectional.centerStart,
      ),
  secondaryBackground: Container(
    color: Colors.red,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const[
         Icon(
            Icons.delete,
        size: 40.0,
        ),
        Text(
          "Delete",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),

    alignment: AlignmentDirectional.centerEnd,
  ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.black,
              radius: 40.0,
              child: Text(
                '${model['time']}',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${model['date']}',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            IconButton(
              icon:  Icon(
                Icons.check_box,
                color: model['status'] == 'done'?Colors.green : Colors.green[100] ,
              ),
              onPressed: () {
                if(model['status']=='done'){
                  AppCubit.get(context).updateData(status: 'new', id: model['id']);
                }
                else{
                    AppCubit.get(context).updateData(status: 'done', id: model['id']);
                }
              },
            ),
            IconButton(
              icon: Icon(
                Icons.archive,
                color:model['status']=='archive'? Colors.black45 : Colors.black12,
              ),
              onPressed: () {
                AppCubit.get(context)
                    .updateData(status: 'archive', id: model['id']);
              },
            ),
          ],
        ),
      ),
    );

///////////////////tasks builder///////////////////////

Widget tasksBuilder({
  required List<Map> tasks ,
  String text ="No Tasks Yet, Lets Add Some Tasks",
}) => ConditionalBuilder(
      condition: tasks.isNotEmpty,
      builder: (context) => ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
          separatorBuilder: (context, index) => Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
          itemCount: tasks.length),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            const Icon(
              Icons.menu,
              size: 100.0,
              color: Colors.grey,
            ),
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
