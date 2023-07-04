import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/common/style.dart';

class CustomImageCell extends StatelessWidget {
  final String image;
  final Function()? onTap;

  const CustomImageCell({
    required this.image,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        alignment: Alignment.centerLeft,
        child: image != ''
            ? Image.network(
                image,
                fit: BoxFit.fitWidth,
                loadingBuilder: (context, child, loading) {
                  if (loading == null) return child;
                  return Image.asset(
                    kDefaultImageUrl,
                    fit: BoxFit.fitWidth,
                  );
                },
              )
            : Image.asset(
                kDefaultImageUrl,
                fit: BoxFit.fitWidth,
              ),
      ),
    );
  }
}
