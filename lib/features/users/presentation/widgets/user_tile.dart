import 'package:codebase_assignment/features/users/domain/entity/user.dart';
import 'package:codebase_assignment/features/users/presentation/screen/user_details.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserTile extends StatelessWidget {
  final User user;
  const UserTile({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetaileScreen(user: user),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(12.sp),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 173, 196, 224),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            SizedBox(
              height: 56.r,
              width: 56.r,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: user.avatar,
                  fit: BoxFit.cover,
                  errorWidget: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${user.firstName} ${user.lastName}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    )),
                Text(user.email,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
