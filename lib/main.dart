import 'package:codemagic_task/business_logic/app_state.dart';
import 'package:codemagic_task/data/author_service.dart';
import 'package:codemagic_task/presentation/author_detail_screen.dart';
import 'package:codemagic_task/presentation/author_list_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeDataMap = _themeData(context);
    final AuthorService service = AuthorServiceHttp(
      dioInstance: Dio(),
      authorUrl: "https://quotable.io/authors",
    );

    return AppRootWidget(
      service: service,
      child: MaterialApp(
        title: 'Author App',
        themeMode: ThemeMode.dark,
        darkTheme: themeDataMap['dark'],
        theme: themeDataMap['light'],
        home: const AuthorsListScreen(),
        routes: {
          AuthorDetailScreen.screenName: (context) => const AuthorDetailScreen()
        },
      ),
    );
  }

  Map<String, ThemeData> _themeData(BuildContext context) {
    final themeData = Theme.of(context);

    const titleTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );

    final bottomSheetTheme = BottomSheetThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.grey[100],
    );

    final darkTheme = ThemeData(
      cardColor: const Color(0xff323232),
      backgroundColor: const Color(0xff191919),
      scaffoldBackgroundColor: const Color(0xff191919),
      colorScheme: const ColorScheme.dark(),
      bottomSheetTheme: bottomSheetTheme.copyWith(
        backgroundColor: const Color(0xff101010),
      ),
      appBarTheme: themeData.appBarTheme.copyWith(
        backgroundColor: const Color(0xff323232),
        titleTextStyle: titleTextStyle,
      ),
      iconTheme: IconThemeData(
        color: titleTextStyle.color,
      ),
    );

    final lightTheme = ThemeData(
      cardColor: Colors.grey[300],
      backgroundColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      bottomSheetTheme: bottomSheetTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        titleTextStyle: titleTextStyle.copyWith(
          color: const Color(0xff232323),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xff232323),
        ),
      ),
      colorScheme: const ColorScheme.light(),
    );
    return {
      'light': lightTheme,
      'dark': darkTheme,
    };
  }
}
