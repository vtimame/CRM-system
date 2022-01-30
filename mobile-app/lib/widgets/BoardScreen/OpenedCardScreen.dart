import 'package:expandable/expandable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oycrm/bloc/BoardScreen/OpenedCardBloc.dart';
import 'package:oycrm/bloc/BoardScreen/OpenedCardScreen/AttachmentsBloc.dart';
import 'package:oycrm/bloc/BoardScreen/OpenedCardScreen/EventsBloc.dart';
import 'package:oycrm/bloc/NotificationsBloc.dart';
import 'package:oycrm/bloc/UserBloc.dart';
import 'package:oycrm/ui/LoadingScreen.dart';
import 'package:oycrm/utils/AppRouter.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:oycrm/utils/SocketConnection.dart';
import 'package:oycrm/widgets/BoardScreen/OpenedCardScreen/Address.dart';
import 'package:oycrm/widgets/BoardScreen/OpenedCardScreen/Attachments.dart';
import 'package:oycrm/widgets/BoardScreen/OpenedCardScreen/Contacts.dart';
import 'package:oycrm/widgets/BoardScreen/OpenedCardScreen/Events.dart';
import 'package:oycrm/widgets/BoardScreen/OpenedCardScreen/NewManagerProfile.dart';
import 'package:oycrm/widgets/BoardScreen/OpenedCardScreen/NewManagerProfile/RawProfileData.dart';
import 'package:oycrm/widgets/BoardScreen/OpenedCardScreen/OpenedCardBottomBar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'OpenedCardScreen/ExploringProfile.dart';

class OpenedCardScreen extends StatefulWidget {
  @override
  _OpenedCardState createState() => _OpenedCardState();
}

class _OpenedCardState extends State<OpenedCardScreen> {
  final picker = ImagePicker();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await sl<OpenedCardBloc>()
        .loadCardInstance(sl<OpenedCardBloc>().openedCard.value['_id']);
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    _readAllNotifications();
  }

  _readAllNotifications() {
    String cardId = sl<OpenedCardBloc>().openedCard.value['_id'];
    List<dynamic> notificationsIds =
        sl<NotificationsBloc>().cardNotificationsIds(cardId);

    if (notificationsIds.length > 0) {
      sl<NotificationsBloc>().readNotifications(notificationsIds);
    }
  }

  @override
  void dispose() {
    String cardId = sl<OpenedCardBloc>().openedCard.value['_id'];
    sl<SocketConnection>().echo.leave('card.$cardId');
    sl<EventsBloc>().eventsSink.add(null);
    super.dispose();
  }

  _goBack() {
    AppRouter.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final OpenedCardBloc cardBloc = sl<OpenedCardBloc>();

    return Container(
      color: Colors.grey[50],
      child: SafeArea(
          child: StreamBuilder(
        stream: cardBloc.openedCardStream,
        builder: (context, card) {
          if (card.connectionState == ConnectionState.waiting ||
              card.data == null) {
            return LoadingScreen();
          }

          sl<AttachmentsBloc>().loadAttachments(card.data['attachments'] ?? []);

          return Scaffold(
              bottomSheet: OpenedCardBottomBar(),
              body: Padding(
                padding: EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 8.0, bottom: 50),
                child: SmartRefresher(
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Feather.arrow_left,
                                size: 16,
                                color: Colors.blue[600],
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                "Вернуться назад",
                                style: TextStyle(color: Colors.blue[600]),
                              )
                            ],
                          ),
                        ),
                        Text(
                          card.data['title'] ?? 'Неизвестная карточка',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                        renderCardLocation(
                            card.data['board'], card.data['column']),
                        Address(address: card.data['address']),
                        renderDescription(card.data['description']),
                        Contacts(contacts: card.data['contacts'] ?? []),
                        renderServices(card.data['services'] ?? []),
                        NewManagerProfile(
                          profile: {
                            ...rawProfileData,
                            ...card.data['newManagerProfile'] ?? {}
                          },
                          disabled: !sl<UserBloc>().checkColumnPermission(
                              card.data['board_id'],
                              card.data['column_id'],
                              'edit_manager_profile'),
                        ),
                        ExploringProfile(
                          profile: card.data['exploring_profile'] ?? [],
                          disabled: !sl<UserBloc>().checkColumnPermission(
                              card.data['board_id'],
                              card.data['column_id'],
                              'edit_exploring_profile'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Вложения',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            InkWell(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 9.0),
                                child: Icon(Feather.upload_cloud, size: 18.0),
                              ),
                              onTap: () => _showAttachmentSheet(context),
                            ),
                          ],
                        ),
                        StreamBuilder(
                          stream: sl<AttachmentsBloc>().loadingStream,
                          builder: (context, state) {
                            if (state.connectionState ==
                                    ConnectionState.active &&
                                state.data == true) {
                              return LinearProgressIndicator();
                            } else
                              return Container(
                                height: 5.0,
                              );
                          },
                        ),
                        Attachments(),
                        Events()
                      ],
                    ),
                  ),
                ),
              ));
        },
      )),
    );

