import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class CustomDateTimeField extends StatelessWidget {
  static final DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  final TextEditingController? controller;
  final DateTime? initialValue;
  final Function(DateTime?)? onChanged;
  DateFormat? format;
  final FocusNode? focusNode;
  final String? Function(DateTime?)? customValidator;
  final String? hintText;
//DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  CustomDateTimeField(
      {super.key,
      this.onChanged,
      this.controller,
      this.initialValue,
      this.focusNode,
      this.customValidator,
      this.hintText,
      this.format});

  @override
  Widget build(BuildContext context) {
    return DateTimeField(
      focusNode: focusNode,
      controller: controller,
      initialValue: initialValue,
      validator: customValidator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      format: format ?? dateFormat,
      onChanged: onChanged,
      onShowPicker: (context, currentValue) {
        return showDatePicker(
          context: context,
          firstDate: DateTime(2024,9,25),
          initialDate: currentValue ?? DateTime.now(),
          lastDate: DateTime.now(),
        );
      },
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).shadowColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).shadowColor),
        ),
        hintStyle: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(color: Theme.of(context).hintColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 15),
        hintText: hintText,
      ),
    );
  }
}
