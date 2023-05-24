import 'package:flutter/material.dart';

class ExpandableCard extends StatefulWidget {
  const ExpandableCard({super.key});

  @override
  _ExpandableCardState createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  bool isExpanded = false;
  bool isWidthExpanded = false;
  bool isHeightExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: isExpanded
          ? (isHeightExpanded ? MediaQuery.of(context).size.height : 160.0)
          : 200.0,
      width: isWidthExpanded
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.width / 2,
      child: Card(
        color: Colors.black,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                color: Colors.grey.shade400,
                icon: Icon(
                  isWidthExpanded
                      ? isHeightExpanded
                          ? Icons.close
                          : Icons.close_fullscreen
                      : Icons.open_in_new_outlined,
                ),
                onPressed: () {
                  setState(() {
                    if (isHeightExpanded) {
                      isHeightExpanded = !isHeightExpanded;
                    } else {
                      isWidthExpanded = !isWidthExpanded;
                    }
                  });
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isWidthExpanded && !isHeightExpanded)
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            constraints: const BoxConstraints(maxHeight: 200),
                            child: AspectRatio(
                              aspectRatio: 16 /
                                  9, // Remplacez par le ratio d'aspect souhaité
                              child: Image.asset(
                                'assets/images/paris.jpeg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5)),
                          const Text(
                            'Title',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  if (!isHeightExpanded && isWidthExpanded)
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 8,
                            child: Image.asset(
                              'assets/images/paris.jpeg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16)),
                          Expanded(
                            flex: 6,
                            child: SizedBox(
                              height: 400,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Title',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  const Text(
                                    'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 10),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isHeightExpanded = true;
                                        isExpanded = true;
                                      });
                                    },
                                    child: const Text(
                                      'Toto',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (isHeightExpanded)
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/paris.jpeg',
                            fit: BoxFit.cover,
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12)),
                          const Text(
                            'Title',
                            style: TextStyle(color: Colors.white),
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12)),
                          const Text(
                            'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, ',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
