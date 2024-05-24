import 'package:flutter/material.dart';
import 'package:sqflite_app/services/sqflite_services.dart';

import '../models/task_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SqlService _databaseService = SqlService.sqlDataBase;

  // to check whether our database class is singleton or not
  // ---------------------------------------------
  // SqlService ss1 = SqlService.sqlDataBase;

  // SqlService ss2 = SqlService.sqlDataBase;

  // -----------------------------------------------

  String? _task;

  @override
  Widget build(BuildContext context) {
    // to check whether our database class is singleton or not
    // if (ss1 == ss2) {
    //   print('true');
    // } else {
    //   print('false');
    // }

    return Scaffold(
      body: screen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('============');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Text to show'),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _task = value;
                      });
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Your task to be done'),
                  ),
                  MaterialButton(
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      if (_task == null || _task == "") {
                        Navigator.pop(context);

                        return;
                      } else {
                        _databaseService.addTask(_task!);
                        // print(_task);
                        _databaseService.getTask();
                        setState(() {
                          _task = null;
                        });
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('Done'),
                  ),
                ]),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget screen() {
    return FutureBuilder(
      future: _databaseService.getTask(),
      builder: (context, snapshot) {
        return snapshot.data == null || snapshot.data!.isEmpty
            ? const SafeArea(
                child: Center(
                  child: Text('No data Found'),
                ),
              )
            : ListView.builder(
                // shrinkWrap: true,
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index) {
                  Task data = snapshot.data![index];
                  return ListTile(
                    leading: ElevatedButton(
                      child: Text(data.taskId.toString()),
                      onPressed: () {
                        _databaseService.deleteDatabase(data.taskId);
                        setState(() {});
                      },
                    ),
                    title: Text(data.taskContent),
                    trailing: Checkbox(
                      value: data.taskStatus == 1,
                      onChanged: (value) {
                        _databaseService.updateDatabase(
                            data.taskId, value == true ? 1 : 0);
                        // _databaseService.getTask();

                        setState(() {});
                      },
                    ),
                  );
                },
              );
      },
    );
  }
}
