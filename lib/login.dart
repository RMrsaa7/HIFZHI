import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'beranda.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  bool _obscureText = true;
  bool _showPassword = false;

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
      _obscureText = !_showPassword;
    });
  }

  Widget buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 60,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.black87),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(Icons.person, color: Color(0xff38A6A5)),
                hintText: 'Username',
                hintStyle: TextStyle(color: Colors.black38, fontSize: 16)),
          ),
        )
      ],
    );
  }

//PASSWORD
  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 60,
          child: TextField(
            obscureText: _obscureText,
            style: TextStyle(color: Colors.black87),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(Icons.lock, color: Color(0xff38A6A5)),
                hintText: 'Password',
                hintStyle: TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }

  // SHOW PASSWORD CHECKBOX
  Widget buildShowPasswordCheckbox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: _showPassword,
              onChanged: (value) {
                _togglePasswordVisibility();
              },
              activeColor: Color(0xff38A6A5),
              checkColor: Colors.white,
              side: MaterialStateBorderSide.resolveWith(
                (Set<MaterialState> states) {
                  if (!states.contains(MaterialState.selected)) {
                    return BorderSide(color: Colors.white);
                  }
                  return BorderSide(color: Colors.white);
                },
              ),
            ),
            Text(
              'Tampilkan Password',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        buildForgotPassBtn(),
      ],
    );
  }

//FORGOT PASSWORD
  Widget buildForgotPassBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => print('Lupa password Pressed'),
        style: TextButton.styleFrom(
          padding: EdgeInsets.only(right: 0),
        ),
        child: Text(
          'Lupa Password?',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: Material(
        borderRadius: BorderRadius.circular(15),
        elevation: 5,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 53, 170, 168), Color.fromARGB(255, 24, 145, 145)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            onTap: (){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => BerandaScreen()),
                );
            },
            borderRadius: BorderRadius.circular(50),
            child: Container(
              height: 50,
              alignment: Alignment.center,
              padding: EdgeInsets.all(5),
              child: Text(
                'Masuk',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSignupBtn() {
    return GestureDetector(
      onTap: () => print('Daftar pressed'),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Belum punya akun? ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: 'Daftar',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFFFFFFFF),
                      Color(0xCC38A6A5),
                      Color(0xCC38A6A5),
                    ])),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 120),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/logo.png',
                        height: 90,
                      ),
                      SizedBox(height: 50),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: buildEmail(),
                      ),
                      SizedBox(height:10),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: buildPassword(),
                      ),
                      SizedBox(height: 15),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child:    buildShowPasswordCheckbox(),
                      ),
                      Container(
                        width:MediaQuery.of(context).size.width * 0.8,
                        child: buildLoginBtn()
                        ),
                      buildSignupBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
