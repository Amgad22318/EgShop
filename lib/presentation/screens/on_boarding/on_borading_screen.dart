
import 'package:egshop/data/data_provider/local/cache_helper.dart';
import 'package:egshop/presentation/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel {
  late final String image;
  late final String title;
  late final String body;

  BoardingModel({
    required this.image,
    required this.title,
    required this.body,
  });
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen> {
  bool isLast = false;

  PageController boardPageController = PageController();

  final List<BoardingModel> boardingList = [
    BoardingModel(
        image: 'assets/image/onboard_1.png',
        title: 'On Board 1 title',
        body: 'On Board 1 Body'),
    BoardingModel(
        image: 'assets/image/onboard_1.png',
        title: 'On Board 2 title',
        body: 'On Board 2 Body'),
    BoardingModel(
        image: 'assets/image/onboard_1.png',
        title: 'On Board 3 title',
        body: 'On Board 3 Body'),
  ];

  void submit() {
    CacheHelper.saveDataSharedPreference(key: 'onBoarding', value: true);
    Navigator.of(context).pushNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            TextButton(child:
            const Text('Skip'),

              onPressed: () {
                submit();
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  itemBuilder: (context, index) =>
                      buildBoardingItem(boardingList[index]),
                  itemCount: boardingList.length,
                  physics: const BouncingScrollPhysics(),
                  controller: boardPageController,
                  onPageChanged: (int index) {
                    if (index == boardingList.length - 1) {
                      setState(() {
                        isLast = true;
                      });
                    } else {
                      isLast = false;
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  children: [
                    SmoothPageIndicator(
                      controller: boardPageController,
                      count: boardingList.length,
                      effect:  const ExpandingDotsEffect(
                        dotColor: Colors.grey,
                        activeDotColor: greyBlue3,
                        expansionFactor: 4,
                        dotHeight: 10,
                        dotWidth: 10,
                        spacing: 5,
                      ),
                    ),
                    const Spacer(),
                    FloatingActionButton(backgroundColor: greyBlue3,
                      onPressed: () {
                        if (isLast == true) {
                          submit();
                        } else {
                          boardPageController.nextPage(
                              duration: const Duration(milliseconds: 750),
                              curve: Curves.fastLinearToSlowEaseIn);
                        }
                      },
                      child: const Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget buildBoardingItem(BoardingModel boardingListItem) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(image: AssetImage(boardingListItem.image)),
        const SizedBox(
          height: 30,
        ),
        Text(
          boardingListItem.title,
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          boardingListItem.body,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
