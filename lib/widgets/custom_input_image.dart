import 'dart:typed_data';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/common/style.dart';

class CustomInputImage extends StatelessWidget {
  final String? url;
  final Uint8List? picked;
  final Function()? onTap;

  const CustomInputImage({
    this.url,
    this.picked,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: picked != null
          ? Image.memory(
              picked!,
              fit: BoxFit.fitWidth,
            )
          : url != null && url != ''
              ? Image.network(
                  url!,
                  fit: BoxFit.fitWidth,
                )
              : Image.asset(
                  kDefaultImageUrl,
                  fit: BoxFit.fitWidth,
                ),
    );
  }
}
