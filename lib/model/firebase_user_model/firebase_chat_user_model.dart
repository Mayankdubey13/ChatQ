class FirebaseChatUserModel {
  String message;
  String? img;
  String senderUID;
  String time;
  String receiverUID;

  /// [isForwarded] == 1 ? It marked as forwarded
  /// [isForwarded] == 0 ? It marked as a normal message
  int isForwarded;

  /// if [visibleNo] == 0? message won't be visible to anyone,
  /// if [visibleNo] == 1? message will only be visible to the receiver
  /// if [visibleNo] == 2? message will only be visible to the sender
  /// if [visibleNo] == 3? message will be visible to everyone
  int visibleNo;

  String chatID;

  /// Message status:
  /// 0 - Sent
  /// 1 - Delivered
  /// 2 - Read
  int status;

  /// Timestamps:
  /// When the message was sent.
  String sentTime;

  /// When the message was delivered.
  String? deliveredTime;

  /// When the message was read.
  String? readTime;
  /// by default it will be 0
  /// If star = 1 means star message
  int star;

  /// This is the model of every message
  FirebaseChatUserModel({
    required this.message,
    this.img,
    required this.senderUID,
    required this.time,
    required this.receiverUID,
    this.isForwarded = 0,
    this.visibleNo = 3,
    this.star = 0,
    required this.chatID,
    required this.status,
    required this.sentTime,
    this.deliveredTime,
    this.readTime,
  });

  factory FirebaseChatUserModel.fromJson(Map<String, dynamic> json) {
    return FirebaseChatUserModel(
      message: json['message'],
      img: json['img'],
      senderUID: json['senderUID'],
      time: json['time'],
      receiverUID: json['receiverUID'],
      isForwarded: json['isForwarded'] ?? 0,
      visibleNo: json['visibleNo'] ?? 3,
      chatID: json['chatID'],
      status: json['status'] ?? 0, // Default to Sent
      sentTime: json['sentTime'],
      deliveredTime: json['deliveredTime'],
      readTime: json['readTime'],
      star: json['star'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'img': img,
      'senderUID': senderUID,
      'time': time,
      'receiverUID': receiverUID,
      'isForwarded': isForwarded,
      'visibleNo': visibleNo,
      'chatID': chatID,
      'status': status,
      'star': star,
      'sentTime': sentTime,
      'deliveredTime': deliveredTime,
      'readTime': readTime,
    };
  }
}