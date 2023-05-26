import 'package:flutter/material.dart';

class ExpandableCard extends StatefulWidget {
  final String title;
  final String text;
  final String image;
  const ExpandableCard(
      {Key? key, required this.title, required this.text, required this.image})
      : super(key: key);

  @override
  ExpandableCardState createState() => ExpandableCardState();
}

class ExpandableCardState extends State<ExpandableCard> {
  bool isWidthExpanded = false;
  bool isHeightExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: const EdgeInsets.all(8.0),
      duration: const Duration(milliseconds: 200),
      height: isHeightExpanded ? MediaQuery.of(context).size.height : 160.0,
      width: isWidthExpanded
          ? MediaQuery.of(context).size.width - 16
          : MediaQuery.of(context).size.width / 2,
      child: Card(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFF0081),
                      Color(0xFFFF00E4),
                      Color(0xFFF15700),
                    ],
                  ),
                ),
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
                              aspectRatio: 16 / 9,
                              child: Image.asset(
                                widget.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 2)),
                          Text(
                            widget.title,
                            style: const TextStyle(color: Colors.white),
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
                            flex: 10,
                            child: SizedBox(
                              height: 400,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.title,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5)),
                                  Text(
                                    widget.text.length > 100
                                        ? '${widget.text.substring(0, 100)}...'
                                        : widget.text,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                  const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10)),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isHeightExpanded = true;
                                      });
                                    },
                                    child: const Text(
                                      'Plus d\'infos',
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
                          Flexible(
                            child: Image.asset(
                              'assets/images/paris.jpeg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12)),
                          Text(
                            widget.title,
                            style: const TextStyle(color: Colors.white),
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12)),
                          Text(
                            widget.text,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
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
          ],
        ),
      ),
    );
  }
}
