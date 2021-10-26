import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Auth with ChangeNotifier {
  String _token;
  DateTime _expireDate;
  String _userId;

bool get isAuth {
  return  token != null;
}

String get userId {
  return  _userId ;
}


String get token {
  if ( _expireDate != null &&  _expireDate.isAfter(DateTime.now()) && _token != null) {
    return _token;
  }
  return null;
}


  Future<void> authenticate(String emaill, String password) async {
    const apiKey = "AIzaSyDuGCBZfNAkymNArmUr2dvG6xzuWBxxZ-U";
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey');
  try {
    final rp = await http.post(url,
        body: json.encode({
          'email': emaill,
          'password': password,
          'returnSecureToken': true,
        }));
      final rpDecode = json.decode(rp.body);
        if (rpDecode['error'] != null) {
            throw HttpException(rpDecode['error']['message']);
           
        }
        _token =  rpDecode['idToken'];
        _userId =  rpDecode['localId'];
        _expireDate = DateTime.now().add(
          Duration(seconds: int.parse(rpDecode['expiresIn']))
        );
        notifyListeners();

        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          'token' : _token,
          'userId' : _userId,
          'expiryDate' : _expireDate.toIso8601String()
        });

        prefs.setString('userData', userData);

  } catch (e) {
     throw(e);
  }
   
  }

  Future<void> signup(String emaill, String password) async {
    const apiKey = "AIzaSyDuGCBZfNAkymNArmUr2dvG6xzuWBxxZ-U";
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey');


    print("emaill:$emaill\n password $password");

   final rp = await http.post(url,
        body: json.encode({
          'email': emaill,
          'password': password,
          'returnSecureToken': true,
        }));
        print(json.decode(rp.body));
  }

Future<void> autologin()  async {
  final prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey("userData")) {
    return false;
  }
  final extractedData =  json.decode(prefs.getString("userData") ) as Map<String,Object> ;
  final expiredDate =  DateTime.parse( extractedData['expiryDate']);
  if (expiredDate.isBefore(DateTime.now())) {
    return false;
  }
  _token = extractedData['token'];
  _userId =  extractedData['userId'];
  _expireDate =  expiredDate;
  notifyListeners();
return true;
}

  void logout () async {
    _token = null;
    _expireDate = null;
    _userId = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    notifyListeners();
  }
}
