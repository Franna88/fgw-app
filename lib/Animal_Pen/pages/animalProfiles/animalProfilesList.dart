import 'package:farming_gods_way/Animal_Pen/pages/New_Animal/newAnimal.dart';
import 'package:farming_gods_way/Animal_Pen/pages/animalProfiles/animalProfile.dart';
import 'package:farming_gods_way/Animal_Pen/pages/animalProfiles/ui/animalProfileItem.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../CommonUi/Buttons/commonButton.dart';
import '../../../CommonUi/cornerHeaderContainer.dart';
import '../../../Constants/colors.dart';
import '../../../Constants/myutility.dart';

class AnimalProfilesList extends StatefulWidget {
  const AnimalProfilesList({super.key});

  @override
  State<AnimalProfilesList> createState() => _AnimalProfilesListState();
}

class _AnimalProfilesListState extends State<AnimalProfilesList> {
  bool _isLoading = false;
  
  // Sample animal data - would come from a database in a real app
  final List<Map<String, dynamic>> _animals = [
    {
      'name': 'John',
      'gender': 'male',
      'image': 'images/livestock.png',
      'age': '2 years',
      'type': 'Sheep',
    },
    {
      'name': 'Sammy',
      'gender': 'female',
      'image': 'images/livestock.png',
      'age': '1.5 years',
      'type': 'Sheep',
    },
    {
      'name': 'Lucy',
      'gender': 'female',
      'image': 'images/livestock.png',
      'age': '3 years',
      'type': 'Cattle',
    },
    {
      'name': 'Rex',
      'gender': 'male',
      'image': 'images/livestock.png',
      'age': '4 years',
      'type': 'Cattle',
    },
  ];
  
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredAnimals = [];
  bool _isSearching = false;
  
  @override
  void initState() {
    super.initState();
    _filteredAnimals = List.from(_animals);
    _searchController.addListener(_filterAnimals);
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  void _filterAnimals() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredAnimals = List.from(_animals);
      } else {
        _filteredAnimals = _animals.where((animal) {
          return animal['name'].toLowerCase().contains(query) ||
                 animal['type'].toLowerCase().contains(query);
        }).toList();
      }
    });
  }
  
  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _filteredAnimals = List.from(_animals);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: myColors.offWhite,
      body: SafeArea(
        child: Container(
          height: MyUtility(context).height,
          width: screenWidth,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [myColors.forestGreen, myColors.lightGreen],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(60),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 15),
              CornerHeaderContainer(
                header: 'Animal Profiles', 
                hasBackArrow: true,
              ).animate().fadeIn(duration: 300.ms),
              
              const SizedBox(height: 15),
              
              // Search or action area
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: _isSearching 
                  ? _buildSearchField(myColors)
                  : _buildActionButtons(myColors, screenWidth),
              ),
              
              const SizedBox(height: 15),
              
              // Animal profiles grid
              Expanded(
                child: Container(
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildAnimalProfilesGrid(screenWidth),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: myColors.yellow,
        foregroundColor: myColors.black,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewAnimal()),
          );
        },
      ),
    );
  }
  
  Widget _buildSearchField(MyColors myColors) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search animals...',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                hintStyle: TextStyle(color: Colors.grey[400]),
              ),
              style: GoogleFonts.roboto(),
              autofocus: true,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _toggleSearch,
            color: Colors.grey[600],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).moveX(begin: 20, end: 0);
  }
  
  Widget _buildActionButtons(MyColors myColors, double screenWidth) {
    return Row(
      children: [
        Expanded(
          child: CommonButton(
            customHeight: 50,
            customWidth: double.infinity,
            buttonText: 'Add New Animal',
            textColor: myColors.black,
            buttonColor: myColors.yellow,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewAnimal()),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: myColors.offWhite,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              Icons.search,
              color: myColors.black,
            ),
            onPressed: _toggleSearch,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: myColors.offWhite,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              Icons.filter_list,
              color: myColors.black,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Filter options coming soon'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildAnimalProfilesGrid(double screenWidth) {
    final myColors = MyColors();
    
    if (_filteredAnimals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pets,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              _isSearching ? 'No animals found' : 'No animals added yet',
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isSearching 
                ? 'Try a different search term'
                : 'Add an animal to get started',
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 300.ms);
    }
    
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _filteredAnimals.length,
      itemBuilder: (context, index) {
        final animal = _filteredAnimals[index];
        return _buildAnimalCard(animal, myColors, index);
      },
    );
  }
  
  Widget _buildAnimalCard(Map<String, dynamic> animal, MyColors myColors, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AnimalProfile()),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animal image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.asset(
                    animal['image'],
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          animal['name'],
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Icon(
                          animal['gender'] == 'male' ? Icons.male : Icons.female,
                          color: animal['gender'] == 'male' 
                              ? Colors.lightBlueAccent 
                              : Colors.pinkAccent,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: myColors.forestGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      animal['age'],
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: myColors.lightGreen.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      animal['type'],
                      style: GoogleFonts.roboto(
                        color: myColors.forestGreen,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      Icon(
                        Icons.touch_app,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Tap for details',
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          color: Colors.grey[500],
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
    ).animate(delay: (100 * index).ms)
      .fadeIn(duration: 400.ms)
      .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad);
  }
}
