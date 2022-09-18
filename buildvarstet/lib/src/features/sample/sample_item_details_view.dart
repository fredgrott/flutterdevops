import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lifecycle/lifecycle.dart';

/// Displays detailed information about a SampleItem.
class SampleItemDetailsView extends StatelessWidget {
  const SampleItemDetailsView({super.key});

  static const routeName = '/sample_item';

  @override
  Widget build(BuildContext context) {
    return LifecycleWrapper(
      onLifecycleEvent: (event) {
        log(event.toString());
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Item Details'),
        ),
        body: const Center(
          child: Text('More Information Here'),
        ),
      ),
    );

   
  }
}
