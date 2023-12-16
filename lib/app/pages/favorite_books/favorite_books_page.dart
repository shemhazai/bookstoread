import 'package:books_to_read/app/common/theming/dimens.dart';
import 'package:books_to_read/app/di/di.dart';
import 'package:books_to_read/app/pages/favorite_books/favorite_books_cubit.dart';
import 'package:books_to_read/app/pages/favorite_books/favorite_books_state.dart';
import 'package:books_to_read/app/widgets/book_widget.dart';
import 'package:books_to_read/generated/locale_keys.g.dart';
import 'package:books_to_read/model/books/books_repository.dart';
import 'package:books_to_read/model/books/entity/book.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Displays books favorited by a user.
class FavoriteBooksPage extends StatelessWidget {
  const FavoriteBooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => inject<FavoriteBooksCubit>()..loadData(),
      child: const Scaffold(
        body: SafeArea(
          child: _Body(),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacing.big,
        const _Header(),
        BlocBuilder<FavoriteBooksCubit, FavoriteBooksState>(
          builder: (context, state) {
            return Expanded(
              child: state.when(
                empty: () => const _Empty(),
                loading: () => const _Loading(),
                error: (error) => _Error(error: error),
                content: (books) => _Content(books: books),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Insets.normal.copyWith(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              LocaleKeys.page_favoriteBooks_title.tr(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Icon(
            Icons.verified_user,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _Error extends StatelessWidget {
  final Object error;

  const _Error({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        LocaleKeys.page_favoriteBooks_error.tr(args: [error.toString()]),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final List<Book> books;

  const _Content({required this.books});

  @override
  Widget build(BuildContext context) {
    final BooksRepository repository = inject();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: Insets.normal.copyWith(bottom: 0),
          child: Text(
            LocaleKeys.page_favoriteBooks_results.tr(),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        Spacing.tiny,
        Expanded(
          child: ListView.separated(
            padding: Insets.small,
            itemCount: books.length,
            itemBuilder: (BuildContext context, int index) {
              final Book book = books[index];
              return BookWidget(
                book: book,
                isFavorite: true,
                coverBuilder: repository.buildCoverUrl,
                onPressed: () {
                  FocusScope.of(context).unfocus();

                  final cubit = context.read<FavoriteBooksCubit>();
                  cubit.removeFavoriteBook(book);
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Spacing.smaller;
            },
          ),
        ),
      ],
    );
  }
}
