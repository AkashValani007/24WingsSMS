// ignore_for_file: constant_identifier_names, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constant/LocalColors.dart';

class CustomTextInput extends StatefulWidget {
  const CustomTextInput(
      {super.key,
        required this.title,
        required this.textEditController,
        required this.inputType,
        required this.textInputAction,
        required this.keyboardType,
        required this.maxLength,
        required this.hintText,
        required this.focusNode,
        required this.validator,
        //required this.scrollPadding,
      });

  final TextEditingController textEditController;
  final InputType inputType;
  final TextInputAction textInputAction;
  final int maxLength;
  final String title;
  final String hintText;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  //final  scrollPadding;

  @override
  _CustomTextInputState createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16.w, right: 16.w),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                      fontSize: 16.sp, color: grayTextColor),
                ),
                SizedBox(height: 6.h),
                Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: widget.textEditController,
                    textInputAction: widget.textInputAction,
                    maxLength: widget.maxLength,
                    focusNode: widget.focusNode,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      counterText: "",
                      hintText: widget.hintText,
                      hintStyle: TextStyle(color: hintColor),
                      isDense: true,
                    ),
                    textAlign: TextAlign.left,
                    keyboardType: widget.keyboardType,
                    validator: widget.validator,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
//input types
enum InputType { vUserName, vSocietyName ,vSocietyAddress ,vCityName, vStateName,vPincodeName,vMobileName}

// _setBorderStyle() {
//   switch (variant) {
//     case TextFormFieldVariant.None:
//       return InputBorder.none;
//     case TextFormFieldVariant.UnderlineGray90005:
//       return UnderlineInputBorder(
//         borderRadius: _setOutlineBorderRadius(),
//         borderSide: BorderSide.none,);
//     default:
//       return OutlineInputBorder(
//         borderRadius: _setOutlineBorderRadius(),
//         // borderSide: BorderSide.none,
//       );
//   }
// }


