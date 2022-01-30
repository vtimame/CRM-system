import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:oycrm/bloc/BoardScreen/OpenedCardBloc.dart';
import 'package:oycrm/bloc/BoardScreen/OpenedCardScreen/AttachmentsBloc.dart';
import 'package:oycrm/config.dart';
import 'package:oycrm/utils/AppRouter.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:oycrm/utils/Utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:url_launcher/url_launcher.dart';

class Attachments extends StatefulWidget {
  @override
  _AttachmentsState createState() => _AttachmentsState();
}

class _AttachmentsState extends State<Attachments> {
  bool showAllAttachments = false;

  @override
  Widget build(BuildContext context) {
    final attachmentsBloc = sl<AttachmentsBloc>();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.blueGrey[50],
          borderRadius: BorderRadius.all(Radius.circular(3.0))),
      child: StreamBuilder(
        stream: attachmentsBloc.listStream,
        builder: (context, list) {
          if (list.connectionState == ConnectionState.waiting ||
              list.data == null) {
            return CircularProgressIndicator();
          } else if (list.data.length == 0) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text('Здесь пока нет ни одного вложения'),
              ),
            );
          } else {
            List<Widget> attachmentsViews = [];

            List<dynamic> allAttachments = list.data.toList();

            (showAllAttachments ? allAttachments : allAttachments.take(3))
                .forEach((el) =>
                    attachmentsViews.add(renderAttachment(el, allAttachments)));

            attachmentsViews.add(SizedBox(
              width: double.infinity,
              child: Material(
                child: new InkWell(
                  onTap: () =>
                      setState(() => showAllAttachments = !showAllAttachments),
                  child: new Container(
                    height: 32.0,
                    child: Center(
                      child: Text(
                        '${showAllAttachments ? 'Скрыть' : 'Показать все'} вложения',
                      ),
                    ),
                  ),
                ),
                color: Colors.transparent,
              ),
            ));

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: attachmentsViews,
            );
          }
        },
      ),
    );
  }

  renderAttachment(Map attachment, List<dynamic> attachments) {
    final OpenedCardBloc openedCardBloc = sl<OpenedCardBloc>();
    String cardId = openedCardBloc.openedCard.value['_id'];

    String fileUrl =
        '${Config.baseUrl}attachments/$cardId/${attachment['name']}';
    String thumbnailUrl =
        '${Config.baseUrl}attachments/$cardId/thumbnails/w_300_${attachment['name']}';

    bool isImage = Utils.isImage(attachment['name']);

    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[300]))),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: isImage
                ? renderImageThumbnail(
                    thumbnailUrl, fileUrl, attachments, cardId)
                : renderFileThumbnail(fileUrl, attachment['name']),
          ),
          SizedBox(
            width: 8.0,
          ),
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  attachment['name'],
                  style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600),
                ),
                Text(
                  '${attachment['user']['surname']} ${attachment['user']['name']} ${attachment['created_at']}',
                  style: TextStyle(fontSize: 13.0),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget renderImageThumbnail(String thumbnailUrl, String imageUrl,
      List<dynamic> attachments, String cardId) {
    var images = [];
    attachments.forEach((element) {
      if (Utils.isImage(element["name"])) {
        images.add(element);
      }
    });

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Container(
                      child: Scaffold(
                        backgroundColor: Colors.black,
                        body: SafeArea(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Feather.arrow_left,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        "Вернуться назад",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: PhotoViewGallery.builder(
                                    itemCount: images.length,
                                    builder: (BuildContext context, int index) {
                                      return PhotoViewGalleryPageOptions(
                                          imageProvider: NetworkImage(
                                              '${Config.baseUrl}attachments/$cardId/${images[index]["name"]}'),
                                          initialScale:
                                              PhotoViewComputedScale.contained);
                                    }),
                              )
                            ],
                          ),
                        ),
                      ),
                    )));
      },
      child: CachedNetworkImage(
        imageUrl: thumbnailUrl,
        imageBuilder: (context, imageProvider) => Container(
          width: 80.0,
          height: 80.0,
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => Container(
          width: 80.0,
          height: 80.0,
          decoration: BoxDecoration(color: Colors.blueGrey[200]),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: 80.0,
          height: 80.0,
          decoration: BoxDecoration(color: Colors.blueGrey[200]),
          child: Center(
            child: Icon(Feather.alert_circle),
          ),
        ),
      ),
    );
  }

  _launchUrl(String path) async {
    if (await canLaunch(Uri.encodeFull(path))) {
      await launch(Uri.encodeFull(path));
    } else {
      throw 'Could not launch $path';
    }
  }

  Widget renderFileThumbnail(String fileUrl, String fileName) {
    return Container(
      child: new Material(
        child: new InkWell(
          onTap: () => {_launchUrl(fileUrl)},
          child: new Container(
            width: 80.0,
            height: 80.0,
            child: Center(
              child: Text(
                Utils.getFileExtension(fileName),
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        color: Colors.transparent,
      ),
      color: Colors.blueGrey[200],
    );
  }
}

class HeroPhotoViewWrapper extends StatelessWidget {
  const HeroPhotoViewWrapper({
    this.imageProvider,
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
  });

  final ImageProvider imageProvider;
  final LoadingBuilder loadingBuilder;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height,
      ),
      child: PhotoView(
        imageProvider: imageProvider,
        loadingBuilder: loadingBuilder,
        backgroundDecoration: backgroundDecoration,
        minScale: minScale,
        maxScale: maxScale,
        heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
      ),
    );
  }
}
