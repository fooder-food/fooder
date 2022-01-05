import 'dart:io';

import 'package:flutter_notification/bloc/comments/comments_api_provider.dart';

class CommentsRepo {
  factory CommentsRepo() {
    return _instance;
  }

  CommentsRepo._constructor();

  static final CommentsRepo _instance = CommentsRepo._constructor();
  final CommentApiProvider _commentApiProvider = CommentApiProvider();

  Future<void> addReview({
    required String content,
    required int type,
    required String restaurantUniqueId,
    List<File>? photos,
  }) async => _commentApiProvider.addReview(content: content, type: type, restaurantUniqueId: restaurantUniqueId, photos: photos);

}