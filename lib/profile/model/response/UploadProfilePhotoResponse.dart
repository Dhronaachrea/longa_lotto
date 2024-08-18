class UploadProfilePhotoResponse {
  int? errorCode;
  String? avatarPath;
  String? respMsg;

  UploadProfilePhotoResponse({this.errorCode, this.avatarPath, this.respMsg});

  UploadProfilePhotoResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    avatarPath = json['avatarPath'];
    respMsg = json['respMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['avatarPath'] = this.avatarPath;
    data['respMsg'] = this.respMsg;
    return data;
  }
}
