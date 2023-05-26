import 'package:flutter/material.dart';
import 'package:maintaince/network/base_api_service.dart';
import '../model/inquiry_model.dart';

class InquiryViewModel extends BaseApiService {
  InquiryViewModel(BuildContext context) : super(context);


  Future<InquiryResponse?> inquiry(
      String vUserName, String vSocietyName, String vSocietyAddress, String vCity, String vState, String vPincode, String vMobile) async {
    return callApi(
      client.inquiry(
          vUserName: vUserName,
          vSocietyName: vSocietyName,
          vCity:vCity,
          vState:vState,
          vSocietyAddress: vSocietyAddress,
          vPincode: vPincode,
          vMobile: vMobile),
    );
  }
}





















// void inquiry(var vUserName, var vSocietyName, var vSocietyAddress, var vPincode, var vMobile , BuildContext context) async {
//       try {
//         Response response = await post(
//           Uri.parse('https://staging.24wings.com/v1/api/addInquiry.php'),
//           body: json.encode({
//             'vUserName': vUserName,
//             'vSocietyName': vSocietyName,
//             'vSocietyAddress': vMobile,
//             // 'vCity': vCity,
//             // 'vState': vState,
//             'vPincode': vPincode,
//             'vMobile': vMobile,
//           }),
//         );
//         print("=================================================================");
//         print("=================================================================");
//         if (response.statusCode == 200) {
//
//           var responseInquiry = InquiryResponse.fromJson(json.decode(response.body.toString()));
//
//           print("Response ${response.body}");
//
//           if (responseInquiry.isSuccess == true) {
//             Fluttertoast.showToast(
//               msg: responseInquiry.vMessage.toString(),
//               backgroundColor: Colors.black,
//               textColor: Colors.white,
//               fontSize: 16.0,
//               timeInSecForIosWeb: 3,
//             );
//
//             // ignore: use_build_context_synchronously
//           } else if (responseInquiry.isSuccess == false) {
//             Fluttertoast.showToast(
//               msg: responseInquiry.vMessage.toString(),
//               backgroundColor: Colors.red,
//               textColor: Colors.white,
//               fontSize: 16.0,
//               timeInSecForIosWeb: 3,
//             );
//           }
//         } else {
//           throw Exception('Failed to load data!');
//         }
//       } catch (e) {
//         print(e.toString());
//       }
//     }

