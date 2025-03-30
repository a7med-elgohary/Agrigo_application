import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    try {
      final response = await http.get(
        Uri.parse('https://weather-api167.p.rapidapi.com/api/weather/current?place=London%2CGB&units=metric&lang=en&mode=json'),
        headers: {
          'Accept': 'application/json',
          'x-rapidapi-host': 'weather-api167.p.rapidapi.com',
          'x-rapidapi-key': '24405c5fb7msh97c7ea8a489bcfdp1b30e9jsn4eee0bca0075',
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildWeatherCard(),
            _buildSearchBar(),
            _buildCategoryTabs(),
            _buildPlantList(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildWeatherCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Colors.green, Colors.lightGreen],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              _getWeatherIcon(),
              size: 50,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              "${_weatherData['temp'].round()}°",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _weatherData['condition'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Max: ${_weatherData['temp_max'].round()}°  Min: ${_weatherData['temp_min'].round()}°",
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getWeatherIcon() {
    switch (_weatherData['condition'].toString().toLowerCase()) {
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.beach_access;
      case 'clear':
        return Icons.wb_sunny;
      default:
        return Icons.cloud;
    }
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
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _CategoryTab(label: "Indoor", isSelected: true),
          _CategoryTab(label: "Flowers"),
          _CategoryTab(label: "Green"),
        ],
      ),
    );
  }

  Widget _buildPlantList() {
    return const Column(
      children: [
        _PlantCard(
          image: 'assets/images/plant1.png',
          name: "Monstera Adansonii",
          family: "Monstera family",
        ),
        _PlantCard(
          image: 'assets/images/plant1.png',
          name: "Janda Bolong",
          family: "Agung suka family",
        ),
        _PlantCard(
          image: 'assets/images/plant1.png',
          name: "Janda Bolong",
          family: "Agung suka family",
        ),
        _PlantCard(
          image: 'assets/images/plant1.png',
          name: "Janda Bolong",
          family: "Agung suka family",
        ),
      ],
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
            onTap: () {},
          ),
          _NavBarItem(
            iconPath: 'assets/icons/bookmark.png',
            isSelected: false,
            onTap: () {},
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

  const _CategoryTab({required this.label, this.isSelected = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}

class _PlantCard extends StatelessWidget {
  final String image;
  final String name;
  final String family;

  const _PlantCard({
    required this.image,
    required this.name,
    required this.family,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              icon: const Icon(Icons.add, color: Colors.green),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}