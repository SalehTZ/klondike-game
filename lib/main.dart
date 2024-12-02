import 'package:battle_sim/klondike_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

void main() {
  final game = KlondikeGame();
  runApp(GameWidget(game: game));
}