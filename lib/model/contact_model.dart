class ContactModel {
  String? fullName;
  String? contactNumber;

  ContactModel({this.fullName, this.contactNumber});

  ContactModel.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    contactNumber = json['contact_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['full_name'] = fullName;
    data['contact_number'] = contactNumber;
    return data;
  }
}
