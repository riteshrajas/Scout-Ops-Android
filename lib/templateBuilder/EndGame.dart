

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class EndGameBuilder extends StatefulWidget {
  const EndGameBuilder({Key? key}) : super(key: key);

  @override
  EndGameState createState() => EndGameState();

}

class EndGameState extends State<EndGameBuilder> {
  double _rating = 3;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('EndGame Components'),
        RatingBar.builder(
          initialRating: _rating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
            });
          },
        ),
      ],
    );
  }
}