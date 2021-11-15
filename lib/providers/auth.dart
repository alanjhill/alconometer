import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:alconometer/models/http_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String apiKey = 'AIzaSyDlTh1GtYEHShA5a7GtFvTBAdlFHPsC9J8';

class Auth with ChangeNotifier {
  String? _token;
  String? _refreshToken;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    if (token != null) {
      return true;
    }
    return false;
  }

  String? get userId {
    return _userId;
  }

  String? get token {
    if (_expiryDate != null && _expiryDate!.isAfter(DateTime.now()) && _token != null && _refreshToken != null) {
      return _token!;
    }
    refreshSession();
    return null;
  }

  Future<void> _authenticate(String email, String password, String urlSegment) async {
    final url = Uri.https(
      'identitytoolkit.googleapis.com',
      urlSegment,
      {
        'key': apiKey,
      },
    );

    try {
      // POST and get the response
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      debugPrint(response.body);
      final responseData = json.decode(response.body);
      debugPrint('responseData: $responseData');
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _userId = responseData['localId'];
      _token = responseData['idToken'];
      _refreshToken = responseData['refreshToken'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      debugPrint('_expiryDate: $_expiryDate');
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'refreshToken': _refreshToken,
          'userId': _userId,
          'expiryDate': _expiryDate!.toIso8601String(),
        },
      );
      debugPrint('save userData: $userData');
      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, '/v1/accounts:signUp');
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(email, password, '/v1/accounts:signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    debugPrint('>>> tryAutoLogin >>>');
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final String? userDataStr = prefs.getString('userData');
    final extractedUserData = json.decode(userDataStr!) as Map<String, dynamic>?;
    final String? expiryDate = extractedUserData!['expiryDate'] as String;
    final parsedExpiryDate = DateTime.parse(expiryDate!);
    if (parsedExpiryDate.isBefore(DateTime.now())) {
      return false;
    }
    debugPrint('retrieve userData: $extractedUserData');
    _token = extractedUserData['token'] as String;
    _refreshToken = extractedUserData['refreshToken'];
    _userId = extractedUserData['userId'] as String;
    _expiryDate = parsedExpiryDate;
    notifyListeners();
    //_autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'refreshToken': _refreshToken,
    });
    prefs.setString('userData', userData);
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now());
    _authTimer = Timer(
      timeToExpiry,
      () {
        debugPrint('Timer Expired, about to logout');
        logout();
      },
    );
  }

  Future<void> refreshSession() async {
    final dio = Dio(
      BaseOptions(baseUrl: 'https://securetoken.googleapis.com', headers: {'Accept': 'application/json', "Content-Type": "application/x-www-form-urlencoded"}),
    );

    try {
      final response = await dio.post(
        '/v1/token',
        queryParameters: {'key': apiKey},
        data: 'grant_type=refresh_token&refresh_token=$_refreshToken',
      );

      final responseData = Map<String, dynamic>.from(response.data);
      if (responseData['error'] != null) {
        debugPrint('$_refreshToken');
        debugPrint('responseData: $responseData');
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['id_token'];
      _refreshToken = responseData['refresh_token']; // Also save your refresh token
      _userId = responseData['user_id'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expires_in'])));
      _autoLogout();

      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'refreshToken': _refreshToken,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } on DioError catch (error) {
      debugPrint('refreshToken: $_refreshToken');
      debugPrint('!!! Error: $error, ${error.message}, ${error.response}');
      rethrow;
    }
  }

  Future<void> _refreshSession() async {
    final url = Uri.https(
      'securetoken.googleapis.com',
      '/v1/token',
      {
        'key': apiKey,
      },
    );

    try {
      final response = await http.post(
        url,
        //headers: {"Accept": "application/json", "Content-Type": "application/x-www-form-urlencoded"},
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: 'grant_type=refresh_token&refresh_token=$_refreshToken',
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        debugPrint('responseData: $responseData');
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['id_token'];
      _refreshToken = responseData['refresh_token']; // Also save your refresh token
      _userId = responseData['user_id'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expires_in']))).subtract(Duration(minutes: 10));
      _autoLogout();

      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'refreshToken': _refreshToken,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }
}
