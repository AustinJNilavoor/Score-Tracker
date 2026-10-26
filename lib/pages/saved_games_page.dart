import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/game_model.dart';
import 'score_board_page.dart';

class SavedGamesPage extends StatelessWidget {
  const SavedGamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<GameModel>('games');

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F6FA),
        elevation: 0,
        title: const Text(
          'Saved Games',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, box, _) {
          final games = box.values.toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          if (games.isEmpty) {
            return const Center(
              child: Text(
                'No Saved Games',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 18,
              mainAxisSpacing: 18,
              childAspectRatio: 1.35,
            ),
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];

              int topScore = 0;

              for (final player in game.players) {
                if (player.total > topScore) {
                  topScore = player.total;
                }
              }

              return InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ScoreBoardPage(
                        playerNames: game.players.map((e) => e.name).toList(),
                        existingGame: game,
                      ),
                    ),
                  );
                },

                child: Container(
                  padding: const EdgeInsets.all(22),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),

                    boxShadow: [
                      BoxShadow(
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                        color: Colors.black.withOpacity(0.04),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Game ${index + 1}',
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const Spacer(),

                          Icon(
                            Icons.history,
                            size: 18,
                            color: Colors.grey.shade500,
                          ),
                        ],
                      ),

               const Spacer(),

Row(
  crossAxisAlignment:
      CrossAxisAlignment.center,
  children: [
    Expanded(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            '${game.players.length}',
            style: const TextStyle(
              fontSize: 54,
              fontWeight:
                  FontWeight.bold,
              height: 1,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            game.players.length == 1
                ? 'Player'
                : 'Players',
            style: TextStyle(
              fontSize: 18,
              color:
                  Colors.grey.shade700,
            ),
          ),
        ],
      ),
    ),

    Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),

      decoration: BoxDecoration(
        color: const Color(
          0xFFFFF7E8,
        ),

        borderRadius:
            BorderRadius.circular(
          22,
        ),

        border: Border.all(
          color: const Color(
            0xFFFFD54F,
          ),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.emoji_events,
                size: 18,
                color: Color(
                  0xFFFFB300,
                ),
              ),

              const SizedBox(width: 6),

              Text(
                'Top Player',
                style: TextStyle(
                  fontSize: 12,
                  color:
                      Colors.grey.shade700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            game.players
                .reduce(
                  (a, b) => a.total >
                          b.total
                      ? a
                      : b,
                )
                .name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  ],
),

const SizedBox(height: 22),
                      Row(
                        children: [
                          Expanded(child: infoCard('Top Score', '$topScore')),

                          const SizedBox(width: 12),

                          Expanded(
                            child: infoCard(
                              'Date',
                              '${game.createdAt.day}/${game.createdAt.month}/${game.createdAt.year}',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget infoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FC),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),

          const SizedBox(height: 6),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
