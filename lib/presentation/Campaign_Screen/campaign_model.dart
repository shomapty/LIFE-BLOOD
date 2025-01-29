class CampaignModel {
  String imageUrl = 'https://firebasestorage.googleapis.com/v0/b/bari-bodol-47f1f.appspot.com/o/user_house_images%2F1710161784753_0.jpg?alt=media&token=19b33ce7-880d-4a46-bc9c-bd578da69c74';
  String place;
  String name;
  String startDate;
  String endDate;
  String startTime;
  String endTime;
  List<String> moreImagesUrl;
  String docId;

  CampaignModel({
    required this.imageUrl,
    required this.startTime,
    required this.endTime,
    required this.place,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.moreImagesUrl,
    required this.docId,
  });
}
