import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'configurations/blocs/blocs.dart';
import 'configurations/services/services.dart';
import 'main_screens/pages.dart';

void main() => runApp(
  // Injects the Authenticaton service
    RepositoryProvider<AuthenticationService>(
      create: (context) {
        return FakeAuthenticationService();
      },
      // Injects the Authentication BLoC
      child: BlocProvider<AuthenticationBloc>(
        create: (context) {
          final authService = RepositoryProvider.of<AuthenticationService>(context);
          return AuthenticationBloc(authService)..add(AppLoaded());
        },
        child: MyApp(),
      ),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            // show home page if exact credentials are entered.
            return HomePage(
              user: state.user,
            );
          }
          // otherwise show login page
          return LoginPage();
        },
      ),
    );
  }
}
