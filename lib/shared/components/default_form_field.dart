import 'package:flutter/material.dart';

class DefaultFormField extends StatelessWidget {
  final String? Function(String?)? validate;
  final void Function(String?)? onSubmitted;
  final TextEditingController controller;
  final TextInputType type;
  final String label;
  final IconData prefix;
  final IconData? suffix;
  final void Function()? suffixTap;
  final bool? isObsecure;
  const DefaultFormField(
      {super.key,
      required this.validate,
      required this.controller,
      required this.type,
      required this.label,
      required this.prefix,
      this.suffix,
      this.suffixTap,
      this.isObsecure = false,
      this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        validator: validate,
        onFieldSubmitted: onSubmitted,
        controller: controller,
        obscureText: isObsecure!,
        keyboardType: type,
        decoration: InputDecoration(
            label: Text(label),
            border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
            prefixIcon: Icon(prefix),
            suffixIcon: (suffix == null)
                ? null
                : IconButton(onPressed: suffixTap, icon: Icon(suffix))));
  }
}
