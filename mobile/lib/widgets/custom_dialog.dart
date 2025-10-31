import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class CustomDialog {
  final BuildContext context;

  CustomDialog(this.context);

  void show({
    DialogType dialogType = DialogType.info,
    AnimType animType = AnimType.bottomSlide,
    String? title,
    String? desc,
    Widget? body,
    bool showCloseIcon = true,
    bool dismissOnTouchOutside = true,
    bool dismissOnBackKeyPress = true,
    Duration? autoHide,
    VoidCallback? onOkPress,
    VoidCallback? onCancelPress,
    IconData? okIcon,
    Color? okColor,
    IconData? cancelIcon,
    Color? cancelColor,
    BorderRadius? buttonsBorderRadius,
    TextStyle? buttonsTextStyle,
    bool reverseBtnOrder = false,
    bool keyboardAware = false,
    double? width,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      animType: animType,
      title: title,
      desc: desc,
      body: body,
      showCloseIcon: showCloseIcon,
      dismissOnTouchOutside: dismissOnTouchOutside,
      dismissOnBackKeyPress: dismissOnBackKeyPress,
      autoHide: autoHide,
      btnOkOnPress: onOkPress,
      btnCancelOnPress: onCancelPress,
      btnOkIcon: okIcon,
      btnOkColor: okColor,
      btnCancelIcon: cancelIcon,
      btnCancelColor: cancelColor,
      buttonsBorderRadius: buttonsBorderRadius,
      buttonsTextStyle: buttonsTextStyle,
      reverseBtnOrder: reverseBtnOrder,
      keyboardAware: keyboardAware,
      width: width,
    ).show();
  }

  // Predefined dialogs for convenience
  static void infoDialog(BuildContext context, {String? title, String? desc}) {
    CustomDialog(context).show(
      dialogType: DialogType.info,
      title: title ?? "Info",
      desc: desc ?? "",
      animType: AnimType.bottomSlide,
      okIcon: Icons.info,
      okColor: Colors.blue,
      onOkPress: () {},
    );
  }

  static void successDialog(
    BuildContext context, {
    String? title,
    String? desc,
  }) {
    CustomDialog(context).show(
      dialogType: DialogType.success,
      title: title ?? "Success",
      desc: desc ?? "",
      animType: AnimType.leftSlide,
      okIcon: Icons.check_circle,
      okColor: Colors.green,
      onOkPress: () {},
    );
  }

  static void errorDialog(BuildContext context, {String? title, String? desc}) {
    CustomDialog(context).show(
      dialogType: DialogType.error,
      title: title ?? "Error",
      desc: desc ?? "",
      animType: AnimType.rightSlide,
      okIcon: Icons.cancel,
      okColor: Colors.red,
      onOkPress: () {},
    );
  }

  static void warningDialog(
    BuildContext context, {
    String? title,
    String? desc,
  }) {
    CustomDialog(context).show(
      dialogType: DialogType.warning,
      title: title ?? "Warning",
      desc: desc ?? "",
      animType: AnimType.topSlide,
      okIcon: Icons.warning,
      okColor: Colors.orange,
    );
  }
}
