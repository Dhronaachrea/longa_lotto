class UploadProfilePhotoRequest {
  String? playerId;
  String? playerToken;
  String? domainName;
  String? isDefaultAvatar;
  dynamic  file;

  UploadProfilePhotoRequest({
    this.playerId,
    this.playerToken,
    this.domainName,
    this.isDefaultAvatar,
    this.file});

  UploadProfilePhotoRequest.fromJson(Map<String, dynamic> json) {
    playerId = json['playerId'];
    playerToken = json['playerToken'];
    domainName = json['domainName'];
    isDefaultAvatar = json['isDefaultAvatar'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['playerId'] = this.playerId;
    data['playerToken'] = this.playerToken;
    data['domainName'] = this.domainName;
    data['isDefaultAvatar'] = this.isDefaultAvatar;
    data['file'] = this.file;
    return data;
  }
}