//    return WillPopScope(
//      onWillPop: () => Router.pop(context),
//      child: ,
//    );
  }

  Future _getImage(BuildContext context) async {
    Map card = sl<OpenedCardBloc>().openedCard.value;
    final PickedFile pickedFile =
        await picker.getImage(source: ImageSource.camera);

    await sl<AttachmentsBloc>()
        .uploadAttachments(card['_id'], {pickedFile.path: pickedFile.path});
  }

  Future _getImageFromGallery(BuildContext context) async {
    Map card = sl<OpenedCardBloc>().openedCard.value;
    final PickedFile pickedFile =
        await picker.getImage(source: ImageSource.gallery);

    await sl<AttachmentsBloc>()
        .uploadAttachments(card['_id'], {pickedFile.path: pickedFile.path});
  }

  Future _getFileFromStorage(BuildContext context) async {
    Map card = sl<OpenedCardBloc>().openedCard.value;
    Map<String, String> files = await FilePicker.getMultiFilePath();
    await sl<AttachmentsBloc>().uploadAttachments(card['_id'], files);
  }

  void _showAttachmentSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              width: double.infinity,
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Feather.aperture),
                    title: Text('Сделать фото'),
                    onTap: () {
                      _getImage(context);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Feather.file),
                    title: Text('Выбрать из галереи'),
                    onTap: () {
                      _getImageFromGallery(context);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Feather.file),
                    title: Text('Выбрать документ'),
                    onTap: () {
                      _getFileFromStorage(context);
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget renderCardLocation(Map board, Map column) {
    String boardName = 'Неизвестная доска';
    String columnName = 'Неизвестная колонка';

    if (board != null) boardName = board['name'];
    if (column != null) columnName = column['name'];

    return Text('$boardName / $columnName');
  }

  Widget renderServices(List services) {
    if (services.length > 0) {
      List<Widget> serviceWidgets = [];
      services.forEach((service) {
        List<Widget> serviceFields = [];
        service['fields'].forEach((field) {
          serviceFields.add(Text("${field['value']} ${field['title']}",
              style: TextStyle(color: Colors.blue[700])));
          serviceFields.add(SizedBox(
            width: 8.0,
          ));
        });

        serviceWidgets.add(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              service['title'].toString().trim(),
              style: TextStyle(
                  color: Colors.blue[700], fontWeight: FontWeight.w600),
            ),
            Row(
              children: serviceFields,
            )
          ],
        ));
      });

      return ExpandablePanel(
        header: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Услуги',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        expanded: Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: serviceWidgets,
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget renderDescription(String description) {
    return ExpandablePanel(
      header: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          'Описание',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      expanded: Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: Text((description ?? 'Без описания').toString()),
      ),
    );
  }

  Widget renderContacts(List contacts) {
    if (contacts.length > 0) {
      List<Widget> contactViews = [];
      contacts.forEach((el) => contactViews.add(
            Container(
              width: double.infinity,
              child: Material(
                child: InkWell(
                  onTap: () => print(el),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '${el['surname'] ?? ''} ${el['name'] ?? ''} ${el['patronymic'] ?? ''}',
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.w600),
                        ),
                        Text('numbers')
                      ],
                    ),
                  ),
                ),
                color: Colors.transparent,
              ),
            ),
          ));

      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.blueGrey[50],
            borderRadius: BorderRadius.all(Radius.circular(3.0))),
        child: Wrap(
          children: contactViews,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(color: Colors.blueGrey[50]),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text('Здесь пока нет ни одного контакта'),
        ),
      ),
    );
  }

  Widget renderExploringProfile(dynamic profile) {
    return Text('exploring profile');
  }

  Widget renderAttachments(List attachments) {
    return Text('attachments');
  }
}
