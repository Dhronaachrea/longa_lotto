class EditProfileRequest {
  String? firstName;
  String? lastName;
  String? gender;
  String? dob;
  String? emailId;
  String? addressLine1;
  String? domainName;
  String? merchantPlayerId;

  EditProfileRequest(
      {this.firstName,
        this.lastName,
        this.gender,
        this.dob,
        this.emailId,
        this.addressLine1,
        this.domainName,
        this.merchantPlayerId});

  EditProfileRequest.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    gender = json['gender'];
    dob = json['dob'];
    emailId = json['emailId'];
    addressLine1 = json['addressLine1'];
    domainName = json['domainName'];
    merchantPlayerId = json['merchantPlayerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['emailId'] = this.emailId;
    data['addressLine1'] = this.addressLine1;
    data['domainName'] = this.domainName;
    data['merchantPlayerId'] = this.merchantPlayerId;
    return data;
  }
}
