import 'dart:typed_data';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/common/style.dart';

class CustomInputImage extends StatelessWidget {
  final Uint8List? pickedImage;
  final Function()? onTap;

  const CustomInputImage({
    this.pickedImage,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: pickedImage != null
          ? Image.memory(
              pickedImage!,
              fit: BoxFit.fitWidth,
            )
          : Image.asset(
              kDefaultImageUrl,
              fit: BoxFit.fitWidth,
            ),
    );
  }
}
