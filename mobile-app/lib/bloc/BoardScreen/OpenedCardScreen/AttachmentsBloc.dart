import 'package:oycrm/repositories/AttachmentRepository.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:rxdart/rxdart.dart';

class AttachmentsBloc {
  final _attachmentsList = BehaviorSubject<List>.seeded(null);
  final _loading = BehaviorSubject<bool>.seeded(false);

  Stream get listStream => _attachmentsList.stream;
  Sink get listSink => _attachmentsList.sink;

  Stream get loadingStream => _loading.stream;
  Sink get loadingSink => _loading.sink;

  Future loadAttachments(List<dynamic> ids) async {
    try {
      var attachments = await sl<AttachmentRepository>().findMany(ids);
      listSink.add(attachments);
    } catch (e) {
      print(e);
    }
  }

  Future uploadAttachments(String cardId, Map files) async {
    List list = _attachmentsList.value;
    files.forEach((name, path) {
      sl<AttachmentRepository>()
          .store(cardId, {"name": name, "path": path}).then((result) {
        list.add(result);
        listSink.add(list);
      });
    });
  }

  void dispose() {
    _attachmentsList.close();
    _loading.close();
  }
}
