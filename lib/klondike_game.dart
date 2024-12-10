import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';

import 'src/components/card.dart';
import 'src/components/foundation_pile.dart';
import 'src/components/stock_pile.dart';
import 'src/components/tableau_pile.dart';
import 'src/components/waste_pile.dart';

class KlondikeGame extends FlameGame {
  static const double cardWidth = 1000.0;
  static const double cardHeight = 1400.0;
  static const double cardGap = 175.0;
  static const double cardRadius = 100.0;
  static final Vector2 cardSize = Vector2(cardWidth, cardHeight);

  // final int klondikeDraw = 3;
  final int klondikeDraw = 1;

  //
  static final cardRRect = RRect.fromRectAndRadius(
    const Rect.fromLTWH(0, 0, cardWidth, cardHeight),
    const Radius.circular(cardRadius),
  );

  @override
  Future<void> onLoad() async {
    await Flame.images.load('klondike-sprites.png');

    final stockPile = StockPile()
      ..size = cardSize
      ..position = Vector2(cardGap, cardGap);
    final wastePile = WastePile()
      ..size = cardSize
      ..position = Vector2(cardWidth + 2 * cardGap, cardGap);
    final foundations = List.generate(
      4,
      (i) => FoundationPile(i)
        ..size = cardSize
        ..position =
            Vector2((i + 3) * (cardWidth + cardGap) + cardGap, cardGap),
    );
    final tableauPiles = List.generate(
      7,
      (i) => TableauPile()
        ..size = cardSize
        ..position = Vector2(
          cardGap + i * (cardWidth + cardGap),
          cardHeight + 2 * cardGap,
        ),
    );

    world.add(stockPile);
    world.add(wastePile);
    world.addAll(foundations);
    world.addAll(tableauPiles);
    camera.viewfinder.visibleGameSize =
        Vector2(cardWidth * 7 + cardGap * 8, 4 * cardHeight + 3 * cardGap);
    camera.viewfinder.position = Vector2(cardWidth * 3.5 + cardGap * 4, 0);
    camera.viewfinder.anchor = Anchor.topCenter;

    // final cards = [
    //   for (var rank = 1; rank <= 13; rank++)
    //     for (var suit = 0; suit < 4; suit++) Card(rank, suit)
    // ];
    // cards.shuffle();
    // world.addAll(cards);
    // cards.forEach(stockPile.acquireCard);

    final cards = [
      for (var rank = 1; rank <= 13; rank++)
        for (var suit = 0; suit < 4; suit++) Card(rank, suit)
    ];
    cards.shuffle();
    world.addAll(cards);

    int cardToDeal = cards.length - 1;
    for (var i = 0; i < 7; i++) {
      for (var j = i; j < 7; j++) {
        tableauPiles[j].acquireCard(cards[cardToDeal--]);
      }
      tableauPiles[i].flipTopCard();
    }
    for (int n = 0; n <= cardToDeal; n++) {
      stockPile.acquireCard(cards[n]);
    }
  }
}

Sprite klondikeSprite(double x, double y, double width, double height) {
  return Sprite(
    Flame.images.fromCache('klondike-sprites.png'),
    srcPosition: Vector2(x, y),
    srcSize: Vector2(width, height),
  );
}
