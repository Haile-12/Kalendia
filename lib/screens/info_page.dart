import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  String _version = '1.0.0'; // Default

  @override
  void initState() {
    super.initState();
    _fetchAppVersion();
  }

  Future<void> _fetchAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = info.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Info'),
        backgroundColor: const Color.fromARGB(255, 10, 204, 107),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoItem(context, 'App Name', 'Kalendi'),
                  const Divider(height: 24),
                  _buildInfoItem(context, 'Version', _version),
                  const Divider(height: 24),
                  _buildInfoItem(
                    context,
                    'Purpose',
                    'A modern dual calendar converter  uses for seamless date conversion between Gregorian and Ethiopian calendars ,for event scheduling and reminder and also provides like features.',
                  ),
                  const Divider(height: 24),
                  _buildInfoItem(context, 'Developer', 'Haile Tassew'),
                  const Divider(height: 24),
                  _buildInfoItem(
                    context,
                    'Company',
                    'Mekelle Institute of Technology (MIT)',
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        '© 2025 Kalendi APP | All Rights Reserved !',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 28, 149, 64),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String title, String value) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(value),
    );
  }
}
