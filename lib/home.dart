import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/services/firestore.dart';
import 'package:flutter/material.dart';
class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}


class _MyHomeState extends State<MyHome> {

  //firestore
  FirestoreService firestoreService=FirestoreService();

  // Text controller
  final TextEditingController textController = TextEditingController();

  //open dialog box add to note

  void OpenNoteBox({docId}){
    showDialog(context: context, builder: (context)=> AlertDialog(
      content: TextField(
        controller: textController,
      ),
      actions: [
        ElevatedButton(onPressed: (){

          // add a new note

          if(docId==null){
            firestoreService.addNote(textController.text);
          }else{
            firestoreService.updateNote(docId, textController.text);
          }

          //clear the text controller
          textController.clear();

          //close the box
          Navigator.pop(context);

        }, child: Text("Add"))
      ],
    ),
    );
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Note",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNoteStream(),

        builder:(context,snapshot){
          //if we have data get all docs
          if(snapshot.hasData){
            List noteList=snapshot.data!.docs;
            return ListView.builder(
              itemCount: noteList.length,
                itemBuilder: (context,index) {

              //get each individual docs
              DocumentSnapshot document = noteList[index];
              String docId = document.id;

              //get note from each docs
              Map<String, dynamic> data = document.data() as Map<String,
                  dynamic>;

              String noteText = data["note"];

              //display as a listTile
              return ListTile(
                title: Text(noteText),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //update
                    IconButton(onPressed: ()=>OpenNoteBox(docId: docId), icon: Icon(Icons.settings)),
                    IconButton(onPressed: ()=>firestoreService.deleteNote(docId), icon: Icon(Icons.delete)),
                  ],
                ),
              );
            }
            );

          }


          else{
          return Text("No Notes");
          }

        }

      ),

      floatingActionButton: FloatingActionButton(
        onPressed: OpenNoteBox,
        child: Icon(Icons.add),
      ),
    );
  }
}




