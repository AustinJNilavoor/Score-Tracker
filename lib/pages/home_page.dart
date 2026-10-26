import 'package:flutter/material.dart';

import 'game_setup_page.dart';
import 'saved_games_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 1100,
          ),

          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 24,
          ),

          child: Row(
            children: [
              /// LEFT SECTION
              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.all(36),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(
                          36,
                        ),

                        boxShadow: [
                          BoxShadow(
                            blurRadius: 24,
                            offset:
                                const Offset(
                              0,
                              8,
                            ),
                            color: Colors.black
                                .withOpacity(
                              0.04,
                            ),
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Container(
                            width: 74,
                            height: 74,

                            decoration:
                                BoxDecoration(
                              gradient:
                                  const LinearGradient(
                                colors: [
                                  Color(
                                    0xFF2563EB,
                                  ),
                                  Color(
                                    0xFF4F8CFF,
                                  ),
                                ],
                              ),

                              borderRadius:
                                  BorderRadius.circular(
                                22,
                              ),
                            ),

                            child: const Icon(
                              Icons
                                  .leaderboard_rounded,
                              size: 38,
                              color:
                                  Colors.white,
                            ),
                          ),

                          const SizedBox(
                            height: 28,
                          ),

                          const Text(
                            'Score Tracker',
                            style: TextStyle(
                              fontSize: 54,
                              fontWeight:
                                  FontWeight.bold,
                              height: 1,
                            ),
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          Text(
                            'Track scores beautifully for board games, tournaments, parties, and competitions.',
                            style: TextStyle(
                              fontSize: 20,
                              height: 1.5,
                              color: Colors
                                  .grey.shade700,
                            ),
                          ),

                          const SizedBox(
                            height: 38,
                          ),

                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 68,

                                  child:
                                      ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) =>
                                                  const GameSetupPage(),
                                        ),
                                      );
                                    },

                                    style:
                                        ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color(
                                        0xFF2563EB,
                                      ),

                                      foregroundColor:
                                          Colors.white,

                                      elevation: 0,

                                      shape:
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                          22,
                                        ),
                                      ),
                                    ),

                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons
                                              .sports_esports_rounded,
                                          size: 26,
                                        ),

                                        SizedBox(
                                          width: 12,
                                        ),

                                        Text(
                                          'New Game',
                                          style:
                                              TextStyle(
                                            fontSize:
                                                22,
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(
                                width: 18,
                              ),

                              Expanded(
                                child: SizedBox(
                                  height: 68,

                                  child:
                                      OutlinedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) =>
                                                  const SavedGamesPage(),
                                        ),
                                      );
                                    },

                                    style:
                                        OutlinedButton.styleFrom(
                                      foregroundColor:
                                          const Color(
                                        0xFF2563EB,
                                      ),

                                      side:
                                          const BorderSide(
                                        color: Color(
                                          0xFF2563EB,
                                        ),
                                      ),

                                      shape:
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                          22,
                                        ),
                                      ),
                                    ),

                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons
                                              .history_rounded,
                                          size: 24,
                                        ),

                                        SizedBox(
                                          width: 10,
                                        ),

                                        Text(
                                          'Saved Games',
                                          style:
                                              TextStyle(
                                            fontSize:
                                                20,
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 30),

              /// RIGHT SECTION
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    buildFeatureCard(
                      icon:
                          Icons.groups_rounded,
                      title:
                          'Multiplayer Ready',
                      subtitle:
                          'Track scores for up to 12 players in real time.',
                    ),

                    const SizedBox(height: 20),

                    buildFeatureCard(
                      icon:
                          Icons.emoji_events_rounded,
                      title:
                          'Live Rankings',
                      subtitle:
                          'Automatic gold, silver, and bronze highlights.',
                    ),

                    const SizedBox(height: 20),

                    buildFeatureCard(
                      icon:
                          Icons.save_rounded,
                      title:
                          'Save Progress',
                      subtitle:
                          'Continue games anytime with persistent storage.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(28),

        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 6),
            color: Colors.black.withOpacity(
              0.04,
            ),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,

            decoration: BoxDecoration(
              color: const Color(
                0xFFF1F5FF,
              ),
              borderRadius:
                  BorderRadius.circular(
                22,
              ),
            ),

            child: Icon(
              icon,
              size: 34,
              color: const Color(
                0xFF2563EB,
              ),
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.4,
                    color:
                        Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}