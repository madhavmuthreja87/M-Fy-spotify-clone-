import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListeningStatsScreen extends StatefulWidget {
  const ListeningStatsScreen({super.key});

  @override
  State<ListeningStatsScreen> createState() => _ListeningStatsScreenState();
}

class _ListeningStatsScreenState extends State<ListeningStatsScreen> {
  // Get current week's Monday and next Monday
  Map<String, DateTime> getCurrentWeekRange() {
    final now = DateTime.now();

    final start = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));

    final end = start.add(const Duration(days: 7));

    return {'start': start, 'end': end};
  }

  final formatter = DateFormat('dd MMM');

  @override
  Widget build(BuildContext context) {
    final weekRange = getCurrentWeekRange();

    final startDate = weekRange['start']!;
    final endDate = weekRange['end']!.subtract(const Duration(days: 1));

    final weekText =
        '${formatter.format(startDate)} - ${formatter.format(endDate)}';

    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Listening stats',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 14),
        child: Column(
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "This week",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.query_stats_outlined,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    Text(
                      weekText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15.3,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const Icon(Icons.share_outlined, color: Colors.white, size: 25),
              ],
            ),

            // Statistics cards
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 26.0),
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height / 2,
                width: double.infinity,

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Minutes listened
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: const Color.fromARGB(88, 136, 136, 136),
                            ),
                            height: MediaQuery.sizeOf(context).height / 8,

                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 8,
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Minutes listened",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "116",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 42,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Top artist
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: const Color.fromARGB(88, 136, 136, 136),
                            ),
                            height: MediaQuery.sizeOf(context).height * (3 / 9),

                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 8,
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Top artist",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 11,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                                Text(
                                  "AP Dhillon",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Right card
                    Expanded(
                      child: Container(
                        height: MediaQuery.sizeOf(context).height * (3 / 9),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: const Color.fromARGB(88, 136, 136, 136),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 8,
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Top artist",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 11,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            Text(
                              "AP Dhillon",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
