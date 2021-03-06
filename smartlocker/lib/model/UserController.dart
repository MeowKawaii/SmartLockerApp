import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'dart:io';
class UserController{
  final httpClient = new Client();
  final String host = "http://139.59.242.154:8888";
  Future<Map> login(String userName,String userPassword) async {
    String url ='$host/v1.1/users/login';
    Map data ={
      'username': userName,
      'password': userPassword
    };
    var response = await httpClient.post(url,body:jsonEncode(data),headers: {"Content-Type": "application/json"}); 
    print('Response login status: ${response.statusCode}');
    var  result = new Map();
    if(response.statusCode==200){
      result = jsonDecode(response.body);
      result['success'] = true;
    }else{
      result['success'] = false;
      result['error'] = response.body;
    }
    return result; 
  }
  Future<Map> getRecentRequest(String token) async {
    String url ='$host/v1.1/me/requests?limit=1&order=id:DESC';
    var response = await httpClient.get(url,headers: {HttpHeaders.authorizationHeader: token}); 
    print('Response recent status: ${response.statusCode}');
    var  result = new Map();
    var tmpResult;
    if(response.statusCode==200){
      tmpResult = jsonDecode(response.body);
      if(tmpResult.toString() == '[]'){
        result['state'] = null;
      }else{
        result = tmpResult[0];
      }
      result['success'] = true;
    }else{
      result['success']=false;
      result['error']=response.body;
    }
    return result; 
  }
  Future<Map> updateFcmToken(String token,String fcmToken) async {
    String url ='$host/v1.1/me';
    Map data ={
      'FCM_token':fcmToken
    };
    var response = await httpClient.put(url,body:jsonEncode(data),headers: {"Content-Type": "application/json",HttpHeaders.authorizationHeader: token}); 
    //print('Response status: ${response.statusCode}');
    var  result = new Map();
    if(response.statusCode==200){
      result = jsonDecode(response.body);
      result['success'] = true;
    }else{
      result['success']=false;
      result['error']=response.body;
    }
    return result; 
  }
  
}
