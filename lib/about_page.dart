import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  final String githubUrl =
      "https://github.com/your-github-repo"; // Update this!

  Future<void> _launchURL() async {
    Uri url = Uri.parse(githubUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $githubUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About Us")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Meet Our Team",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "We are a passionate team dedicated to building helpful apps!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              _buildDeveloperGrid(),
              const SizedBox(height: 16),
              _buildInfoSection(),
              const SizedBox(height: 16),
              _buildCopyrightSection(),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _launchURL,
                icon: const Icon(Icons.open_in_browser),
                label: const Text("Visit GitHub Page"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeveloperGrid() {
    List<Map<String, String>> developers = [
      {
        "name": "Aishah Yusof",
        "role": "Lead Developer",
        "image": "assets/images/aishah.png",
      },
      {
        "name": "Nurin Batrisyia",
        "role": "UI/UX Designer",
        "image": "assets/images/nurin.jpg",
      },
      {
        "name": "Syahindah",
        "role": "Backend Developer",
        "image": "assets/images/indah.jpg",
      },
      {
        "name": "Nurul Rahimah",
        "role": "Mobile Developer",
        "image": "assets/images/ima.jpg",
      },
      {
        "name": "Nur Ayuni Izzah",
        "role": "Database Manager",
        "image": "assets/images/yuni.jpg",
      },
      {
        "name": "Najah Nasuha",
        "role": "QA Engineer",
        "image": "assets/images/najah.jpg",
      },
      {
        "name": "Nur Ezzati",
        "role": "Project Manager",
        "image": "assets/images/zati.jpg",
      },
      {
        "name": "Nurizzah Hanani",
        "role": "Security Specialist",
        "image": "assets/images/han.jpg",
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.8, // Supaya grid nampak lebih kemas
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: developers.length,
      itemBuilder: (context, index) {
        return _buildDeveloperCard(
          developers[index]["name"]!,
          developers[index]["role"]!,
          developers[index]["image"]!,
        );
      },
    );
  }

  Widget _buildDeveloperCard(String name, String role, String imagePath) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24, // Besarkan sikit gambar
              backgroundImage: AssetImage(imagePath), // Load gambar dari assets
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  role,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Divider(),
        SizedBox(height: 8),
        Text(
          "Application Information",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          "This app helps users locate nearby hospitals and provides accurate location details.",
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCopyrightSection() {
    return Column(
      children: const [
        Divider(),
        SizedBox(height: 8),
        Text(
          "Copyright",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text("© 2025 Hospital Locator App. All rights reserved."),
      ],
    );
  }
}
