import 'package:flutter/material.dart';
import '../../style/typhography/restaurant_text_style.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              titleHeader(),
              subtitleHeader(),
            ],
          ),
        ),
      ),
    );
  }

  Widget titleHeader() {
    return Container(
      margin: const EdgeInsets.only(left: 16),
      child: Text(
        'Restaurant',
        style: blackTextStyle.copyWith(fontSize: 24),
      ),
    );
  }

  Widget subtitleHeader() {
    return Container(
      margin: const EdgeInsets.only(left: 16, top: 8),
      child: Text(
        'Recomendation restaurant for you !',
        style:
            blackTextStyle.copyWith(fontWeight: FontWeight.w600, fontSize: 18),
      ),
    );
  }
}
