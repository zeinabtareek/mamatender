import 'package:firebase_database/firebase_database.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ChatController extends GetxController{
  final firebaseDB=FirebaseDatabase.instance;
final messegesList=[];
  @override
    onInit() {
    getMessages();
  }

  getMessages()async{
    var result =await firebaseDB.reference().child('messages').get();
    result.value.forEach((key,  value){
      messegesList.add(value);
       print(value);
       print(messegesList.length);
        });
    update();


  }

  
}