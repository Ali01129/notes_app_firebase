import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //firebase
  final FirestoreService firestoreService=FirestoreService();

  //text controller
  final TextEditingController textController=TextEditingController();

  void createNote({String? docID}){

    showDialog(context: context, builder: (context)=>AlertDialog(
      backgroundColor: Colors.white,
     content: TextField(
       controller: textController,
     ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),

      actions: [
        ElevatedButton(
          onPressed: (){
            if(docID==null){
              firestoreService.addNote(textController.text);
            }
            else{
              firestoreService.updateNote(docID, textController.text);
            }
            //after adding clear text controller
            textController.clear();
            //close the alertbox
            Navigator.pop(context);
          },
          child: Text("Add",style: TextStyle(color: Colors.white),),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )
          ),
        ),
      ],

    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Notes")),
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        child: Icon(Icons.add,color: Colors.white,),
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNoteStream(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            List noteslist=snapshot.data!.docs;
            return ListView.builder(
              itemCount: noteslist.length,
              itemBuilder: (context,index){
                DocumentSnapshot document=noteslist[index];
                String docId=document.id;

                //get note form each doc
                Map<String,dynamic> data=document.data() as Map<String,dynamic>;
                String noteText=data['note'];
                return ListTile(
                  title: Text(noteText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: ()=> createNote(docID: document.id),
                          icon: Icon(Icons.note_alt_rounded)
                      ),
                      IconButton(
                          onPressed: ()=> firestoreService.deleteNote(document.id),
                          icon: Icon(Icons.delete)
                      ),
                    ],
                  ),
                );
              },
            );
          }
          else{
            return Text("No Data...");
          }
        },
      ),


    );
  }
}
