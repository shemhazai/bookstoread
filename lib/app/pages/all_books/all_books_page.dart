import 'package:books_to_read/app/common/theming/dimens.dart';
import 'package:books_to_read/app/di/di.dart';
import 'package:books_to_read/app/pages/all_books/all_books_cubit.dart';
import 'package:books_to_read/app/pages/all_books/all_books_state.dart';
import 'package:books_to_read/app/widgets/book_widget.dart';
import 'package:books_to_read/generated/locale_keys.g.dart';
import 'package:books_to_read/model/books/books_repository.dart';
import 'package:books_to_read/model/books/entity/book.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// An initial page of the application, allows to search for books.
class AllBooksPage extends StatelessWidget {
  const AllBooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => inject<AllBooksCubit>(),
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
        const _SearchField(),
        BlocBuilder<AllBooksCubit, AllBooksState>(
          builder: (context, state) {
            return Expanded(
              child: state.when(
                empty: () => const _Empty(),
                loading: () => const _Loading(),
                noResults: () => const _NoResults(),
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
              LocaleKeys.page_allBooks_title.tr(),
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

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AllBooksCubit>();
    return Padding(
      padding: Insets.normal,
      child: TextField(
        onChanged: bloc.search,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          filled: true,
          hintText: LocaleKeys.page_allBooks_search.tr(),
          prefixIcon: Icon(
            Icons.search,
            size: 24,
            color: Theme.of(context).colorScheme.primary,
          ),
          contentPadding: Insets.smaller,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide.none,
          ),
        ),
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

class _NoResults extends StatelessWidget {
  const _NoResults();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        LocaleKeys.page_allBooks_noResults.tr(),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

class _Error extends StatelessWidget {
  final Object error;

  const _Error({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        LocaleKeys.page_allBooks_error.tr(args: [error.toString()]),
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
            LocaleKeys.page_allBooks_results.tr(),
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
                coverBuilder: repository.buildCoverUrl,
                onPressed: () {
                  FocusScope.of(context).unfocus();

                  // TODO: make favorite
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
