part of 'review_bloc.dart';

class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchReview extends ReviewEvent {
  const FetchReview(this.uniqueId);
  final String uniqueId;
}


class ChangeReviewType extends ReviewEvent {
  const ChangeReviewType(this.type);
  final int type;
}

class DelCommentImage extends ReviewEvent {
  const DelCommentImage(this.id);
  final int id;
}

class UpdateReview extends ReviewEvent {
 UpdateReview({
  this.photos,
  });
List<File>? photos;
}
