/// isSuccess : true
/// vMessage : "Thank you! Your inquiry is submitted, our sales excutive contact on your register mobile number."

class InquiryResponse {
  InquiryResponse({
      bool? isSuccess, 
      String? vMessage,}){
    _isSuccess = isSuccess;
    _vMessage = vMessage;
}

  InquiryResponse.fromJson(dynamic json) {
    _isSuccess = json['isSuccess'];
    _vMessage = json['vMessage'];
  }
  bool? _isSuccess;
  String? _vMessage;
InquiryResponse copyWith({  bool? isSuccess,
  String? vMessage,
}) => InquiryResponse(  isSuccess: isSuccess ?? _isSuccess,
  vMessage: vMessage ?? _vMessage,
);
  bool? get isSuccess => _isSuccess;
  String? get vMessage => _vMessage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isSuccess'] = _isSuccess;
    map['vMessage'] = _vMessage;
    return map;
  }

}