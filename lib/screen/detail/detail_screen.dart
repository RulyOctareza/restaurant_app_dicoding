import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/detail/restaurant_detail_provider.dart';
import 'package:restaurant_app/screen/home/home_screen.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();

    // Future.microtask((){
    //   context.read<RestaurantDetailProvider>().fetchRestaurantDetail(widget.);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
