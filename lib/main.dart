import 'package:flutter/material.dart';
import 'package:gpt_dall/home_page.dart';
import 'package:gpt_dall/provider/model_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ModelsProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kepton',
        theme: ThemeData.light(useMaterial3: true),
        home: const HomePage(),
      ),
    );
  }
}
