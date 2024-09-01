import 'package:customer/themes/app_colors.dart';
import 'package:customer/utils/DarkThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TextFieldThem {
  const TextFieldThem({Key? key});

  static buildTextFiled(
    BuildContext context, {
    required String hintText,
    required TextEditingController controller,
    TextInputType keyBoardType = TextInputType.text,
    bool enable = true,
    int maxLine = 1,
        List<TextInputFormatter>? inputFormatters,
  }) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return TextFormField(
        controller: controller,
        textAlign: TextAlign.start,
        enabled: enable,
        keyboardType: keyBoardType,
        maxLines: maxLine,
        inputFormatters: inputFormatters,
        style: GoogleFonts.poppins(color: themeChange.getThem() ? Colors.white : Colors.black),
        decoration: InputDecoration(
            filled: true,
            fillColor: themeChange.getThem() ? AppColors.darkTextField : AppColors.textField,
            contentPadding: EdgeInsets.only(left: 10, right: 10, top: maxLine == 1 ? 0 : 10),
            disabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkModePrimary : AppColors.primary, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
            ),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
            ),
            hintText: hintText));
  }

  static buildTextFiledWithPrefixIcon(
    BuildContext context, {
    required String hintText,
    required TextEditingController controller,
    required Widget prefix,
    TextInputType keyBoardType = TextInputType.text,
    bool enable = true,
  }) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return TextFormField(
        controller: controller,
        textAlign: TextAlign.start,
        enabled: enable,
        keyboardType: keyBoardType,
        style: GoogleFonts.poppins(color: themeChange.getThem() ? Colors.white : Colors.black),
        decoration: InputDecoration(
            prefix: prefix,
            filled: true,
            fillColor: themeChange.getThem() ? AppColors.darkTextField : AppColors.textField,
            contentPadding: const EdgeInsets.only(left: 10, right: 10),
            disabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkModePrimary : AppColors.primary, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
            ),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
            ),
            hintText: hintText));
  }

  static buildTextFiledWithSuffixIcon(
    BuildContext context, {
    required String hintText,
    required TextEditingController controller,
    required Widget suffixIcon,
    TextInputType keyBoardType = TextInputType.text,
    bool enable = true,
  }) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return TextFormField(
        controller: controller,
        textAlign: TextAlign.start,
        enabled: enable,
        keyboardType: keyBoardType,
        style: GoogleFonts.poppins(color: themeChange.getThem() ? Colors.white : Colors.black),
        decoration: InputDecoration(
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: themeChange.getThem() ? AppColors.darkTextField : AppColors.textField,
            contentPadding: const EdgeInsets.only(left: 10, right: 10),
            disabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkModePrimary : AppColors.primary, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
            ),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
            ),
            hintText: hintText));
  }
}
