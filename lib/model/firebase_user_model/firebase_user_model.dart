class FirebaseUserDetailModel{
String name, email, pass, image, uid, joinDate;
List<String> blockedUID; // List of blocked user IDs
int onLineStatus; // Online status represented as an integer (0 or 1)

FirebaseUserDetailModel({
required this.uid,
required this.image,
required this.name,
required this.email,
required this.pass,
required this.joinDate,
List<String>? blockedUID, // Optional parameter for initializing blockedUID
int? onLineStatus, // Optional parameter for initializing onLineStatus
})   : blockedUID = blockedUID ?? [], // Initialize blockedUID with an empty list if not provided
onLineStatus = onLineStatus ?? 0; // Initialize onLineStatus with 0 if not provided

Map<String, dynamic> toMap() {
return <String, dynamic>{
"id": uid,
"name": name,
"pass": pass,
"image": image,
"joinDate": joinDate,
"email": email,
"blockedUID": blockedUID, // Include the blocked user IDs in the map
"onLineStatus": onLineStatus, // Include the online status in the map as an integer
};
}

factory FirebaseUserDetailModel.fromJson(Map<String, dynamic> json) {
FirebaseUserDetailModel userModel = FirebaseUserDetailModel(
uid: json['id'],
name: json['name'],
pass: json['pass'],
image: json['image'],
joinDate: json['joinDate'],
email: json['email'],
blockedUID: json['blockedUID'] != null
? List<String>.from(json['blockedUID']) // Convert JSON array to a List<String>
    : [], // Initialize with an empty list if not present
onLineStatus: json['onLineStatus'] == "true" ?1:0, // Initialize with 0 if not present
);
// debugPrint(userModel.toString());
return userModel;
}
}