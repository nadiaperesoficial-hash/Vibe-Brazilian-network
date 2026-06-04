import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/data/models/parent_classes/post/parent_post.dart';

class Story extends ParentPost {
  String storyUrl;
  String storyUid;
  DateTime? expiresAt;

  Story({
    required super.datePublished,
    required super.publisherId,
    super.publisherInfo,
    this.storyUid = "",
    this.storyUrl = "",
    this.expiresAt,
    super.caption,
    required super.comments,
    required super.likes,
    required super.blurHash,
    super.isThatImage = true,
  });

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  static Story fromSnap(
      {required DocumentSnapshot<Map<String, dynamic>> docSnap}) {
    DateTime? expiresAt;
    final expiresAtRaw = docSnap.data()?["expiresAt"];
    if (expiresAtRaw != null) {
      if (expiresAtRaw is Timestamp) {
        expiresAt = expiresAtRaw.toDate();
      }
    }
    return Story(
      caption: docSnap.data()?["caption"] ?? "",
      datePublished: docSnap.data()?["datePublished"] ?? "",
      publisherId: docSnap.data()?["publisherId"] ?? "",
      likes: docSnap.data()?["likes"] ?? [],
      comments: docSnap.data()?["comments"] ?? [],
      blurHash: docSnap.data()?["blurHash"] ?? "",
      storyUid: docSnap.data()?["storyUid"] ?? "",
      storyUrl: docSnap.data()?["storyUrl"] ?? "",
      isThatImage: docSnap.data()?["isThatImage"] ?? true,
      expiresAt: expiresAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'caption': caption,
        "datePublished": datePublished,
        "publisherId": publisherId,
        'comments': comments,
        'likes': likes,
        'storyUid': storyUid,
        "storyUrl": storyUrl,
        "isThatImage": isThatImage,
        "blurHash": blurHash,
        "expiresAt": Timestamp.fromDate(
          DateTime.now().add(const Duration(hours: 12)),
        ),
      };
}
