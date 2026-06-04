import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vibe/config/routes/app_routes.dart';
import 'package:vibe/core/functions/date_of_now.dart';
import 'package:vibe/core/utility/constant.dart';
import 'package:vibe/core/widgets/svg_pictures.dart';
import 'package:vibe/core/resources/assets_manager.dart';
import 'package:vibe/core/resources/styles_manager.dart';
import 'package:vibe/core/utility/injector.dart';
import 'package:vibe/data/models/child_classes/post/post.dart';
import 'package:vibe/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:vibe/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:vibe/presentation/cubit/firestoreUserInfoCubit/users_info_cubit.dart';
import 'package:vibe/presentation/cubit/firestoreUserInfoCubit/users_info_reel_time/users_info_reel_time_bloc.dart';
import 'package:vibe/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:vibe/presentation/pages/activity/activity_for_mobile.dart';
import 'package:vibe/presentation/pages/messages/messages_page_for_mobile.dart';
import 'package:vibe/presentation/pages/messages/wait_call_page.dart';
import 'package:vibe/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:vibe/presentation/widgets/global/custom_widgets/custom_gallery_display.dart';

class CustomAppBar {
  static AppBar basicAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: false,
      iconTheme: IconThemeData(color: Theme.of(context).focusColor),
      title: const InstagramLogo(),
      actions: [
        _addList(context),
        _favoriteButton(context),
        _messengerButton(context),
        const SizedBox(width: 5),
      ],
    );
  }

  static Widget _messengerButton(BuildContext context) {
    return BlocBuilder<UsersInfoReelTimeBloc, UsersInfoReelTimeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsetsDirectional.only(end: 5.0),
          child: GestureDetector(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  IconsAssets.messengerIcon,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).focusColor, BlendMode.srcIn),
                  height: 22.5,
                ),
                if (state is MyPersonalInfoLoaded &&
                    state.myPersonalInfoInReelTime.numberOfNewMessages > 0)
                  _redPoint(),
              ],
            ),
            onTap: () {
              Go(context).push(
                  page: BlocProvider<UsersInfoCubit>(
                create: (context) => injector<UsersInfoCubit>(),
                child: const MessagesPageForMobile(),
              ));
            },
          ),
        );
      },
    );
  }

  static Positioned _redPoint() {
    return Positioned(
      right: 1.5,
      top: 15,
      child: Container(
        width: 10,
        height: 10,
        decoration:
            const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
      ),
    );
  }

  static Widget _favoriteButton(BuildContext context) {
    return BlocBuilder<UsersInfoReelTimeBloc, UsersInfoReelTimeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsetsDirectional.only(end: 13.0),
          child: GestureDetector(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  IconsAssets.favorite,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).focusColor, BlendMode.srcIn),
                  height: 30,
                ),
                if (state is MyPersonalInfoLoaded &&
                    state.myPersonalInfoInReelTime.numberOfNewNotifications > 0)
                  _redPoint(),
              ],
            ),
            onTap: () {
              Go(context).push(page: const ActivityPage(), withoutRoot: false);
            },
          ),
        );
      },
    );
  }

  static GestureDetector _addList(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCreatePostSheet(context),
      child: Padding(
        padding: const EdgeInsetsDirectional.only(end: 13.0),
        child: SvgPicture.asset(
          IconsAssets.add2Icon,
          colorFilter:
              ColorFilter.mode(Theme.of(context).focusColor, BlendMode.srcIn),
          height: 22.5,
        ),
      ),
    );
  }

  static void _showCreatePostSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Criar publicação',
                  style: getMediumStyle(
                      color: Theme.of(context).focusColor, fontSize: 16),
                ),
                const SizedBox(height: 20),
                _postOption(
                  context: context,
                  icon: Icons.text_fields_rounded,
                  label: 'Texto',
                  onTap: () {
                    Navigator.pop(context);
                    _openTextPost(context);
                  },
                ),
                const SizedBox(height: 12),
                _postOption(
                  context: context,
                  icon: Icons.photo_library_rounded,
                  label: 'Foto / Vídeo',
                  onTap: () {
                    Navigator.pop(context);
                    CustomImagePickerPlus.pickFromBoth(context);
                  },
                ),
                const SizedBox(height: 12),
                _postOption(
                  context: context,
                  icon: Icons.link_rounded,
                  label: 'Link',
                  onTap: () {
                    Navigator.pop(context);
                    _openLinkPost(context);
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _postOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Theme.of(context).focusColor),
            const SizedBox(width: 16),
            Text(
              label,
              style: getNormalStyle(
                  color: Theme.of(context).focusColor, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  static void _openTextPost(BuildContext context) {
    final TextEditingController textController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            bool isPosting = false;
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Nova publicação',
                      style: getMediumStyle(
                          color: Theme.of(ctx).focusColor, fontSize: 16)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: textController,
                    maxLines: 5,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'O que você está pensando?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: isPosting
                          ? null
                          : () async {
                              if (textController.text.trim().isEmpty) return;
                              setState(() => isPosting = true);
                              try {
                                final post = Post(
                                  caption: textController.text.trim(),
                                  datePublished: DateReformat.dateOfNow(),
                                  publisherId: myPersonalId,
                                  likes: [],
                                  comments: [],
                                  blurHash: '',
                                  imagesUrls: [],
                                  aspectRatio: 1.0,
                                  postUrl: '',
                                  isThatImage: true,
                                );
                                await PostCubit.get(context)
                                    .createPost(post, []);
                                if (ctx.mounted) Navigator.pop(ctx);
                              } catch (e) {
                                setState(() => isPosting = false);
                              }
                            },
                      child: isPosting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Text('Publicar',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15)),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static void _openLinkPost(BuildContext context) {
    final TextEditingController linkController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text('Compartilhar link',
                  style: getMediumStyle(
                      color: Theme.of(ctx).focusColor, fontSize: 16)),
              const SizedBox(height: 16),
              TextField(
                controller: linkController,
                autofocus: true,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  hintText: 'Cole o link aqui...',
                  prefixIcon: const Icon(Icons.link_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () async {
                    if (linkController.text.trim().isEmpty) return;
                    try {
                      final post = Post(
                        caption: linkController.text.trim(),
                        datePublished: DateReformat.dateOfNow(),
                        publisherId: myPersonalId,
                        likes: [],
                        comments: [],
                        blurHash: '',
                        imagesUrls: [],
                        aspectRatio: 1.0,
                        postUrl: '',
                        isThatImage: true,
                      );
                      await PostCubit.get(context)
                          .createPost(post, []);
                      if (ctx.mounted) Navigator.pop(ctx);
                    } catch (e) {
                      // erro silencioso por enquanto
                    }
                  },
                  child: const Text('Publicar',
                      style:
                          TextStyle(color: Colors.white, fontSize: 15)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  static AppBar chattingAppBar(
      List<UserPersonalInfo> usersInfo, BuildContext context) {
    int length = usersInfo.length;
    length = length >= 3 ? 3 : length;
    return AppBar(
      iconTheme: IconThemeData(color: Theme.of(context).focusColor),
      backgroundColor: Theme.of(context).primaryColor,
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            if (length > 1) ...[
              _imagesOfGroupUsers(usersInfo)
            ] else ...[
              CircleAvatarOfProfileImage(
                  userInfo: usersInfo[0],
                  bodyHeight: 340,
                  showColorfulCircle: false),
            ],
            const SizedBox(width: 15),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...List.generate(1, (index) {
                  return Text(
                    "${usersInfo[index].name}${length > 1 ? ", ..." : ""}",
                    style: TextStyle(
                        color: Theme.of(context).focusColor,
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
      actions: [
        GestureDetector(
          child: SvgPicture.asset(
            IconsAssets.phone,
            height: 27,
            colorFilter:
                ColorFilter.mode(Theme.of(context).focusColor, BlendMode.srcIn),
          ),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () async {
            UserPersonalInfo myPersonalInfo =
                UserInfoCubit.getMyPersonalInfo(context);
            amICalling = true;
            await Go(context).push(
                page: VideoCallPage(
                    usersInfo: usersInfo, myPersonalInfo: myPersonalInfo),
                withoutRoot: false,
                withoutPageTransition: true);
            amICalling = false;
          },
          child: SvgPicture.asset(
            IconsAssets.videoPoint,
            height: 25,
            colorFilter:
                ColorFilter.mode(Theme.of(context).focusColor, BlendMode.srcIn),
          ),
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  static Stack _imagesOfGroupUsers(List<UserPersonalInfo> userInfo) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 10,
          top: -6,
          child: CircleAvatarOfProfileImage(
            bodyHeight: 280,
            userInfo: userInfo[0],
            showColorfulCircle: false,
            disablePressed: false,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: CircleAvatarOfProfileImage(
            bodyHeight: 280,
            userInfo: userInfo[1],
            showColorfulCircle: false,
            disablePressed: false,
          ),
        ),
      ],
    );
  }

  static AppBar oneTitleAppBar(BuildContext context, String text,
      {bool logoOfInstagram = false}) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: false,
      iconTheme: IconThemeData(color: Theme.of(context).focusColor),
      title: logoOfInstagram
          ? const InstagramLogo()
          : Text(
              text,
              style: getMediumStyle(
                  color: Theme.of(context).focusColor, fontSize: 20),
            ),
    );
  }

  static AppBar menuOfUserAppBar(
      BuildContext context, String text, AsyncCallback bottomSheet) {
    return AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).focusColor),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(text,
            style: getMediumStyle(
                color: Theme.of(context).focusColor, fontSize: 20)),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              IconsAssets.menuHorizontalIcon,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).focusColor, BlendMode.srcIn),
              height: 22.5,
            ),
            onPressed: () => bottomSheet,
          ),
          const SizedBox(width: 5)
        ]);
  }
}
