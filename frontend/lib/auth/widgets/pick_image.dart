
import 'package:image_picker/image_picker.dart';

class PickImage {
  final ImagePicker picker = ImagePicker();

  Future<XFile?> pickImageFromSource(ImageSource source) async {
    // final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      // return File(image.path);
      return image;
    }
    return null;
  }
}
