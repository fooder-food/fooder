import 'package:flutter_notification/core/service/network/network_service.dart';
class CommentApiProvider {
  final NetworkService _networkService = NetworkService();

  Future<void> addReview({
    required String content,
    required int type,
    required String restaurantUniqueId,
  }) async {
    try {
      final data = {
        "content": content,
        "type": type,
        "restaurantUniqueId": restaurantUniqueId,
      };
      final response = await _networkService.post('restaurants/comments/create', data: data);
    } catch(e) {

    }
  }


}