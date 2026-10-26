import 'package:hive/hive.dart';

part 'game_model.g.dart';

@HiveType(typeId: 0)
class GameModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  List<PlayerScore> players;

  @HiveField(2)
  DateTime createdAt;

  GameModel({
    required this.id,
    required this.players,
    required this.createdAt,
  });
}

@HiveType(typeId: 1)
class PlayerScore extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<int> scores;

  PlayerScore({
    required this.name,
    required this.scores,
  });

  int get total => scores.fold(0, (a, b) => a + b);
}