import 'package:books_to_read/app/common/theming/dimens.dart';
import 'package:books_to_read/model/books/entity/book.dart';
import 'package:flutter/material.dart';

/// A callback that should return a valid url pointing
/// to a network image to fetch a cover with [coverId].
typedef BookCoverBuilder = String Function(int coverId);

/// A widget that renders a card for a book.
class BookWidget extends StatelessWidget {
  final Book book;
  final BookCoverBuilder coverBuilder;
  final VoidCallback? onPressed;

  const BookWidget({
    super.key,
    required this.book,
    required this.coverBuilder,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final int? coverId = book.coverId;

    return GestureDetector(
      onTap: onPressed,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: SizedBox(
          height: 120,
          child: Row(
            children: [
              Container(
                width: 60,
                margin: Insets.smaller,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[500]!),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: coverId != null
                    ? _Cover(
                        url: coverBuilder(coverId),
                      )
                    : const _CoverPlaceholder(),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Spacing.small,
                    Text(
                      book.title,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      book.authorNames?.join(', ') ?? '---',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  final String url;

  const _Cover({required this.url});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.fill,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (frame != null) {
          return child;
        } else {
          return const _CoverPlaceholder();
        }
      },
    );
  }
}

class _CoverPlaceholder extends StatelessWidget {
  const _CoverPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[300],
      alignment: Alignment.center,
      child: const Icon(
        Icons.image,
        size: 32,
      ),
    );
  }
}
