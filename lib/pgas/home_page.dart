import 'package:flutter/material.dart';
import 'package:sqlfl/db/bd_admin.dart';
import 'package:sqlfl/models/task_model.dart';
import 'package:sqlfl/widgets/my_form_widget.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<String> getFullname() async{
    return "Juan Jose";
  }

  showDialogForm(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return MyFormWidget();
        },
    ).then((value){
      setState(() {
        
      });
    });
  }

  deleteTask( int taskId){

    DBAdmin.db.deleteTask(taskId).then((value){
      if(value>0){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.indigo,
          content: Row(
            children: const[
              Icon(Icons.check_circle, color: Colors.white,),
              SizedBox(width: 10.0,),
              Text("Tarea eliminada"),
            ],
          )
          ,),);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('Hola'),
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialogForm();
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
       future: DBAdmin.db.getTasks(),
       builder: (BuildContext context, AsyncSnapshot snap){
         if(snap.hasData) {
           List<TaskModel> myTasks = snap.data;
           return ListView.builder(
             itemCount: myTasks.length,
             itemBuilder: (BuildContext context, int index){
               return Dismissible(
                 key: UniqueKey(),
                 // confirmDismiss: (DismissDirection direction)async{
                 //   return true;
                 // },
                 direction: DismissDirection.startToEnd,
                 background: Container(color: Colors.redAccent,),
                 onDismissed: (DismissDirection direction){
                   deleteTask(myTasks[index].id!);
                 },
                 child: ListTile(
                   title: Text(myTasks[index].title),
                   subtitle: Text(myTasks[index].description),
                   trailing: IconButton(
                     onPressed: (){
                       showDialogForm();
                     },
                     icon: Icon(Icons.edit),
                   ),
                 ),
               );
             },
           );
         }
           return const Center(
             child: CircularProgressIndicator(),
           );

       },
     ),
    );
  }
}
---widgets
my_form_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:sqlfl/db/bd_admin.dart';
import 'package:sqlfl/models/task_model.dart';

class MyFormWidget extends StatefulWidget {
  const MyFormWidget({Key? key}) : super(key: key);

  @override
  State<MyFormWidget> createState() => _MyFormWidgetState();
}

class _MyFormWidgetState extends State<MyFormWidget> {
  final _formKey = GlobalKey<FormState>();
  bool isFinished = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  addTask() {
    if(_formKey.currentState!.validate()){
      TaskModel taskModel = TaskModel(title: _titleController.text, description: _descriptionController.text, status: isFinished.toString());
      DBAdmin.db.insertTask(taskModel).then((value){
        if(value > 0){
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                behavior: SnackBarBehavior.fixed,
                backgroundColor: Colors.greenAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                duration: const Duration(milliseconds: 1400),
                content: Row(
                  children: const[
                    Icon(Icons.check_circle, color: Colors.white,),
                    SizedBox(width: 10.0,),
                    Text("Tarea registrada con exito"),
                  ],
                )
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Agregar tarea"),
            const SizedBox(
              height: 6.0,
            ),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(hintText: "Titulo"),
              validator: (String? value){
                if(value!.isEmpty){
                  return "El campo es obligatorio";
                }
                if(value.length <6){
                  return "Debe tener mas de 3 caracteres";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 6.0,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(hintText: "Descripcion"),
              validator: (String? value){
                if(value!.isEmpty){
                  return "El campo es obligatorio";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 6.0,
            ),
            Row(
              children: [
                const Text("Estado: "),
                SizedBox(
                  width: 6.0,
                ),
                Checkbox(
                    value: isFinished,
                    onChanged: (value) {
                      isFinished = value!;
                      setState(() {});
                    }),
              ],
            ),
            SizedBox(
              height: 6.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancelar",
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    addTask();

                  },
                  child: Text(
                    "Aceptar",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}