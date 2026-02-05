import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../home/model/post_model.dart';

class ShareController extends GetxController {
  final String appShareLink = 'https://spectrasynq.afriaaz';

  // Share link directly using native share sheet
  void shareAppLink() {
    SharePlus.instance.share(
      ShareParams(text: appShareLink, subject: 'Check out SpectraSynq!'),
    );
  }

  // Share post content with link
  void sharePost(Post post) {
    final content =
        '''
Check out this post on SpectraSynq:

${post.content ?? ''}

$appShareLink
    '''
            .trim();

    SharePlus.instance.share(
      ShareParams(text: content, subject: 'Check out this post on SpectraSynq'),
    );
  }

  // Copy link to clipboard (fallback option)
  void copyLink() {
    Clipboard.setData(ClipboardData(text: appShareLink));
    EasyLoading.showSuccess('Link has been copied to clipboard');
  }

  // Share via WhatsApp (uses native sharing)
  void shareViaWhatsApp() {
    SharePlus.instance.share(
      ShareParams(text: appShareLink, subject: 'Check out SpectraSynq!'),
    );
  }

  // Share via Facebook (uses native sharing)
  void shareViaFacebook() {
    SharePlus.instance.share(
      ShareParams(text: appShareLink, subject: 'Check out SpectraSynq!'),
    );
  }

  // Share via Twitter (uses native sharing)
  void shareViaTwitter() {
    final twitterContent = 'Check out SpectraSynq: $appShareLink';
    SharePlus.instance.share(
      ShareParams(text: twitterContent, subject: 'Check out SpectraSynq'),
    );
  }

  // Share via Email (uses native sharing)
  void shareViaEmail() {
    SharePlus.instance.share(
      ShareParams(
        text: appShareLink,
        subject: 'Check out SpectraSynq - Amazing Social App!',
      ),
    );
  }

  // Embed functionality (copy embed code)
  void copyEmbedCode() {
    const embedCode = '''
<iframe src="https://spectrasynq.afriaaz" width="100%" height="400" frameborder="0"></iframe>
    ''';

    Clipboard.setData(const ClipboardData(text: embedCode));
    EasyLoading.showSuccess('Embed code has been copied to clipboard');
  }
}
