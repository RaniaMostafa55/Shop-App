import 'package:flutter/material.dart';
import 'package:shop_app/modules/login/login_screen%20.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/styles/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool isLast = false;
  var boardingController = PageController();
  List<BoardingModel> content = [
    BoardingModel("assets/images/onboarding1.png", "Onboarding1", "body1"),
    BoardingModel("assets/images/onboarding1.png", "Onboarding2", "body2"),
    BoardingModel("assets/images/onboarding1.png", "Onboarding3", "body3"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed: () {
                  submit(context);
                },
                child: const Text("Skip"))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  onPageChanged: (index) {
                    if (index == content.length - 1) {
                      setState(() {
                        isLast = true;
                      });
                    } else {
                      setState(() {
                        isLast = false;
                      });
                    }
                  },
                  controller: boardingController,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => BuildBoardingItem(
                    model: content[index],
                  ),
                  itemCount: content.length,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothPageIndicator(
                      controller: boardingController,
                      count: content.length,
                      effect: const ExpandingDotsEffect(
                          activeDotColor: defaultColor,
                          dotColor: Colors.grey,
                          dotHeight: 10,
                          dotWidth: 10,
                          expansionFactor: 4,
                          spacing: 5)),
                  const Spacer(),
                  FloatingActionButton(
                    onPressed: () {
                      if (isLast) {
                        submit(context);
                      } else {
                        boardingController.nextPage(
                            duration: const Duration(milliseconds: 750),
                            curve: Curves.fastLinearToSlowEaseIn);
                      }
                    },
                    child: const Icon(Icons.arrow_forward_ios),
                  )
                ],
              )
            ],
          ),
        ));
  }
}

class BuildBoardingItem extends StatelessWidget {
  final BoardingModel model;
  const BuildBoardingItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Image(
            image: AssetImage(model.image),
            height: 300,
          ),
        ),
        const SizedBox(height: 30),
        Text(
          model.title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        Text(
          model.body,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}

class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel(this.image, this.title, this.body);
}

void submit(context) {
  CacheHelper.putBool(key: "onboarding", value: true).then((value) {
    if (value) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ));
    }
  });
}
