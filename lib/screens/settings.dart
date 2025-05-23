import 'package:flutter/material.dart';
import 'package:kalendi/screens/info_page.dart';
import 'package:kalendi/screens/about_us.dart';
import 'package:package_info_plus/package_info_plus.dart'; //  Add this import

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _appVersion = '1.0.0'; // Default fallback

  Future<void> _fetchAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform(); //  Uses platform info
      setState(() {
        _appVersion = info.version;
      });
    } catch (e) {
      // Optional: log error or show in debug only
      debugPrint('Failed to fetch app version: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAppVersion(); //  Fetches version asynchronously
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Main Settings List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                //  App Info
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.info_outline,
                      color: Colors.green,
                    ),
                    title: const Text(
                      'App Info',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Version $_appVersion',
                    ), //  Shows real version
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const InfoPage()),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),

                //  Developer → Navigates to About Us
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.person, color: Colors.teal),
                    title: const Text(
                      'Developer',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AboutUs()),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),

                //  Licenses
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.document_scanner_outlined,
                      color: Colors.blue,
                    ),
                    title: const Text(
                      'Licenses',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () => _showLicensesDialog(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //  License Dialog
  void _showLicensesDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('Licenses'),
            content: const Text(
              'This Kalendi app uses open-source libraries under the following licenses: MIT, Apache 2.0, and BSD.',
            ),
            actions: [
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }
}
