import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../models/game_model.dart';

class ScoreBoardPage extends StatefulWidget {
  final List<String> playerNames;
  final GameModel? existingGame;

  const ScoreBoardPage({
    super.key,
    required this.playerNames,
    this.existingGame,
  });

  @override
  State<ScoreBoardPage> createState() => _ScoreBoardPageState();
}

class _ScoreBoardPageState extends State<ScoreBoardPage> {
  late List<String> players;
  late List<List<int>> scores;
  bool hasUnsavedChanges = false;

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    players = [...widget.playerNames];

    if (widget.existingGame != null) {
      scores = widget.existingGame!.players.map((e) => [...e.scores]).toList();
    } else {
      scores = List.generate(players.length, (_) => []);
    }
  }

  int total(int index) {
    return scores[index].fold(0, (a, b) => a + b);
  }

  int get maxRounds {
    int max = 1;

    for (final s in scores) {
      if (s.length > max) max = s.length;
    }

    return max;
  }

  Future<void> addPlayer() async {
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,

      barrierColor: Colors.black.withOpacity(0.18),

      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,

          child: Container(
            width: 300,

            padding: const EdgeInsets.all(18),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(22),

              boxShadow: [
                BoxShadow(
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                  color: Colors.black.withOpacity(0.10),
                ),
              ],
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                Container(
                  width: 50,
                  height: 50,

                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,

                    shape: BoxShape.circle,
                  ),

                  child: Icon(
                    Icons.person_add_alt_1_rounded,

                    size: 24,

                    color: Colors.blue.shade700,
                  ),
                ),

                const SizedBox(height: 14),

                const Text(
                  'Add Player',

                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                Text(
                  'Enter player name',

                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),

                const SizedBox(height: 16),

                Container(
                  height: 58,

                  alignment: Alignment.center,

                  padding: const EdgeInsets.symmetric(horizontal: 18),

                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F7FC),

                    borderRadius: BorderRadius.circular(16),

                    border: Border.all(color: const Color(0xFFE5EAF2)),
                  ),

                  child: TextField(
                    controller: controller,

                    autofocus: true,

                    textCapitalization: TextCapitalization.words,

                    onSubmitted: (value) {
                      Navigator.pop(context, value);
                    },

                    decoration: const InputDecoration(
                      border: InputBorder.none,

                      hintText: 'Player Name',

                      isCollapsed: true,
                    ),

                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,

                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },

                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey.shade700,

                            side: BorderSide(color: Colors.grey.shade300),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),

                          child: const Text(
                            'Cancel',

                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: SizedBox(
                        height: 44,

                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, controller.text);
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),

                            foregroundColor: Colors.white,

                            elevation: 0,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),

                          child: const Text(
                            'Add',

                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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

    if (result != null && result.trim().isNotEmpty) {
      setState(() {
        players.add(result.trim());
        scores.add([]);
        hasUnsavedChanges = true;
      });
    }
  }

  Future<void> addScore(int player) async {
    String value = '';
    bool negative = false;

    final result = await showDialog<int>(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState2) {
            int score = int.tryParse(value) ?? 0;

            if (negative) {
              score = -score;
            }

            Widget numBtn(String n) {
              return InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  setState2(() {
                    value += n;
                  });
                },
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE7ECF3)),
                  ),
                  child: Center(
                    child: Text(
                      n,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }

            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: 340,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      players[player],
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 22),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F7FC),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          value.isEmpty
                              ? '${negative ? '-' : ''}0'
                              : '${negative ? '-' : ''}$value',
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.45,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ...[
                          '1',
                          '2',
                          '3',
                          '4',
                          '5',
                          '6',
                          '7',
                          '8',
                          '9',
                        ].map(numBtn),

                        InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () {
                            setState2(() {
                              negative = !negative;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: negative
                                  ? const Color(0xFFFFF1F1)
                                  : const Color(0xFFF4F7FC),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: negative
                                    ? const Color(0xFFFFD6D6)
                                    : const Color(0xFFE7ECF3),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                negative ? '-' : '+',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: negative
                                      ? Colors.red.shade400
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ),

                        numBtn('0'),

                        InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () {
                            setState2(() {
                              if (value.isNotEmpty) {
                                value = value.substring(0, value.length - 1);
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF1F1),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFFFFD6D6),
                              ),
                            ),
                            child: const Center(
                              child: Icon(Icons.backspace_outlined, size: 22),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, score);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          negative ? 'Subtract Score' : 'Add Score',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        scores[player].add(result);
        hasUnsavedChanges = true;
      });
    }
  }

  Future<void> saveGame() async {
    final box = Hive.box<GameModel>('games');

    final playerModels = List.generate(
      players.length,
      (i) => PlayerScore(name: players[i], scores: scores[i]),
    );

    if (widget.existingGame != null) {
      widget.existingGame!.players = playerModels;

      await widget.existingGame!.save();
    } else {
      await box.add(
        GameModel(
          id: const Uuid().v4(),
          players: playerModels,
          createdAt: DateTime.now(),
        ),
      );
    }
    setState(() {
      hasUnsavedChanges = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Game Saved')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !hasUnsavedChanges,

      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final action = await showDialog<String>(
          context: context,

          barrierColor: Colors.black.withOpacity(0.25),

          builder: (_) {
            return Dialog(
              backgroundColor: Colors.transparent,

              child: Container(
                width: 340,

                padding: const EdgeInsets.all(22),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(26),

                  boxShadow: [
                    BoxShadow(
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                      color: Colors.black.withOpacity(0.10),
                    ),
                  ],
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Container(
                      width: 58,
                      height: 58,

                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF4E5),
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.save_outlined,
                        size: 28,
                        color: Color(0xFFFF9800),
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'Save Changes?',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Save game before leaving?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: Colors.grey.shade700,
                      ),
                    ),

                    const SizedBox(height: 22),

                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,

                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context, 'discard');
                              },

                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red.shade400,

                                side: BorderSide(color: Colors.red.shade200),

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),

                              child: const Text(
                                'Discard',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: SizedBox(
                            height: 48,

                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context, 'save');
                              },

                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),

                                foregroundColor: Colors.white,

                                elevation: 0,

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),

                              child: const Text(
                                'Save',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
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

        if (action == 'save') {
          await saveGame();

          if (mounted) {
            Navigator.pop(context);
          }
        }

        if (action == 'discard') {
          hasUnsavedChanges = false;

          if (mounted) {
            Navigator.pop(context);
          }
        }
      },

      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FA),

        appBar: AppBar(
          title: const Text('Game Score'),
          actions: [
            TextButton.icon(
              onPressed: addPlayer,
              icon: const Icon(Icons.person_add, size: 18),
              label: const Text('Player'),
            ),
            TextButton.icon(
              onPressed: saveGame,
              icon: const Icon(Icons.save, size: 18),
              label: const Text('Save'),
            ),
          ],
        ),

        body: SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ...List.generate(players.length, (i) => playerCard(i)),

              addPlayerCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget playerCard(int i) {
    return Container(
      width: 150,
      height: MediaQuery.of(context).size.height - 110,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: (() {
            final totals = scores
                .map((e) => e.fold(0, (a, b) => a + b))
                .toList();

            if (totals.every((e) => e == 0)) {
              return Colors.transparent;
            }

            final uniqueSorted = totals.toSet().toList()
              ..sort((a, b) => b.compareTo(a));

            final totalScore = total(i);

            if (uniqueSorted.isNotEmpty && totalScore == uniqueSorted[0]) {
              return const Color(0xFFFFD54F); // Gold
            }

            if (uniqueSorted.length > 1 && totalScore == uniqueSorted[1]) {
              return const Color(0xFFC0C0C0); // Silver
            }

            if (uniqueSorted.length > 2 && totalScore == uniqueSorted[2]) {
              return const Color(0xFFCD7F32); // Bronze
            }

            return Colors.transparent;
          })(),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 3),
            color: Colors.black.withOpacity(0.04),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.blue.shade50,
            child: Text(players[i][0].toUpperCase()),
          ),

          const SizedBox(height: 8),

          Text(
            players[i],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.grey.shade300,
                  Colors.transparent,
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      ...List.generate(
                        scores[i].length,
                        (index) => scoreTile(i, index),
                      ),

                      addTile(i),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text('TOTAL', style: TextStyle(fontSize: 10)),

                      Text(
                        '${total(i)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget scoreTile(int playerIndex, int scoreIndex) {
    final score = scores[playerIndex][scoreIndex];

    return GestureDetector(
      onLongPress: () async {
        HapticFeedback.mediumImpact();

        setState(() {
          scores[playerIndex].removeAt(scoreIndex);

          hasUnsavedChanges = true;
        });
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),

        height: 50,
        margin: const EdgeInsets.only(bottom: 8),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),

          border: Border.all(color: Colors.grey.shade300),

          color: Colors.white,
        ),

        child: Center(
          child: Text(
            '$score',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,

              color: score < 0 ? Colors.red.shade400 : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget addTile(int player) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        addScore(player);
      },
      child: Container(
        height: 50,
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Icon(Icons.add, size: 22, color: Colors.blue.shade700),
      ),
    );
  }

  Widget addPlayerCard() {
    return InkWell(
      onTap: addPlayer,
      child: Container(
        width: 150,
        height: MediaQuery.of(context).size.height - 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add, color: Colors.blue.shade700, size: 30),

            const SizedBox(height: 10),

            const Text(
              'Add Player',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
