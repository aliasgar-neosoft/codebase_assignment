import 'dart:async';
import 'package:codebase_assignment/core/widget/connectivity_banner/cubit/connectivity_cubit.dart';
import 'package:codebase_assignment/core/widget/connectivity_banner/cubit/connectivity_state.dart';
import 'package:codebase_assignment/features/users/presentation/cubit/user_cubit.dart';
import 'package:codebase_assignment/features/users/presentation/cubit/user_state.dart';
import 'package:codebase_assignment/features/users/presentation/widgets/user_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserListingScreen extends StatefulWidget {
  const UserListingScreen({super.key});

  @override
  State<UserListingScreen> createState() => _UserListingScreenState();
}

class _UserListingScreenState extends State<UserListingScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  final TextEditingController searchController = TextEditingController();
  Timer? debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(onScroll);
  }

  void onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      context.read<UserCubit>().loadmore();
    }
  }

  void onSearchChanged(String query) {
    debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<UserCubit>().search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityCubit, ConnectivityState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        final userCubit = context.read<UserCubit>();

        if (state is ConnectivityDisconnected) {
          userCubit.refresh();
        } else if (state is ConnectivityReconnected) {
          userCubit.loadmore();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 173, 196, 224),
          title: Text(
            "Users",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: searchController,
                onChanged: onSearchChanged,
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search user",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  filled: true,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      searchController.clear();
                      context.read<UserCubit>().search("");
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: RefreshIndicator(
            key: _refreshKey,
            onRefresh: () => context.read<UserCubit>().refresh(),
            child: BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                switch (state) {
                  case UserDataLoadingState():
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  case UserDataSearchSuccessState(results: final users):
                  case UserDataSuccessState(users: final users):
                  case UserDataLoadingMoreState(users: final users):
                    if (users.isEmpty && State is UserDataSearchSuccessState) {
                      return const Center(
                        child: Text("No users found for your search"),
                      );
                    } else if (users.isEmpty) {
                      return const Center(
                        child: Text("No users found"),
                      );
                    }
                    return ListView.separated(
                      controller: _scrollController,
                      itemCount: state is UserDataLoadingMoreState
                          ? users.length + 1
                          : users.length,
                      itemBuilder: (context, index) {
                        if (index == users.length) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 20),
                            child: Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          );
                        }
                        return UserTile(user: users[index]);
                      },
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    );

                  case UserDataFailureState(message: final message):
                    return Center(child: Text(message));

                  default:
                    return const SizedBox();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    debounce?.cancel();
    super.dispose();
  }
}
