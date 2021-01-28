import 'package:digital_element/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) {
      runApp(new App());
  });

}

class App extends StatelessWidget {
  
  @override
  build(context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Цифровой элемент",
    home: HomePage(),
  );

}
