import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../PlanetDetail/PlantDetailScreen.dart';
import '../bookmark_page/bookmark_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Map<String, dynamic> _weatherData = {
    'temp': 19.0,
    'condition': 'Precipitations',
    'temp_max': 24.0,
    'temp_min': 18.0,
  };
  bool _isLoading = true;
  List<Map<String, dynamic>> _bookmarkedPlants = [];
  String _selectedCategory = 'All';
  final ScrollController _scrollController = ScrollController();
  bool _isSearchBarPinned = false;
  
  final List<String> _categories = [
    'All',
    'Flowers',
    'Vegetables',
    'Fruits',
    'Herbs'
  ];
  
  final List<Map<String, dynamic>> _allPlants = [
    // Flowers
    {
      'name': 'Rose',
      'family': 'Rosaceae',
      'image': 'assets/images/plant1.png',
      'category': 'Flowers',
      'description': 'Classic flowering plant with fragrant blooms',
      'care': 'Full sun, regular watering',
      'watering': 'Water deeply 2-3 times per week',
      'light': 'Full sun (6+ hours daily)',
      'temperature': '15-24°C',
      'humidity': 'Moderate humidity',
      'fertilizing': 'Feed monthly with rose fertilizer'
    },
    {
      'name': 'Jasmine',
      'family': 'Oleaceae',
      'image': 'assets/images/plant1.png',
      'category': 'Flowers',
      'description': 'Fragrant flowering vine with white flowers',
      'care': 'Full sun to partial shade, regular watering',
      'watering': 'Keep soil moist but not soggy',
      'light': 'Full sun to partial shade',
      'temperature': '18-24°C',
      'humidity': 'Moderate to high humidity',
      'fertilizing': 'Feed every 2-3 weeks during growing season'
    },
    {
      'name': 'Sunflower',
      'family': 'Asteraceae',
      'image': 'assets/images/plant1.png',
      'category': 'Flowers',
      'description': 'Tall plant with large yellow flowers',
      'care': 'Full sun, well-drained soil',
      'watering': 'Water deeply once a week',
      'light': 'Full sun',
      'temperature': '18-27°C',
      'humidity': 'Low to moderate humidity',
      'fertilizing': 'Feed with balanced fertilizer monthly'
    },

    // Vegetables
    {
      'name': 'Tomato',
      'family': 'Solanaceae',
      'image': 'assets/images/plant1.png',
      'category': 'Vegetables',
      'description': 'Popular vegetable with red fruits',
      'care': 'Full sun, regular watering',
      'watering': 'Keep soil consistently moist',
      'light': 'Full sun (8+ hours daily)',
      'temperature': '21-27°C',
      'humidity': 'Moderate humidity',
      'fertilizing': 'Feed with tomato fertilizer every 2 weeks'
    },
    {
      'name': 'Cucumber',
      'family': 'Cucurbitaceae',
      'image': 'assets/images/plant1.png',
      'category': 'Vegetables',
      'description': 'Vining plant with crisp fruits',
      'care': 'Full sun, rich soil, regular watering',
      'watering': 'Keep soil consistently moist',
      'light': 'Full sun',
      'temperature': '21-29°C',
      'humidity': 'Moderate to high humidity',
      'fertilizing': 'Feed every 2-3 weeks'
    },
    {
      'name': 'Lettuce',
      'family': 'Asteraceae',
      'image': 'assets/images/plant1.png',
      'category': 'Vegetables',
      'description': 'Fast-growing leafy green',
      'care': 'Partial shade, moist soil',
      'watering': 'Keep soil consistently moist',
      'light': 'Partial shade to full sun',
      'temperature': '15-21°C',
      'humidity': 'Moderate humidity',
      'fertilizing': 'Feed with nitrogen-rich fertilizer'
    },
    {
      'name': 'Bell Pepper',
      'family': 'Solanaceae',
      'image': 'assets/images/plant1.png',
      'category': 'Vegetables',
      'description': 'Colorful vegetable with sweet flavor',
      'care': 'Full sun, well-drained soil',
      'watering': 'Water when soil is dry to touch',
      'light': 'Full sun',
      'temperature': '21-27°C',
      'humidity': 'Moderate humidity',
      'fertilizing': 'Feed every 2 weeks with balanced fertilizer'
    },

    // Fruits
    {
      'name': 'Strawberry',
      'family': 'Rosaceae',
      'image': 'assets/images/plant1.png',
      'category': 'Fruits',
      'description': 'Sweet red berries on trailing plants',
      'care': 'Full sun, well-drained soil',
      'watering': 'Keep soil consistently moist',
      'light': 'Full sun',
      'temperature': '15-24°C',
      'humidity': 'Moderate humidity',
      'fertilizing': 'Feed with balanced fertilizer monthly'
    },
    {
      'name': 'Lemon',
      'family': 'Rutaceae',
      'image': 'assets/images/plant1.png',
      'category': 'Fruits',
      'description': 'Citrus tree with fragrant white flowers',
      'care': 'Full sun, well-drained soil',
      'watering': 'Water when top inch of soil is dry',
      'light': 'Full sun',
      'temperature': '18-29°C',
      'humidity': 'Moderate to high humidity',
      'fertilizing': 'Feed with citrus fertilizer every 2-3 months'
    },
    {
      'name': 'Fig',
      'family': 'Moraceae',
      'image': 'assets/images/plant1.png',
      'category': 'Fruits',
      'description': 'Deciduous tree with sweet fruits',
      'care': 'Full sun, well-drained soil',
      'watering': 'Water deeply once a week',
      'light': 'Full sun',
      'temperature': '15-27°C',
      'humidity': 'Moderate humidity',
      'fertilizing': 'Feed with balanced fertilizer in spring'
    },

    // Herbs
    {
      'name': 'Mint',
      'family': 'Lamiaceae',
      'image': 'assets/images/plant1.png',
      'category': 'Herbs',
      'description': 'Fragrant herb with spreading habit',
      'care': 'Partial shade, moist soil',
      'watering': 'Keep soil consistently moist',
      'light': 'Partial shade to full sun',
      'temperature': '15-24°C',
      'humidity': 'Moderate humidity',
      'fertilizing': 'Feed monthly with balanced fertilizer'
    },
    {
      'name': 'Basil',
      'family': 'Lamiaceae',
      'image': 'assets/images/plant1.png',
      'category': 'Herbs',
      'description': 'Aromatic herb with green leaves',
      'care': 'Full sun, moist soil',
      'watering': 'Keep soil moist but not soggy',
      'light': 'Full sun',
      'temperature': '18-24°C',
      'humidity': 'Moderate humidity',
      'fertilizing': 'Feed every 2-3 weeks'
    },
    {
      'name': 'Parsley',
      'family': 'Apiaceae',
      'image': 'assets/images/plant1.png',
      'category': 'Herbs',
      'description': 'Biennial herb with bright green leaves',
      'care': 'Full sun to partial shade',
      'watering': 'Keep soil consistently moist',
      'light': 'Full sun to partial shade',
      'temperature': '15-24°C',
      'humidity': 'Average humidity',
      'fertilizing': 'Feed monthly with balanced fertilizer'
    }
  ];

  List<Map<String, dynamic>> get _filteredPlants {
    if (_selectedCategory == 'All') {
      return _allPlants;
    }
    return _allPlants.where((plant) => plant['category'] == _selectedCategory).toList();
  }

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset >= 200 && !_isSearchBarPinned) {
      setState(() {
        _isSearchBarPinned = true;
      });
    } else if (_scrollController.offset < 200 && _isSearchBarPinned) {
      setState(() {
        _isSearchBarPinned = false;
      });
    }
  }

  Future<void> _fetchWeatherData() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://weather-api167.p.rapidapi.com/api/weather/current?place=Cairo%2CEG&units=metric&lang=en&mode=json'),
        headers: {
          'Accept': 'application/json',
          'x-rapidapi-host': 'weather-api167.p.rapidapi.com',
          'x-rapidapi-key':
              '24405c5fb7msh97c7ea8a489bcfdp1b30e9jsn4eee0bca0075',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _weatherData = {
            'temp': data['main']['temp'],
            'condition': data['weather'][0]['main'],
            'temp_max': data['main']['temp_max'],
            'temp_min': data['main']['temp_min'],
          };
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.green),
          onPressed: () {
            Navigator.pushNamed(context, '/profile');
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/Logo.png', height: 30),
            const SizedBox(width: 8),
            const Text(
              "Agrigo",
              style: TextStyle(
                color: Colors.green,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.green),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                SizedBox(height: _isSearchBarPinned ? 120 : 0),
                _buildWeatherCard(),
                AnimatedCrossFade(
                  firstChild: Column(
                    children: [
                      _buildSearchBar(),
                      _buildCategoryTabs(),
                    ],
                  ),
                  secondChild: const SizedBox.shrink(),
                  crossFadeState: _isSearchBarPinned ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),
                _buildPlantList(),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: _isSearchBarPinned ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    _buildSearchBar(),
                    _buildCategoryTabs(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildWeatherCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud,
              size: 40,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${(_weatherData['temp'] as num?)?.round() ?? 'N/A'}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "°",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              _weatherData['condition'] ?? 'N/A',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Max: ${(_weatherData['temp_max'] as num?)?.round() ?? 'N/A'}°  Min: ${(_weatherData['temp_min'] as num?)?.round() ?? 'N/A'}°",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _CategoryTab(
              label: category,
              isSelected: _selectedCategory == category,
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlantList() {
    return Column(
      children: _filteredPlants.map((plant) => _PlantCard(
        image: plant['image'],
        name: plant['name'],
        family: plant['family'],
        isBookmarked: _bookmarkedPlants.any((p) => p['name'] == plant['name']),
        onBookmark: (p) {
          setState(() {
            if (_bookmarkedPlants.any((bp) => bp['name'] == p['name'])) {
              _bookmarkedPlants.removeWhere((bp) => bp['name'] == p['name']);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Plant removed from favorites'),
                  backgroundColor: Colors.red,
                ),
              );
            } else {
              _bookmarkedPlants.add(p);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Plant added to favorites'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          });
        },
      )).toList(),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarItem(
            iconPath: 'assets/icons/home.png',
            isSelected: true,
            onTap: () {},
          ),
          _NavBarItem(
            iconPath: 'assets/icons/stats.png',
            isSelected: false,
            onTap: () {},
          ),
          _NavBarItem(
            iconPath: 'assets/icons/chat.png',
            isSelected: false,
            onTap: () {
              Navigator.pushNamed(context, '/chatbot');
            },
          ),
          _NavBarItem(
            iconPath: 'assets/icons/profile.png',
            isSelected: false,
            onTap: () async {
              final ImagePicker picker = ImagePicker();

              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Wrap(
                    children: [
                      ListTile(
                        leading: Icon(Icons.camera),
                        title: Text('التقاط صورة'),
                        onTap: () async {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);
                          Navigator.pop(context);
                          if (image != null) {
                            File selectedImage = File(image.path);
                            print("تم التقاط الصورة: ${selectedImage.path}");
                          }
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.photo_library),
                        title: Text('اختيار من المعرض'),
                        onTap: () async {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery);
                          Navigator.pop(context);
                          if (image != null) {
                            File selectedImage = File(image.path);
                            print("تم اختيار الصورة: ${selectedImage.path}");
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          _NavBarItem(
            iconPath: 'assets/icons/bookmark.png',
            isSelected: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookmarkScreen(
                    bookmarkedPlants: _bookmarkedPlants,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final String iconPath;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.iconPath,
    required this.isSelected,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconPath,
            width: 24,
            height: 24,
            color: isSelected ? Colors.green : Colors.grey,
          ),
        ],
      ),
    );
  }
}

class _CategoryTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.green : Colors.grey,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                height: 2,
                width: 20,
                color: Colors.green,
              ),
          ],
        ),
      ),
    );
  }
}

class _PlantCard extends StatelessWidget {
  final String image;
  final String name;
  final String family;
  final bool isBookmarked;
  final Function(Map<String, dynamic>) onBookmark;

  const _PlantCard({
    required this.image,
    required this.name,
    required this.family,
    required this.isBookmarked,
    required this.onBookmark,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onBookmark({
          'name': name,
          'family': family,
          'image': image,
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  image,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      family,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isBookmarked ? Icons.favorite : Icons.favorite_border,
                  color: Colors.green,
                ),
                onPressed: () {
                  onBookmark({
                    'name': name,
                    'family': family,
                    'image': image,
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
