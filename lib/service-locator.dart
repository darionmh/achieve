import 'package:get_it/get_it.dart';
import 'package:goald/services/auth_service.dart';
import 'package:goald/services/goal_service.dart';

GetIt locator = GetIt.instance;

setupServiceLocator() {
  locator.registerLazySingleton<AbstractGoalService>(() => GoalStore());
  locator.registerLazySingleton<AbstractAuthService>(() => AuthService());
}