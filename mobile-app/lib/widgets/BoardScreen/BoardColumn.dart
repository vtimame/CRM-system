import 'package:flutter/material.dart';
import 'package:oycrm/bloc/BoardScreen/CardsBloc.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:oycrm/widgets/BoardScreen/ColumnCard.dart';

import 'ColumnCard.dart';

class BoardColumn extends StatelessWidget {
  final Map column;

  BoardColumn({this.column});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: sl<CardsBloc>().cardsListStream,
      builder: (context, list) {
        if (list.connectionState == ConnectionState.waiting ||
            list.data == null) {
          return Text('loading');
        }

        List cards = sl<CardsBloc>().columnCards(column['_id']);
        List<Widget> cardsViews = [];
        cards.forEach((el) => cardsViews.add(ColumnCard(card: el)));

        return ListView(
          children: cardsViews,
        );
      },
    );
  }
}
