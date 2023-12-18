# Books to read.

A simple flutter application which demonstrates how to manage a list of books to read.

## Demonstration of the app.

[![Demonstration](https://img.youtube.com/vi/qckA-pyA7OQ/0.jpg)](https://www.youtube.com/watch?v=qckA-pyA7OQ).

## Features:
- Search books by query.
- Display book title, author and cover image.
- Lazy load widgets in the list.
- Query only needed fields from the API.
- Tapping on books stores them as favorite in Firebase Firestore. Tapping again removes them from favorites.
- Logs HTTP communication to the console.


## TODO list:
- Implement pagination for search queries to avoid fetching all items.
- Debounce search queries to avoid spamming server on every keystroke.
- Add unit & widget tests.
- Add error handling with fancy UI to fail gracefully.
- Investigate if API exposes a query parameter to fetch books by their IDs, this would allow to avoid storing whole book object on Firestore, instead we could store only IDs of favorite books and fetch them from the API instead.

## How to run the project:
- Install fvm https://fvm.app/
- Execute `fvm dart run build_runner build --delete-conflicting-outputs`
- Execute `fvm dart run easy_localization:generate -f keys -o locale_keys.g.dart -S assets/translations`
- Execute `fvm flutter pub get & fvm flutter run` or if you're already on newest stable flutter version execute `flutter pub get & flutter run`.

# 1. Useful commands list

Generate code:
```
dart run build_runner build --delete-conflicting-outputs
```

Generate mappings for translations (easy_localization):
```
dart run easy_localization:generate -f keys -o locale_keys.g.dart -S assets/translations
```

# 2. Localization & strings
- [easy_localization](https://pub.dev/packages/easy_localization) is used to manage translations in the app. Translations are located under assets/translations/{locale}.json
- Hardcoded string literals for any kind of texts displayed to the user are not allowed.
- If the string you intend to add is a commonly used word, place it under "common" object in the json, otherwise create a new page object under "page" object and put it there.
- Place strings related to widgets under "widgets" object.
- Add new strings simultaneously to all of supported locales.

### Naming convention for pages:
```
page_{pageName}_{elementOnThePage?}_{propertyName}

// ex.1 page_dashboard_buyButton_hint
// ex.2 page_orders_title
```

### Naming convention for commons:
```
common_{propertyName}

// ex.1 common_save
// ex.2 common_cancel
// ex.3 common_status_ordered
```

### Naming convention for widgets:
```
widget_{widgetName}_{propertyName}

// ex.1 widget_infoButton_close
// ex.2 widget_spinner_label
```

In order to format enums or numbers with a given format create a formatter under /app/common/formatters:
```
// app/common/formatters/status_formatter.dart:

class StatusFormatter {
   static String format(MyStatus status) {
      switch (status) {
         case MyStatus.ordered:
            return LocaleKeys.common_status_ordered.tr();
         case MyStatus.shipped:
            return LocaleKeys.common_status_shipped.tr();
     }
  }
}

// default:
// do not use default branches because if you add a new case to the enum 
// then your IDE won't show any warning if you forgot to handle the new case.
```

# 3. Assets management
- All assets (fonts, translations, images, etc.) shall be placed under assets folder.
- AppAssets class will hold references to all paths for given assets.

### Example referencing an image asset:
```
return Image.asset(
   AppImages.icArrow24,
   width: 24,
   height: 24,
);
```

# 4. Dependency Injection
- [get_it](https://pub.dev/packages/get_it) is used to configure the dependency injection.
- If you need to access a certain object prefer to inject it through the constructor and save it as a final field in your class.
- blocs/cubits are also provided from the DI but access them always through `BlocProvider.of<MyBloc>(context);`
- Refer to app/di/modules for examples how to add a new dependency.

# 5. API
- APIs are created with the use of [retrofit](https://pub.dev/packages/retrofit) plugin that uses code generation to generate all required api helpers.

# 6. State management
- [flutter_bloc](https://pub.dev/packages/flutter_bloc) is used to manage state of the widgets.
- Prefer to use a Cubit instead of a Bloc.
- Actually prefer to use a BaseCubit in order to have a single class to which we add behavior shared by all cubits.
- As a state for the cubit use a class built with [freezed](https://pub.dev/packages/freezed) plugin. It generates automatically hashCode, equals and toString on which cubit relies heavily.
- Cubit shall be used to manage state of the pages, being a glue between a use case from which the cubit is fetching data and passing it as a state to the widget.
- For simple widgets that a single setState() would be sufficient just use setState() and avoid using the cubit.
- E.g. UI components such as buttons/labels/etc. must not use cubits, instead they shall offer callbacks to communicate with a parent widget (typically a page) and the page should call the cubit.

# 7. Analyzer
- Before submitting a new pull request run `flutter analyze` and make sure there are no linter issues in your code.

# 8. Code structure
- **app** *// things related to UI/presentation*
  - **common** *// commonly used things by the presentation module (theming, bloc, formatters)*
  - **di** *// dependency injection*
  - **pages** *// put your screens here*
  - **widgets** *// reusable widgets*
- **common** *// commonly used things in the whole project, do not relate directly either to presentation nor model*
- **model** *// business logic & repositories*
  - **{feature}/entity** *// model classes for a given feature*
  - **{feature}/repository** */ abstraction & implementation for the data source*
    - **api** *// retrofit or any other API*

# 9. General principles
- Follow the [clean architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- Follow the [SOLID principles](https://www.digitalocean.com/community/conceptual_articles/s-o-l-i-d-the-first-five-principles-of-object-oriented-design)
- Don't Repeat Yourself (DRY) - do not copy-paste code, instead be smart and think how to extract common logic
- Don't put business logic into widgets/apis/repositories. Best place for that is either a use case or a cubit.
- Repository pattern - [Microsoft docs](https://docs.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/infrastructure-persistence-layer-design#the-repository-pattern).
- Use cases/Repositories/Apis/Blocs must be clean of any UI logic - widgets and pages are meant for that.
- Try to fit in to the style of the rest of the code in the project.
