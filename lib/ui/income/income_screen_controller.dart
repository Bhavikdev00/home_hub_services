import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:home_hub_services/ModelClasses/OrderResModel.dart';

import '../../ModelClasses/user.dart';
import '../../getstorage/StorageClass.dart';

class IncomeController extends GetxController{

  RxList<OrderResModel> order;
  final StorageService _storageService = StorageService();
  IncomeController(this.order);
  RxList<UserData> user = <UserData>[].obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadUserData(order);
  }

  RxBool isLoading =false.obs;

  Future<void> loadUserData(RxList<OrderResModel> order) async {
    isLoading.value = true;
    CollectionReference serviceProviderUserCollection = FirebaseFirestore.instance.collection("User");
    for(var DataOrder in order){
      OrderResModel order = DataOrder;
      QuerySnapshot userData = await serviceProviderUserCollection.where("uId", isEqualTo: DataOrder.userId).get();
      if(userData.docs.isNotEmpty){
        UserData userDatas = UserData.fromJson(userData.docs.first.data() as Map<String, dynamic>);
        user.add(userDatas);
      }
    }
    isLoading.value = false;
    update();
  }


  sendMoney(int amount) async {
    DateTime dateTime = DateTime.now();
    String prividerId = _storageService.getUserid();
    var time = Timestamp.fromDate(dateTime);
    DocumentReference documentReference =await FirebaseFirestore.instance.collection("Payment_request").add({
      "date" : time,
      "ProviderId" : prividerId,
      "amountWithdraw" : amount,
      "type" : "withdraw"
    });

  }
}