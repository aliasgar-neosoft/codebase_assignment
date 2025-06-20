import 'package:codebase_assignment/core/di.dart';
import 'package:codebase_assignment/core/services/db_service/db_service.dart';
import 'package:codebase_assignment/core/services/network_connectivity/network_connectitvity.dart';
import 'package:codebase_assignment/core/widget/connectivity_banner/connectivity_banner.dart';
import 'package:codebase_assignment/core/widget/connectivity_banner/cubit/connectivity_cubit.dart';
import 'package:codebase_assignment/db/db_schemas/user_schema.dart';
import 'package:codebase_assignment/features/users/presentation/cubit/user_cubit.dart';
import 'package:codebase_assignment/features/users/presentation/screen/user_listing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  DBService.instance.registerSchemas([
    UserTableSchema(),
  ]);
  diSetup();
  final networkConnectivityService = di.get<NetworkConnectivityService>();
  networkConnectivityService.initialize();
  runApp(
    BlocProvider(
      create: (BuildContext context) =>
          ConnectivityCubit(networkConnectivity: networkConnectivityService),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp(
            builder: (context, child) {
              return Stack(
                children: [
                  child ?? const SizedBox(),
                  const Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ConnectivityBanner(),
                  ),
                ],
              );
            },
            theme: ThemeData(
              useMaterial3: true,
            ),
            home: BlocProvider(
              create: (BuildContext context) => di.get<UserCubit>(),
              child: const UserListingScreen(),
            ),
          );
        });
  }
}
