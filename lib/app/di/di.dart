import 'package:books_to_read/app/di/modules/blocs_module.dart';
import 'package:books_to_read/app/di/modules/repositories_module.dart';
import 'package:books_to_read/common/data/app_environment.dart';
import 'package:get_it/get_it.dart';

final GetIt _getIt = GetIt.instance;

/// Configures the dependency injection.
void configureDependencies(AppEnvironment environment) {
  _getIt.registerSingleton(environment);
  RepositoriesModule.register(_getIt);
  BlocsModule.register(_getIt);
}

/// Inject the dependency from get_it.
T inject<T extends Object>({String? instanceName, dynamic param1, dynamic param2}) =>
    _getIt.get<T>(instanceName: instanceName, param1: param1, param2: param2);
