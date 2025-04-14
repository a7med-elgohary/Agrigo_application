import 'package:flutter/material.dart';
import '../PlanetDetail/PlantDetailScreen.dart';

class BookmarkScreen extends StatefulWidget {
  final List<Map<String, dynamic>> bookmarkedPlants;

  const BookmarkScreen({
    Key? key,
    required this.bookmarkedPlants,
  }) : super(key: key);

  @override
  _BookmarkScreenState createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  late List<Map<String, dynamic>> _bookmarkedPlants;

  @override
  void initState() {
    super.initState();
    _bookmarkedPlants = widget.bookmarkedPlants;
  }

  void _removeBookmark(int index) {
    setState(() {
      _bookmarkedPlants.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Favorites",
          style: TextStyle(
            color: Colors.green,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _bookmarkedPlants.isEmpty
          ? const Center(
              child: Text(
                'No favorite plants',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            )
          : ListView.builder(
              itemCount: _bookmarkedPlants.length,
              itemBuilder: (context, index) {
                final plant = _bookmarkedPlants[index];
                return Dismissible(
                  key: Key(plant['name']),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) => _removeBookmark(index),
                  child: _PlantCard(
                    image: plant['image'],
                    name: plant['name'],
                    family: plant['family'],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlantDetailsScreen(
                            name: plant['name'],
                            family: plant['family'],
                            image: plant['image'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

class _PlantCard extends StatelessWidget {
  final String image;
  final String name;
  final String family;
  final VoidCallback onTap;

  const _PlantCard({
    required this.image,
    required this.name,
    required this.family,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
            ],
          ),
        ),
      ),
    );
  }
} 