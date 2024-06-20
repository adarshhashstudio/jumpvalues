// Function to show all selected values when the button is clicked
import 'package:flutter/material.dart';

Widget selectionContainerForAll(BuildContext context,
        {String? heading,
        bool isLoading = false,
        double? spaceBelowTitle,
        BorderRadiusGeometry? borderRadius,
        List<Widget> children = const <Widget>[],
        bool isError = false}) =>
    Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        border: isError
            ? Border.all(color: Colors.red)
            : Border.all(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (heading != null)
            Text(
              '$heading${isError ? ' required *' : ''}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isError
                        ? Colors.red
                        : Theme.of(context).textTheme.titleSmall?.color,
                  ),
            ),
          if (heading != null)
            SizedBox(
              height:
                  spaceBelowTitle ?? MediaQuery.of(context).size.height * 0.04,
            ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: children,
                )
        ],
      ),
    );
