import 'package:diary_webapp/screens/login_page.dart';
import 'package:flutter/material.dart';

class GettingStartedPage extends StatelessWidget {
  const GettingStartedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CircleAvatar(
        backgroundColor: Color(0XFFF5F6F8),
        child: Column(
          children: [
            Spacer(),
            Text('DiaryBook.', style: Theme.of(context).textTheme.headline3),
            SizedBox(
              height: 40,
            ),
            Text(
              '"Document your life"',
              style: TextStyle(
                  fontSize: 29,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.black26),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              width: 220,
              height: 40,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                    textStyle:
                        TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                icon: Icon(Icons.login_rounded),
                label: Text('Sign in to Get Started'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ));
                },
              ),
            ),
            Spacer()
          ],
        ),
      ),
    );
  }
}
