import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/core/resources/assets_manager.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/utility/injector.dart';
import 'package:instagram/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/users_info_cubit.dart';
import 'package:instagram/presentation/pages/messages/messages_page_for_mobile.dart';
import 'package:instagram/presentation/pages/profile/personal_profile_page.dart';
import 'package:instagram/presentation/pages/time_line/all_user_time_line/all_users_time_line.dart';
import 'package:instagram/presentation/pages/time_line/my_own_time_line/home_page.dart';
import 'package:instagram/presentation/widgets/global/custom_widgets/custom_app_bar.dart';
import 'package:instagram/presentation/widgets/global/screens_w.dart';

class MobileScreenLayout extends StatefulWidget {
  final String userId;
  const MobileScreenLayout(this.userId, {super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  ValueNotifier<bool> playHomeVideo = ValueNotifier(false);
  CupertinoTabController controller = CupertinoTabController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.index == 2) {
        controller.index = 0;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) CustomAppBar.showCreatePost(context);
        });
      }
      playHomeVideo.value = controller.index == 0;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    playHomeVideo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: Theme.of(context).primaryColor,
        height: 45,
        border: Border.all(color: ColorManager.transparent),
        items: [
          navigationBarItem(IconsAssets.home),
          navigationBarItem(IconsAssets.search),
          addPostItem(),
          navigationBarItem(IconsAssets.messengerIcon),
          personalImageItem(),
        ],
      ),
      controller: controller,
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return homePage();
          case 1:
            return allUsersTimLinePage();
          case 2:
            return homePage();
          case 3:
            return messagesPage();
          default:
            return personalProfilePage();
        }
      },
    );
  }

  CupertinoTabView allUsersTimLinePage() => CupertinoTabView(
        builder: (context) =>
            CupertinoPageScaffold(child: AllUsersTimeLinePage()),
      );

  CupertinoTabView messagesPage() => CupertinoTabView(
        builder: (context) => CupertinoPageScaffold(
          child: BlocProvider<UsersInfoCubit>(
            create: (context) => injector<UsersInfoCubit>(),
            child: const MessagesPageForMobile(),
          ),
        ),
      );

  CupertinoTabView personalProfilePage() => CupertinoTabView(
        builder: (context) => CupertinoPageScaffold(
          child: BlocProvider<PostCubit>(
            create: (context) => injector<PostCubit>(),
            child: PersonalProfilePage(personalId: widget.userId),
          ),
        ),
      );

  Widget homePage() => CupertinoTabView(
        builder: (context) => CupertinoPageScaffold(
            child: BlocProvider<PostCubit>(
          create: (context) => injector<PostCubit>(),
          child: ValueListenableBuilder(
            valueListenable: playHomeVideo,
            builder: (context, bool playVideoValue, child) => HomePage(
              userId: widget.userId,
              playVideo: playVideoValue,
            ),
          ),
        )),
      );

  BottomNavigationBarItem personalImageItem() =>
      const BottomNavigationBarItem(icon: PersonalImageIcon());

  BottomNavigationBarItem addPostItem() {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        IconsAssets.add2Icon,
        height: 25,
        colorFilter: ColorFilter.mode(
            Theme.of(context).focusColor, BlendMode.srcIn),
      ),
    );
  }

  BottomNavigationBarItem navigationBarItem(String icon) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        icon,
        height: 25,
        colorFilter: ColorFilter.mode(
            Theme.of(context).focusColor, BlendMode.srcIn),
      ),
    );
  }
}
