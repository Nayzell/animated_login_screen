import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../configurations/blocs/blocs.dart';
import '../configurations/services/services.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

FocusNode myFocusNode = new FocusNode();
FocusNode myFocusNode1 = new FocusNode();

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container( //Background
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/GIFA.gif"),
              fit: BoxFit.cover,
            ),
          ),

          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              final authBloc = BlocProvider.of<AuthenticationBloc>(context);
              if (state is AuthenticationNotAuthenticated) {
                return _AuthForm();
              }
              if (state is AuthenticationFailure) {
                return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(state.message),

                        FlatButton(
                          textColor: Theme.of(context).primaryColor,
                          child: Text('Retry'),
                          onPressed: () {
                            authBloc.add(AppLoaded());
                          },
                        )
                      ],
                    ));
              }
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              );
            },
          )),
    );
  }
}

class _AuthForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = RepositoryProvider.of<AuthenticationService>(context);
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return Container(
      alignment: Alignment.center,
      child: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(authBloc, authService),
        child: _SignInForm(),
      ),
    );
  }
}
class _SignInForm extends StatefulWidget {
  @override
  __SignInFormState createState() => __SignInFormState();
}

class __SignInFormState extends State<_SignInForm> with TickerProviderStateMixin{
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool _autoValidate = false;

  AnimationController _controller;

  @override
  final player = AudioCache();
  void initState() {
    super.initState();

    _controller = AnimationController(

        vsync: this,
        lowerBound: 0.40,
        upperBound: 0.50,
        duration: Duration(milliseconds: 30) );
    _emailController.addListener(() {
      _controller.forward().then((value) => _controller.reverse());
      player.play('PAD1.wav'); // Plays a sound when the user enters an input of string on the text field
    });
    _passwordController.addListener(() {
      _controller.forward().then((value) => _controller.reverse());
      player.play('PAD1.wav'); // Plays a sound when the user enters an input of string on the text field
    });

  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override

  Widget build(BuildContext context) {
    final _loginBloc = BlocProvider.of<LoginBloc>(context);

    _onLoginButtonPressed() {
      if (_key.currentState.validate()) {
        _loginBloc.add(LoginInWithEmailButtonPressed(email: _emailController.text, password: _passwordController.text));
      } else {
        setState(() {
          _autoValidate = true;
        });
      }
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          _showError(state.error);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoginLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            margin: const EdgeInsets.only(top: 0, bottom: 0, right: 100, left: 100),
            child: Form(
              key: _key,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Lottie.network(
                      'https://assets5.lottiefiles.com/packages/lf20_rycdh53q.json',
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      width: 250.0,
                      child: TypewriterAnimatedTextKit(
                        onTap: () {
                          print("Tap Event");
                        },
                        text: [
                          "Discipline is the best tool",
                          "Design first, then code",
                          "Don't patch bugs, rewrite them",
                          "Don't test bugs, design them out",
                        ],
                        textStyle: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 150,
                    ),
                    TextFormField(
                      focusNode: myFocusNode,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        hintText: 'Enter Email', // Displays a hint text as to what the user must input on the textfield
                        hintStyle: TextStyle(color: Colors.white),
                        labelStyle: TextStyle(color: myFocusNode.hasFocus ? Color(0xffC2E2EC) : Colors.white , fontSize: 15),
                        contentPadding: EdgeInsets.all(20),
                        filled: false,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xffFFFFFF), width: 2.0),
                        ),
                      ),

                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      validator: (value) {
                        if (value == null) {
                          return 'Email is required.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      focusNode: myFocusNode1,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter Password',
                        hintStyle: TextStyle(color: Colors.white),
                        labelStyle: TextStyle(color: myFocusNode1.hasFocus ? Color(0xffe7f7f7) : Colors.white , fontSize: 15),
                        contentPadding: EdgeInsets.all(20),
                        filled: false,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xffFFFFFF), width: 2.0),
                        ),
                      ),
                      obscureText: true,
                      controller: _passwordController, //This connects to the animation as the controller
                      validator: (value) {
                        if (value == null) {
                          return 'Password is required.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                        width: 50.0,
                        height: 65.0,
                        child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          focusColor: Colors.white,
                          textColor: Colors.white,
                          splashColor: Colors.lightBlueAccent[500], // Creates a rippling effect when long pressing on the button
                          padding: const EdgeInsets.all(21),
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50)),
                          child: Text('Log In'),
                          onPressed: state is LoginLoading ? () { } : _onLoginButtonPressed,
                        )
                    ),
                  ],
                ),
              ),
            ),
          );
        },

      ),
    );
  }

  void _showError(String error) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(error),
      backgroundColor: Theme.of(context).errorColor,
    ));
  }
}
