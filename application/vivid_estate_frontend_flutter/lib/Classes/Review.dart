class Review {
  // Data To Store For the Review
  final int reviewID;
  final String personName;
  final String personImage;
  final String reviewTime;
  final int reviewRating;
  final String reviewComment;

  // Constructor For Our Review Class
  Review(
      {required this.reviewID,
      required this.personName,
      required this.personImage,
      required this.reviewTime,
      required this.reviewRating,
      required this.reviewComment});
}
