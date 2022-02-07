import 'dart:io';

import 'package:alconometer/providers/top_level_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthMode { signup, login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Colors.black.withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: const AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends ConsumerStatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends ConsumerState<AuthCard> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  AnimationController? _animationController;
  Animation<Size>? _heightAnimation;
  Animation<Offset>? _slideAnimation;
  Animation<double>? _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _heightAnimation = Tween<Size>(begin: const Size(double.infinity, 260), end: const Size(double.infinity, 320))
        .animate(CurvedAnimation(parent: _animationController!, curve: Curves.fastOutSlowIn));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, -1.5), end: const Offset(0, 0))
        .animate(CurvedAnimation(parent: _animationController!, curve: Curves.fastOutSlowIn));
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController!, curve: Curves.fastOutSlowIn));
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _animationController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        height: _authMode == AuthMode.signup ? 320 : 260,
        constraints: BoxConstraints(minHeight: _authMode == AuthMode.signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                  initialValue: 'alanjhill@hotmail.com',
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  //controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                  initialValue: 'password',
                ),
                if (_authMode == AuthMode.signup)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    constraints: BoxConstraints(minHeight: _authMode == AuthMode.signup ? 60 : 0, maxHeight: _authMode == AuthMode.signup ? 120 : 0),
                    child: FadeTransition(
                      opacity: _opacityAnimation!,
                      child: SlideTransition(
                        position: _slideAnimation!,
                        child: TextFormField(
                          enabled: _authMode == AuthMode.signup,
                          decoration: const InputDecoration(labelText: 'Confirm Password'),
                          obscureText: true,
                          validator: _authMode == AuthMode.signup
                              ? (value) {
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match!';
                                  }
                                }
                              : null,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    child: Text(_authMode == AuthMode.login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                  ),
                TextButton(
                  child: Text('${_authMode == AuthMode.login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An error occurred'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.login) {
        // Log user in
        await ref.read(authenticationServiceProvider).signInWithEmailAndPassword(
              email: _authData['email']!,
              password: _authData['password']!,
            );
      } else {
        // Sign user up
        await ref.read(authenticationServiceProvider).createUserWithEmailAndPassword(
              email: _authData['email']!,
              password: _authData['password']!,
            );
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      switch (error.toString()) {
        case 'EMAIL_EXISTS':
          errorMessage = 'The email address is already in use.';
          break;
        case 'INVALID_EMAIL':
          errorMessage = 'This is not a valid email address.';
          break;
        case 'WEAK_PASSWORD':
          errorMessage = 'The password is too weak.';
          break;
        case 'EMAIL_NOT_FOUND':
          errorMessage = 'Could not find a user with that email and password.';
          break;
        case 'INVALID_PASSWORD':
          errorMessage = 'Could not find a user with that email and password.';
          break;
        default:
          errorMessage = 'Could not authenticate you.  Please try again later:\n ${error.toString()}';
      }
      debugPrint('!!! $error, $errorMessage');
      _showErrorDialog(errorMessage);
    } catch (error) {
      var errorMessage = 'Could not authenticate you.  Please try again later:\n ${error.toString()}';
      debugPrint('!!! $error, $errorMessage');
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
      _animationController!.forward();
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
      _animationController!.reverse();
    }
  }
}
