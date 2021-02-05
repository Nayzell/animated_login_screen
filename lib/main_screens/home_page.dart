import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_authentication/configurations/blocs/authentication/authentication.dart';
import '../configurations/models/models.dart';

class HomePage extends StatelessWidget {
  final User user;

  const HomePage({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello and Thank You!'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: <Widget>[
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: Text('Logout'),
                onPressed: (){
                  authBloc.add(UserLoggedOut());
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
