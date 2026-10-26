import 'package:flutter/material.dart';

import 'score_board_page.dart';

class GameSetupPage extends StatefulWidget {
  const GameSetupPage({super.key});

  @override
  State<GameSetupPage> createState() => _GameSetupPageState();
}

class _GameSetupPageState extends State<GameSetupPage> {
  int playerCount = 4;

  late List<TextEditingController> controllers;

  late List<FocusNode> focusNodes;

  int activeIndex = -1;

  @override
  void initState() {
    super.initState();

    controllers = List.generate(
      playerCount,
      (i) => TextEditingController(text: 'Player ${i + 1}'),
    );

    focusNodes = List.generate(playerCount, (_) => FocusNode());
  }

  void updateCount(int value) {
    if (value < 2 || value > 12) return;

    setState(() {
      playerCount = value;

      final oldControllers = [...controllers];

      controllers = List.generate(
        playerCount,
        (i) => TextEditingController(
          text: i < oldControllers.length
              ? oldControllers[i].text
              : 'Player ${i + 1}',
        ),
      );

      focusNodes = List.generate(playerCount, (_) => FocusNode());

      if (activeIndex >= playerCount) {
        activeIndex = playerCount - 1;
      }
    });
  }

  @override
  void dispose() {
    for (final c in controllers) {
      c.dispose();
    }

    for (final f in focusNodes) {
      f.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: const Color(0xFFF4F6FA),

      appBar: AppBar(
        elevation: 0,

        backgroundColor: const Color(0xFFF4F6FA),

        title: const Text(
          'New Game',

          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),

      body: Stack(
        children: [
          /// MAIN CONTENT
          SafeArea(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 950),

                padding: const EdgeInsets.all(18),

                child: Column(
                  children: [
                    /// PLAYER COUNT
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 18,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.circular(26),

                        boxShadow: [
                          BoxShadow(
                            blurRadius: 14,

                            offset: const Offset(0, 4),

                            color: Colors.black.withOpacity(0.04),
                          ),
                        ],
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          buildCircleButton(
                            icon: Icons.remove,

                            onTap: () {
                              updateCount(playerCount - 1);
                            },
                          ),

                          const SizedBox(width: 36),

                          Column(
                            children: [
                              Text(
                                '$playerCount',

                                style: const TextStyle(
                                  fontSize: 40,

                                  fontWeight: FontWeight.bold,

                                  height: 1,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                playerCount == 1 ? 'PLAYER' : 'PLAYERS',

                                style: TextStyle(
                                  fontSize: 12,

                                  letterSpacing: 1.5,

                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(width: 36),

                          buildCircleButton(
                            icon: Icons.add,

                            onTap: () {
                              updateCount(playerCount + 1);
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// PLAYER GRID
                    Expanded(
                      child: GridView.builder(
                        itemCount: playerCount,

                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,

                              crossAxisSpacing: 16,

                              mainAxisSpacing: 16,

                              childAspectRatio: 4,
                            ),

                        itemBuilder: (context, index) {
                          final active = activeIndex == index;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 180),

                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,

                              vertical: 14,
                            ),

                            decoration: BoxDecoration(
                              color: Colors.white,

                              borderRadius: BorderRadius.circular(22),

                              border: Border.all(
                                color: active
                                    ? const Color(0xFF2563EB)
                                    : Colors.transparent,

                                width: 2,
                              ),

                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10,

                                  offset: const Offset(0, 3),

                                  color: Colors.black.withOpacity(0.03),
                                ),
                              ],
                            ),

                            child: Row(
                              children: [
                                Container(
                                  width: 46,
                                  height: 46,

                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,

                                    shape: BoxShape.circle,
                                  ),

                                  child: Center(
                                    child: Text(
                                      '${index + 1}',

                                      style: TextStyle(
                                        color: Colors.blue.shade700,

                                        fontWeight: FontWeight.bold,

                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 14),

                                Expanded(
                                  child: Material(
                                    color: Colors.transparent,

                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(14),

                                      onTap: () {
                                        setState(() {
                                          activeIndex = index;
                                        });

                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                              final controller =
                                                  controllers[index];

                                              controller.selection =
                                                  TextSelection(
                                                    baseOffset: 0,
                                                    extentOffset:
                                                        controller.text.length,
                                                  );

                                              focusNodes[index].requestFocus();
                                            });
                                      },

                                      child: Container(
                                        height: double.infinity,

                                        alignment: Alignment.centerLeft,

                                        child: Text(
                                          controllers[index].text.trim().isEmpty
                                              ? 'Player ${index + 1}'
                                              : controllers[index].text,

                                          maxLines: 1,

                                          overflow: TextOverflow.ellipsis,

                                          style: TextStyle(
                                            fontSize: 18,

                                            fontWeight: FontWeight.w600,

                                            color:
                                                controllers[index].text
                                                    .trim()
                                                    .isEmpty
                                                ? Colors.grey.shade500
                                                : Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                Icon(
                                  Icons.edit_rounded,

                                  size: 18,

                                  color: Colors.grey.shade400,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 18),

                    /// START BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 56,

                      child: ElevatedButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ScoreBoardPage(
                                playerNames: controllers
                                    .map((e) => e.text)
                                    .toList(),
                              ),
                            ),
                          );
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),

                          foregroundColor: Colors.white,

                          elevation: 0,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),

                        child: const Text(
                          'Start Game',

                          style: TextStyle(
                            fontSize: 20,

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// FLOATING TOP EDITOR
          if (activeIndex >= 0 && activeIndex < controllers.length)
            Positioned(
              top: 20,
              left: 0,
              right: 0,

              child: Center(
                child: Material(
                  color: Colors.transparent,

                  child: Container(
                    width: 420,
                    height: 72,

                    padding: const EdgeInsets.symmetric(horizontal: 18),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(24),

                      border: Border.all(color: const Color(0xFFE5EAF2)),

                      boxShadow: [
                        BoxShadow(
                          blurRadius: 24,

                          offset: const Offset(0, 8),

                          color: Colors.black.withOpacity(0.12),
                        ),
                      ],
                    ),

                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,

                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,

                            shape: BoxShape.circle,
                          ),

                          child: Center(
                            child: Text(
                              '${activeIndex + 1}',

                              style: TextStyle(
                                color: Colors.blue.shade700,

                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: TextField(
                            controller: controllers[activeIndex],

                            focusNode: focusNodes[activeIndex],

                            autofocus: true,

                            textCapitalization: TextCapitalization.words,

                            onChanged: (_) {
                              setState(() {});
                            },

                            onTapOutside: (_) {
                              if (controllers[activeIndex].text
                                  .trim()
                                  .isEmpty) {
                                controllers[activeIndex].text =
                                    'Player ${activeIndex + 1}';
                              }

                              FocusScope.of(context).unfocus();

                              setState(() {
                                activeIndex = -1;
                              });
                            },

                            onSubmitted: (_) {
                              if (controllers[activeIndex].text
                                  .trim()
                                  .isEmpty) {
                                controllers[activeIndex].text =
                                    'Player ${activeIndex + 1}';
                              }

                              FocusScope.of(context).unfocus();

                              setState(() {
                                activeIndex = -1;
                              });
                            },

                            style: const TextStyle(
                              fontSize: 24,

                              fontWeight: FontWeight.bold,
                            ),

                            decoration: InputDecoration(
                              border: InputBorder.none,

                              hintText: 'Player ${activeIndex + 1}',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),

      onTap: onTap,

      child: Container(
        width: 52,
        height: 52,

        decoration: BoxDecoration(
          color: Colors.white,

          shape: BoxShape.circle,

          border: Border.all(color: const Color(0xFFE5EAF2)),

          boxShadow: [
            BoxShadow(
              blurRadius: 8,

              offset: const Offset(0, 2),

              color: Colors.black.withOpacity(0.03),
            ),
          ],
        ),

        child: Icon(icon, size: 24, color: const Color(0xFF2563EB)),
      ),
    );
  }
}
