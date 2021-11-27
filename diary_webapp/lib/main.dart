import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_webapp/model/Diary.dart';
import 'package:diary_webapp/screens/get_started_page.dart';
import 'package:diary_webapp/screens/login_page.dart';
import 'package:diary_webapp/screens/main_page.dart';
import 'package:diary_webapp/screens/page_not_found.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  /**
   *  A new way to initialize firebase: https://stackoverflow.com/questions/69077745/how-to-migrate-flutter-project-to-firebase-version-9-modern-web-modular-style
   */
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final userDiaryDataStream =
      FirebaseFirestore.instance.collection('diaries').snapshots()
          // ignore: top_level_function_literal_block
          .map((diaries) {
    return diaries.docs.map((diary) {
      return Diary.fromDocument(diary);
    }).toList();
  });
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("Error");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MultiProvider(
              providers: [
                StreamProvider(
                    create: (context) => FirebaseAuth.instance.idTokenChanges(),
                    initialData: null),
                StreamProvider<List<Diary>>(
                    create: (context) => userDiaryDataStream, initialData: [])
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Diary Book',
                theme: ThemeData(
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  primarySwatch: Colors.green,
                ),
                initialRoute: '/',
                onGenerateRoute: (settings) {
                  return MaterialPageRoute(
                    builder: (context) {
                      return RouteController(settingsName: settings.name!);
                    },
                  );
                },
                onUnknownRoute: (settings) => MaterialPageRoute(
                  builder: (context) => PageNotFound(),
                ),
                //home: TesterApp(),
              ),
            );
          }
          return CircularProgressIndicator();
        });
  }
}

class TesterApp extends StatelessWidget {
  const TesterApp({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    CollectionReference booksCollection =
        FirebaseFirestore.instance.collection('diaries');
    return Scaffold(
        appBar: AppBar(
          title: Text('Main Page'),
        ),
        body: Center(
          child: StreamBuilder<QuerySnapshot>(
            stream: booksCollection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final bookListStream = snapshot.data!.docs.map((book) {
                return Diary.fromDocument(book);
              }).toList();
              for (var item in bookListStream) {
                print(item.entry!);
              }
              return ListView.builder(
                itemCount: bookListStream.length,
                itemBuilder: (context, index) {
                  return Text(bookListStream[index].entry!);
                },
              );
            },
          ),
        ));
  }
}

class RouteController extends StatelessWidget {
  final String settingsName;

  const RouteController({Key? key, required this.settingsName})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final userSignedIn = Provider.of<User?>(context) != null;
    print(settingsName);

    final signedInGotoMain = userSignedIn && settingsName == '/main';
    final notSignedInGotoMain = !userSignedIn && settingsName == '/main';

    if (settingsName == '/') {
      return GettingStartedPage();
    } else if (settingsName == '/main' || notSignedInGotoMain) {
      return LoginPage();
    } else if (settingsName == '/login' || notSignedInGotoMain) {
      return LoginPage();
    } else if (signedInGotoMain) {
      return MainPage();
    } else {
      return PageNotFound();
    }
  }
}
