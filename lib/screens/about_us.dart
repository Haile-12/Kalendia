import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      // Open the link in the default external application (browser, app, etc.)
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Info'),
        backgroundColor: const Color.fromARGB(255, 10, 204, 107),
        foregroundColor: Colors.white,
        elevation: 5,
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        color: Colors.teal.shade50,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {},
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'Assets/images/developer.png',
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => const Icon(
                              Icons.person,
                              size: 140,
                              color: Colors.teal,
                            ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Haile Tassew',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                    shadows: [
                      Shadow(
                        color: Colors.black12,
                        offset: Offset(1, 1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                _buildInfoItem(Icons.phone, '+251945987335'),
                const SizedBox(height: 16),
                _buildInfoItem(Icons.email, 'hailetassew4545@gmail.com'),
                const SizedBox(height: 30),

                const Text(
                  'Connect with me:',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(
                      Icons.telegram,
                      'https://t.me/zhtb12',
                      Colors.blueAccent,
                    ),
                    const SizedBox(width: 12),
                    _buildSocialButton(
                      Icons.facebook,
                      'https://web.facebook.com/hailsh.love.71',
                      Colors.blue,
                    ),
                    const SizedBox(width: 12),
                    _buildSocialButton(
                      Icons.camera_alt,
                      'https://instagram.com/hela_6812',
                      Colors.purple,
                    ),
                    const SizedBox(width: 12),
                    _buildSocialButton(
                      Icons.code,
                      'https://github.com/Haile-12',
                      Colors.black,
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white,
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Feel free to reach out through any of the platforms above.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 74, 141, 85),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.teal),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(fontSize: 18)),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, String url, Color iconColor) {
    return InkWell(
      onTap: () => _launchURL(url),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: iconColor, width: 2),
          color: Colors.white,
        ),
        child: Icon(icon, color: iconColor, size: 30),
      ),
    );
  }
}
