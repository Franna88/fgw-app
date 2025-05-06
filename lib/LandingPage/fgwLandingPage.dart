import 'dart:math';

import 'package:farming_gods_way/CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import 'package:farming_gods_way/CommonUi/modern_card.dart';
import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:farming_gods_way/LandingPage/ui/todayTaskProggress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

class FgwLandingPage extends StatefulWidget {
  const FgwLandingPage({super.key});

  @override
  State<FgwLandingPage> createState() => _FgwLandingPageState();
}

class _FgwLandingPageState extends State<FgwLandingPage> {
  // List of Bible verses
  final List<String> _dummyTextList = [
    "May God give you of heaven's dew and of earth's richness – an abundance of grain and new wine. – Genesis 27:28",
    "The Lord will send a blessing on your barns and on everything you put your hand to. The Lord your God will bless you in the land. – Deuteronomy 28:8",
    "May God give you of heaven's dew and of earth's richness – an abundance of grain and new wine. – Genesis 27:28",
    "I alone know the plans I have for you, plans to bring you prosperity and not disaster, plans to bring about the future you hope for. – Jeremiah 29:11",
    "Jesus said to them, 'The times and occasions are set by my Father's own authority, and it is not for you to know when they will be.' – Acts 1:7",
    "Be sure you know the conditions of your flocks, give careful attention to your herds; for riches do not endure forever, and a crown is not secure for all generations. – Proverbs 27:34-35",
    "Plant your seed in the morning and keep busy all afternoon, for you don't know if profit will come from one activity or another—or maybe both. – Ecclesiastes 11:6",
    'Those too lazy to plow in the right season will have no food at the harvest. – Proverbs 20:4',
    'Good planning and hard work lead to prosperity, but hasty shortcuts lead to poverty. – Proverbs 21:5',
    'The farmer knows just what to do, for God has given him understanding. … The Lord of Heaven\'s Armies is a wonderful teacher and he gives the farmer great wisdom. – Isaiah 28:26, 29',
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
  String _currentVerse = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
    _currentVerse = _getRandomText();

    // Simulate loading for demo purposes
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _fetchWeather() async {
    try {
      // Using a default location for demo purposes
      Weather weather =
          await _weatherFactory.currentWeatherByCityName('Johannesburg');
      if (mounted) {
        setState(() {
          _weather = weather;
        });
      }
    } catch (e) {
      debugPrint('Failed to fetch weather: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    final today = DateTime.now();
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');

    return Scaffold(
      backgroundColor: myColors.forestGreen,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Top bar
            const FgwTopBar(),

            // Main content
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    _isLoading = true;
                    _currentVerse = _getRandomText();
                  });
                  await _fetchWeather();

                  // Simulate loading for demo purposes
                  await Future.delayed(const Duration(seconds: 1));
                  if (mounted) {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  children: [
                    // Date display
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.calendarDay,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            dateFormat.format(today),
                            style: GoogleFonts.robotoSlab(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Weather card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ModernCard(
                        height: 130,
                        color: myColors.lightBlue.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16),
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Row(
                                children: [
                                  // Weather icon and temperature
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        _weather != null
                                            ? Icon(
                                                _getWeatherIcon(
                                                    _weather!.weatherMain ??
                                                        ''),
                                                size: 42,
                                                color: Colors.white,
                                              )
                                            : const SizedBox.shrink(),
                                        const SizedBox(height: 8),
                                        _weather != null
                                            ? Text(
                                                '${_weather?.temperature?.celsius?.toStringAsFixed(1)}°C',
                                                style: GoogleFonts.robotoSlab(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : Text(
                                                'No data',
                                                style: GoogleFonts.robotoSlab(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),

                                  // Weather details
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _weather?.areaName ?? 'Location',
                                          style: GoogleFonts.robotoSlab(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _weather?.weatherDescription
                                                  ?.toUpperCase() ??
                                              'Weather information',
                                          style: GoogleFonts.robotoSlab(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  const FaIcon(
                                                    FontAwesomeIcons.wind,
                                                    size: 12,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '${_weather?.windSpeed?.toStringAsFixed(1) ?? "0"} m/s',
                                                    style:
                                                        GoogleFonts.robotoSlab(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  const FaIcon(
                                                    FontAwesomeIcons.droplet,
                                                    size: 12,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '${_weather?.humidity ?? "0"}%',
                                                    style:
                                                        GoogleFonts.robotoSlab(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Daily verse
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ModernCard(
                        color: myColors.offWhite,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.bookBible,
                                  size: 16,
                                  color: Colors.black87,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Daily Verse',
                                  style: GoogleFonts.robotoSlab(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _currentVerse,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.robotoSlab(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Today's task progress
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TodayTaskProggress(),
                    ),

                    const SizedBox(height: 24),

                    // Quick Links
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4, bottom: 12),
                            child: Text(
                              'Quick Links',
                              style: GoogleFonts.robotoSlab(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          // Grid of quick links
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            childAspectRatio: 2.8,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            children: [
                              _buildQuickLink(
                                'Tasks',
                                FontAwesomeIcons.listCheck,
                                myColors.yellow,
                                () {},
                              ),
                              _buildQuickLink(
                                'Fields',
                                FontAwesomeIcons.leaf,
                                myColors.lightGreen,
                                () {},
                              ),
                              _buildQuickLink(
                                'Animals',
                                FontAwesomeIcons.cow,
                                myColors.offWhite,
                                () {},
                              ),
                              _buildQuickLink(
                                'Inventory',
                                FontAwesomeIcons.boxesStacked,
                                myColors.lightBlue,
                                () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickLink(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              FaIcon(
                icon,
                size: 16,
                color: color == MyColors().offWhite
                    ? MyColors().black
                    : Colors.black87,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: color == MyColors().offWhite
                        ? MyColors().black
                        : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(
        begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOutQuad);
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return FontAwesomeIcons.sun;
      case 'clouds':
        return FontAwesomeIcons.cloud;
      case 'rain':
        return FontAwesomeIcons.cloudRain;
      case 'drizzle':
        return FontAwesomeIcons.cloudRain;
      case 'thunderstorm':
        return FontAwesomeIcons.cloudBolt;
      case 'snow':
        return FontAwesomeIcons.snowflake;
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return FontAwesomeIcons.smog;
      default:
        return FontAwesomeIcons.sun;
    }
  }
}
