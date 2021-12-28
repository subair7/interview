import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../network/Api/api_handler.dart';
import '../network/Response/post_response.dart';

class PostProvider extends ChangeNotifier {
  bool isFetching = true;

  List<PostResponse> _getPostResponse = [];

  addPost(PostResponse data){
    _getPostResponse.insert(0,data);
    notifyListeners();
  }

  removePost(int index){
    _getPostResponse.removeAt(index);
    notifyListeners();
  }

  setPostResponse(List<PostResponse> data) {
    _getPostResponse.addAll(data);
    print('list : ${_getPostResponse.toString()}');
    isFetching = false;
    notifyListeners();
  }

  List<PostResponse> getPostResponse() {
    return _getPostResponse;
  }

  void fetchPost(BuildContext context) async {
    try {
      var getPostResponse = await ApiHandler.fetchPost(context);
      setPostResponse(getPostResponse!);
    } catch (e) {
      print("PostFetch() -> ${e.toString()}");
    }
    /*  Navigator.push(context, MaterialPageRoute(builder: (context) => Home()),);*/
  }
}
