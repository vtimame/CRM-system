import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:oycrm/bloc/BoardScreen/OpenedCardBloc.dart';
import 'package:oycrm/ui/SmallInput.dart';
import 'package:oycrm/utils/ServiceLocator.dart';

class Address extends StatefulWidget {
  final address;
  Address({Key key, this.address}) : super(key: key);

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  @override
  Widget build(BuildContext context) {
    final OpenedCardBloc openedCardBloc = sl<OpenedCardBloc>();

    final streetController = TextEditingController();
    final streetNumController = TextEditingController();
    final buildingController = TextEditingController();
    final literaController = TextEditingController();
    final floorController = TextEditingController();
    final officeController = TextEditingController();

    streetController.text = (widget.address['street'] ?? '').toString();
    streetNumController.text = (widget.address['street_num'] ?? '').toString();
    buildingController.text = (widget.address['building'] ?? '').toString();
    literaController.text = (widget.address['litera'] ?? '').toString();
    floorController.text = (widget.address['floor'] ?? '').toString();
    officeController.text = (widget.address['office'] ?? '').toString();

    return ExpandablePanel(
      hasIcon: false,
      header: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          '${(widget.address['street'] ?? '').toString()} ${(widget.address['street_num'] ?? '').toString()}',
        ),
      ),
      expanded: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 10,
                child: SmallInput(
                  hint: 'Улица',
                  controller: streetController,
                  onChange: (value) =>
                      openedCardBloc.update('address.street', value),
                ),
              ),
              SizedBox(
                width: 8.0,
              ),
              Expanded(
                flex: 5,
                child: SmallInput(
                  hint: 'Номер дома',
                  controller: streetNumController,
                  onChange: (value) =>
                      openedCardBloc.update('address.street_num', value),
                ),
              )
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: SmallInput(
                  hint: 'Корпус',
                  controller: buildingController,
                  onChange: (value) =>
                      openedCardBloc.update('address.building', value),
                ),
              ),
              SizedBox(
                width: 8.0,
              ),
              Expanded(
                flex: 1,
                child: SmallInput(
                  hint: 'Литера',
                  controller: literaController,
                  onChange: (value) =>
                      openedCardBloc.update('address.litera', value),
                ),
              ),
              SizedBox(
                width: 8.0,
              ),
              Expanded(
                flex: 1,
                child: SmallInput(
                  hint: 'Этаж',
                  controller: floorController,
                  onChange: (value) =>
                      openedCardBloc.update('address.floor', value),
                ),
              ),
              SizedBox(
                width: 8.0,
              ),
              Expanded(
                flex: 1,
                child: SmallInput(
                  hint: 'Офис',
                  controller: officeController,
                  onChange: (value) =>
                      openedCardBloc.update('address.office', value),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
