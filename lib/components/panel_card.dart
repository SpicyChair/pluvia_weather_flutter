import 'package:flutter/material.dart';

class PanelCard extends StatelessWidget {
  final Widget cardChild;

  PanelCard({
    this.cardChild,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: cardChild,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,

      ),
    );
  }
}
