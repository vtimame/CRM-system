import 'package:dio/dio.dart';
import 'package:oycrm/bloc/BoardScreen/OpenedCardScreen/AttachmentsBloc.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:oycrm/utils/http.dart';

class AttachmentRepository {
  Future findMany(List<dynamic> ids) async {
    try {
      Response attachments = await sl<Http>()
          .get('kanban/attachments', queryParameters: {"ids": ids});
      return attachments.data;
    } catch (e) {
      print(e);
    }
  }

  Future store(String cardId, Map<String, String> file) async {
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file['path'], filename: file['name'])
    });

    try {
      Response result = await sl<Http>().post(
        'kanban/cards/$cardId/attachments',
        data: formData,
        onSendProgress: (int sent, int total) {
          sl<AttachmentsBloc>().loadingSink.add(true);
          if (sent == total) {
            Future.delayed(const Duration(milliseconds: 250), () {
              sl<AttachmentsBloc>().loadingSink.add(false);
            });
          }
        },
      );
      return result.data;
    } catch (e) {
      print(e);
    }
  }
}
