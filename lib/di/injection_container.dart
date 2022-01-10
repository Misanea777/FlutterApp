import 'package:get_it/get_it.dart';
import 'package:my_app/data/user_dao.dart';
import 'package:my_app/services/auth_service.dart';
import 'package:my_app/services/user_service.dart';

final sl = GetIt.I;

void init() {
  sl.registerLazySingleton<UserService>(() => UserService(dao: sl.get<UserDao>()));
  sl.registerLazySingleton<AuthService>(() => AuthService());
  sl.registerLazySingleton<UserDao>(() => UserDao(auth: sl.get<AuthService>(),));
}