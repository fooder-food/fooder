import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification/bloc/review/review_repo.dart';
import 'package:flutter_notification/model/review_image_model.dart';
import 'package:flutter_notification/model/review_model.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepo _reviewRepo = ReviewRepo();
  ReviewBloc() : super(ReviewState()) {
    on<FetchReview>(_fetchReview);
    on<ChangeReviewType>(_changeReviewType);
    on<DelCommentImage>(_delCommentImage);
    on<UpdateReview>(_updateReview);
  }

  _fetchReview(
      FetchReview event,
      Emitter<ReviewState> emit
      ) async {
      emit(state.copyWith(status: ReviewStatus.onLoad));
    try {
      final review = await _reviewRepo.fetchReview(uniqueId: event.uniqueId);
      print(review);
      emit(state.copyWith(status: ReviewStatus.loadSuccess, review: review));
    } catch (e) {
      emit(state.copyWith(status: ReviewStatus.loadFailed));
    }
  }

  _changeReviewType(
    ChangeReviewType event,
    Emitter<ReviewState> emit
  ) {
    final review = state.review!;
    emit(state.copyWith(status: ReviewStatus.onEdit));
    print(event.type);
    String type = 'Good';
    if(event.type == 1) {
      type = 'Normal';
    } else if(event.type == 2) {
      type = 'Bad';
    }
    review.type =type;
    emit(state.copyWith(status: ReviewStatus.editSuccess, review: review));
  }

  _delCommentImage(
    DelCommentImage event,
    Emitter<ReviewState> emit
  ) {
    emit(state.copyWith(status: ReviewStatus.onEdit));
    final review = state.review!;
    final deleteImage = review.images.firstWhere((image) => image.id == event.id);
    final deleteImageList = [...state.deleteImage, deleteImage];
    review.images.removeWhere((image) => image.id == event.id);
    emit(state.copyWith(status: ReviewStatus.editSuccess, review: review, deleteImage: deleteImageList));
  }

  _updateReview(
   UpdateReview event,
   Emitter<ReviewState> emit
  ) async {
    final review = state.review!;
    emit(state.copyWith(status: ReviewStatus.onUpdate));
    try {
      await _reviewRepo.updateReview(
        content: review.content,
        type: review.type,
        commentUniqueId: review.uniqueId,
        delPhotos: state.deleteImage,
        photos: event.photos,
      );
      emit(state.copyWith(status: ReviewStatus.updateSucess, review: null, deleteImage: []));
    } catch (e) {
      emit(state.copyWith(status: ReviewStatus.updateFailed));
    }
  }
}
