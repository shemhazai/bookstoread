import 'package:books_to_read/app/pages/all_books/all_books_page.dart';
import 'package:books_to_read/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: TabBarView(
          children: [
            const AllBooksPage(),
            Container(
              color: Colors.blue,
            ),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(
              icon: const Icon(Icons.home),
              text: LocaleKeys.page_home_home.tr(),
            ),
            Tab(
              icon: const Icon(Icons.star),
              text: LocaleKeys.page_home_favorites.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
