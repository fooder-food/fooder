part of 'review_bloc.dart';

enum ReviewStatus {
  initial,
  onEdit,
  editSuccess,
  editFailed,
  onLoad,
  loadSuccess,
  loadFailed,
  onEditType,
  editTypeSuccess,
  onUpdate,
  updateSucess,
  updateFailed,
}

class ReviewState extends Equatable {
  ReviewState({
    this.status = ReviewStatus.initial,
    this.review,
    this.deleteImage = const[],
  });
  final ReviewStatus status;
  final Review? review;
  List<ReviewImage> deleteImage;

  ReviewState copyWith({
    ReviewStatus? status,
    Review? review,
    List<ReviewImage>? deleteImage,
  }) => ReviewState(
    status: status ?? this.status,
    review: review ?? this.review,
    deleteImage: deleteImage ?? this.deleteImage,
  );  

  @override
  // TODO: implement props
  List<Object?> get props => [status, review, deleteImage];
}

