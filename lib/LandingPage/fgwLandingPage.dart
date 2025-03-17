import 'dart:math';

import 'package:farming_gods_way/CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:farming_gods_way/LandingPage/ui/todayTaskProggress.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather/weather.dart';

class FgwLandingPage extends StatefulWidget {
  const FgwLandingPage({super.key});

  @override
  State<FgwLandingPage> createState() => _FgwLandingPageState();
}

class _FgwLandingPageState extends State<FgwLandingPage> {
  // List of Bible verses
  final List<String> _dummyTextList = [
    "May God give you of heaven’s dew and of earth’s richness – an abundance of grain and new wine. – Genesis 27:28",
    "The Lord will send a blessing on your barns and on everything you put your hand to. The Lord your God will bless you in the land. – Deuteronomy 28:8",
    " May God give you of heaven’s dew and of earth’s richness – an abundance of grain and new wine. – Genesis 27:28",
    "I alone know the plans I have for you, plans to bring you prosperity and not disaster, plans to bring about the future you hope for. – Jeremiah 29:11",
    "Jesus said to them, “The times and occasions are set by my Father’s own authority, and it is not for you to know when they will be.” – Acts 1:7",
    "Be sure you know the conditions of your flocks, give careful attention to your herds; for riches do not endure forever, and a crown is not secure for all generations. – Proverbs 27:34-35",
    "Plant your seed in the morning and keep busy all afternoon, for you don’t know if profit will come from one activity or another—or maybe both. – Ecclesiastes 11:6",
    'Those too lazy to plow in the right season will have no food at the harvest. – Proverbs 20:4',
    'Good planning and hard work lead to prosperity, but hasty shortcuts lead to poverty. – Proverbs 21:5',
    'The farmer knows just what to do, for God has given him understanding. … The Lord of Heaven’s Armies is a wonderful teacher and he gives the farmer great wisdom. – Isaiah 28:26, 29',
    'He will also send you rain for the seed you sow in the ground, and the food that comes from the land will be rich and plentiful. In that day your cattle will graze in broad meadows. – Isaiah 30:23',
    'As long as the earth endures, seedtime and harvest, cold and heat, summer and winter, day and night will never cease. – Genesis 8:22',
    'The one who plants and the one who waters work together with the same purpose. And both will be rewarded for their own hard work. – 1 Corinthians 3:8',
    'When you have eaten and are satisfied, praise the Lord your God for the good land he has given you. – Deuteronomy 8:10',
    'Then we your people, the sheep of your pasture, will thank you forever and ever, praising your greatness from generation to generation. – Psalm 79:13'
  ];

  // Get random text from the list
  String _getRandomText() {
    final random = Random();
    return _dummyTextList[random.nextInt(_dummyTextList.length)];
  }

  final WeatherFactory _weatherFactory =
      WeatherFactory('YOUR_OPENWEATHER_API_KEY');
  Weather? _weather;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      Weather weather =
          await _weatherFactory.currentWeatherByCityName('YourCity');
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      debugPrint('Failed to fetch weather: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().forestGreen,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FgwTopBar(),
          SizedBox(
            height: MyUtility(context).height * 0.03,
          ),
          Container(
            //weather display PLACEHOLDER
            color: Colors.amber,
            height: MyUtility(context).height * 0.30,
            width: MyUtility(context).width,
            child: Center(
              child: Text('Weather Placeholder'),
            ),
          ),
          //WEATHER SECTION
          // Container(
          //   //color: Colors.amber,
          //   height: 150,
          //   width: double.infinity,
          //   child: Center(
          //     child: _weather != null
          //         ? Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Text(
          //                   '${_weather?.temperature?.celsius?.toStringAsFixed(1)}°C',
          //                   style: const TextStyle(
          //                       fontSize: 24, fontWeight: FontWeight.bold)),
          //               Text(_weather?.weatherDescription ?? ''),
          //             ],
          //           )
          //         : const CircularProgressIndicator(),
          //   ),
          // ),
          SizedBox(
            height: MyUtility(context).height * 0.03,
          ),
          Container(
            height: 200,
            width: MyUtility(context).width * 0.90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: MyColors().offWhite,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  _getRandomText(), // Display random text
                  textAlign: TextAlign.center,
                  style: GoogleFonts.robotoSlab(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: MyUtility(context).height * 0.02,
          ),
          TodayTaskProggress()
        ],
      ),
    );
  }
}
