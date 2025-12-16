import 'package:flutter/material.dart';
import 'package:myapp/models/account.dart';

class InputField extends StatelessWidget {
  final String label;
  final String hint;
  final bool isDropdown;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<dynamic>? items;
  final Function(String?)? onAccountSelected;
  final Function(String?)? onCategorySelected;
  final bool enabled;

  const InputField({
    super.key,
    this.label = '',
    required this.hint,
    this.isDropdown = false,
    this.leadingIcon,
    this.trailingIcon,
    this.controller,
    this.keyboardType,
    this.items,
    this.onAccountSelected,
    this.onCategorySelected,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
        ],
        if (isDropdown)
          if (items != null && items!.isNotEmpty && items!.first is Account)
            DropdownButtonFormField<String>(
              initialValue: (items as List<Account>).isNotEmpty
                  ? (items as List<Account>).first.id
                  : null,
              items: (items as List<Account>)
                  .map(
                    (account) => DropdownMenuItem(
                      value: account.id,
                      child: Text(account.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null && onAccountSelected != null) {
                  onAccountSelected!(value);
                }
              },
              decoration: InputDecoration(
                hintText: hint,
                prefixIcon: leadingIcon != null
                    ? Icon(leadingIcon, color: Colors.grey)
                    : null,
                enabled: enabled,
              ),
            )
          else if (items != null && items!.isNotEmpty && items!.first is String)
            DropdownButtonFormField<String>(
              initialValue: (items as List<String>).isNotEmpty
                  ? (items as List<String>).first
                  : null,
              items: (items as List<String>)
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ),
                  )
                  .toList(),
              onChanged: onCategorySelected,
              decoration: InputDecoration(
                hintText: hint,
                prefixIcon: leadingIcon != null
                    ? Icon(leadingIcon, color: Colors.grey)
                    : null,
                enabled: enabled,
              ),
            )
          else
            Container()
        else
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            enabled: enabled,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: leadingIcon != null
                  ? Icon(leadingIcon, color: Colors.grey)
                  : null,
              suffixIcon: trailingIcon != null
                  ? Icon(trailingIcon, color: Colors.grey)
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
      ],
    );
  }
}
