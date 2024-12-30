import 'package:flutter/material.dart';
import 'package:ntuadventure/pages/calendar_page.dart';
import '../theme/app_decoration.dart';
import '../pages/home_page.dart';


class LoginPage extends StatefulWidget{

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey= GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final FocusNode _usernameFocusNode =FocusNode();

    @override
  void initState() {
    super.initState();
    // Enfocar automáticamente el campo de nombre al abrir la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _usernameFocusNode.requestFocus();
    });
  }


  @override
  void dispose(){
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){

    final ThemeData theme= Theme.of(context);

    return Scaffold(
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },

        child: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: AppDecoration.backgroundGradient,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 60.0,),
                CircleAvatar(
                    backgroundColor: theme.colorScheme.primary, 
                    radius: 70, // Tamaño del avatar
                    backgroundImage: AssetImage('assets/images/Group1.png'), // Ruta de la imagen
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 40,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.only(
                          left: 38,
                          top: 20,
                          right: 38
                        ),
                        decoration: AppDecoration.outlineBlueGray.copyWith(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Login',
                              style:theme.textTheme.displayMedium,
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                _textFieldName(_usernameController, _usernameFocusNode),
                                SizedBox(height: 10.0,),
                                _textFieldPassword(_passwordController),
                                SizedBox(height: 30,),
                                ElevatedButton(
                                  onPressed: (){
                                    if (_formKey.currentState!.validate()) {
                                      String username = _usernameController.text;
                                      String password = _passwordController.text;
                                      if ((username == "thanos" && password == "loveAthens")
                                        ||(username=="giorgio"&& password == "loveAthens")) {
                                        Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => CalendarPage()),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Invalid username or password")),
                                        );
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.primaryColor,
                                    padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 25.0)
                                  )
                                  , 
                                  child: Text(
                                    'Login', style: theme.textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              )
                            ),
                            
                            SizedBox(height: 20.0,)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}

Widget _textFieldName(TextEditingController myController, FocusNode myFocusNode) {
  return Container(
    padding: EdgeInsets.only(
      top:15.0),
    width: double.maxFinite,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12)
    ),
    child: TextFormField(
              focusNode: myFocusNode,
              autofocus: true,
              controller: myController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline),
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
              ),
    ),
  );
}

Widget _textFieldPassword(TextEditingController myController) {
  return Container(
    padding: EdgeInsets.only(
      top:15.0),
    width: double.maxFinite,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12)
    ),
    child: TextFormField(
              controller: myController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
              ),
    ),
  );
}

