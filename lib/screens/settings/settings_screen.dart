// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../chatbot_screen.dart';
import 'services/routes_list.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _systemIdController = TextEditingController();
  bool _notificationsEnabled = true;
  bool _defaultTextFeedback = true;
  bool _showChatbotButton = true;
  bool _autoSaveFeedback = false;
  List<String> _favoriteRoutes = [];
  String? _selectedFavoriteRoute;
  String? _selectedDefaultRoute; // For default route in profile
  String? _selectedStopsRoute; // For viewing stops in dialog

  // Route data structure: Map of bus number to list of stops with times

  @override
  void initState() {
    super.initState();
    debugPrint('Initializing SettingsScreen');
    _loadUserData();
    _loadSettings();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final prefs = await SharedPreferences.getInstance();
    if (user != null) {
      setState(() {
        _nameController.text = user.displayName ?? '';
        _systemIdController.text =
            prefs.getString('systemId') ?? 'Numl-S22-18799';
        _selectedDefaultRoute = prefs.getString('defaultRoute');
      });
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _defaultTextFeedback = prefs.getBool('defaultTextFeedback') ?? true;
      _showChatbotButton = prefs.getBool('showChatbotButton') ?? true;
      _autoSaveFeedback = prefs.getBool('autoSaveFeedback') ?? false;
      _favoriteRoutes = prefs.getStringList('favoriteRoutes') ?? [];
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', _notificationsEnabled);
    await prefs.setBool('defaultTextFeedback', _defaultTextFeedback);
    await prefs.setBool('showChatbotButton', _showChatbotButton);
    await prefs.setBool('autoSaveFeedback', _autoSaveFeedback);
    await prefs.setStringList('favoriteRoutes', _favoriteRoutes);
  }

  Future<void> _updateProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    final prefs = await SharedPreferences.getInstance();
    if (user != null) {
      try {
        await user.updateDisplayName(_nameController.text);
        await prefs.setString('systemId', _systemIdController.text);
        if (_selectedDefaultRoute != null) {
          await prefs.setString('defaultRoute', _selectedDefaultRoute!);
        }
        debugPrint(
          'Updated profile: Name=${_nameController.text}, SystemID=${_systemIdController.text}, DefaultRoute=$_selectedDefaultRoute',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } catch (e) {
        debugPrint('Error updating profile: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
      }
    }
  }

  Future<void> _addFavoriteRoute() async {
    if (_selectedFavoriteRoute != null &&
        !_favoriteRoutes.contains(_selectedFavoriteRoute)) {
      setState(() {
        _favoriteRoutes.add(_selectedFavoriteRoute!);
      });
      await _saveSettings();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added $_selectedFavoriteRoute to favorites')),
      );
    }
  }

  Future<void> _removeFavoriteRoute(String route) async {
    setState(() {
      _favoriteRoutes.remove(route);
    });
    await _saveSettings();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Removed $route from favorites')));
  }

  Future<void> _clearFeedbackData() async {
    debugPrint('Cleared feedback data');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Feedback data cleared')));
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _showProfileDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.black,
            title: const Text(
              'Edit Profile',
              style: TextStyle(color: Colors.white),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[400],
                      hintText: 'Full Name',
                      hintStyle: const TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _systemIdController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[400],
                      hintText: 'System ID (e.g., Numl-S22-18799)',
                      hintStyle: const TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _selectedDefaultRoute,
                    hint: const Text(
                      'Select Default Route',
                      style: TextStyle(color: Colors.black54),
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[400],
                      prefixIcon: const Icon(
                        Icons.directions_bus,
                        color: Colors.blue,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items:
                        routes.keys.map((bus) {
                          return DropdownMenuItem(
                            value: bus,
                            child: Text(
                              bus,
                              style: const TextStyle(color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDefaultRoute = value;
                        debugPrint('Selected default route: $value');
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _selectedStopsRoute,
                    hint: const Text(
                      'View Route Stops',
                      style: TextStyle(color: Colors.black54),
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[400],
                      prefixIcon: const Icon(Icons.map, color: Colors.blue),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items:
                        routes.keys.map((bus) {
                          return DropdownMenuItem(
                            value: bus,
                            child: Text(
                              bus,
                              style: const TextStyle(color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStopsRoute = value;
                        debugPrint('Selected stops route: $value');
                      });
                    },
                  ),
                  if (_selectedStopsRoute != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: routes[_selectedStopsRoute]!.length,
                        itemBuilder: (context, index) {
                          final stop = routes[_selectedStopsRoute]![index];
                          return ListTile(
                            title: Text(
                              '${stop['stop']} (${stop['time']})',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await _updateProfile();
                  Navigator.pop(context);
                },
                child: const Text('Save', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
      'Building SettingsScreen, screen height: ${MediaQuery.of(context).size.height}',
    );
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  title: const Text(
                    'Edit Profile',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Name: ${_nameController.text}, System ID: ${_systemIdController.text}, Default Route: ${_selectedDefaultRoute ?? 'None'}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.edit, color: Colors.blue),
                  onTap: _showProfileDialog,
                ),
                const Divider(color: Colors.grey),
                const Text(
                  'Route Preferences',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: _selectedFavoriteRoute,
                  hint: const Text(
                    'Select Route to Add',
                    style: TextStyle(color: Colors.black54),
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[400],
                    prefixIcon: const Icon(
                      Icons.directions_bus,
                      color: Colors.blue,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items:
                      routes.keys.map((bus) {
                        return DropdownMenuItem(
                          value: bus,
                          child: Text(
                            bus,
                            style: const TextStyle(color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFavoriteRoute = value;
                      debugPrint('Selected favorite route: $value');
                    });
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addFavoriteRoute,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(double.infinity, 40),
                  ),
                  child: const Text('Add to Favorite Routes'),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Favorite Routes',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                _favoriteRoutes.isEmpty
                    ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'No favorite routes added',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _favoriteRoutes.length,
                      itemBuilder: (context, index) {
                        final route = _favoriteRoutes[index];
                        return ListTile(
                          title: Text(
                            route,
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeFavoriteRoute(route),
                          ),
                        );
                      },
                    ),
                const Divider(color: Colors.grey),
                const Text(
                  'Notifications',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SwitchListTile(
                  title: const Text(
                    'Enable Notifications',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    'Receive feedback and bus updates',
                    style: TextStyle(color: Colors.grey),
                  ),
                  value: _notificationsEnabled,
                  activeColor: Colors.blue,
                  onChanged: (value) async {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                    await _saveSettings();
                  },
                ),
                const Divider(color: Colors.grey),
                const Text(
                  'Feedback Preferences',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SwitchListTile(
                  title: const Text(
                    'Default to Text Feedback',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    'Use text feedback by default',
                    style: TextStyle(color: Colors.grey),
                  ),
                  value: _defaultTextFeedback,
                  activeColor: Colors.blue,
                  onChanged: (value) async {
                    setState(() {
                      _defaultTextFeedback = value;
                    });
                    await _saveSettings();
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Auto-Save Feedback Drafts',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    'Save feedback drafts automatically',
                    style: TextStyle(color: Colors.grey),
                  ),
                  value: _autoSaveFeedback,
                  activeColor: Colors.blue,
                  onChanged: (value) async {
                    setState(() {
                      _autoSaveFeedback = value;
                    });
                    await _saveSettings();
                  },
                ),
                const Divider(color: Colors.grey),
                const Text(
                  'Chatbot',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SwitchListTile(
                  title: const Text(
                    'Show FEEDCHAT Button',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    'Display chatbot button in feedback screen',
                    style: TextStyle(color: Colors.grey),
                  ),
                  value: _showChatbotButton,
                  activeColor: Colors.blue,
                  onChanged: (value) async {
                    setState(() {
                      _showChatbotButton = value;
                    });
                    await _saveSettings();
                  },
                ),
                const Divider(color: Colors.grey),
                const Text(
                  'Privacy & Security',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListTile(
                  title: const Text(
                    'Clear Feedback Data',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    'Remove all saved feedback',
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.delete_forever, color: Colors.red),
                  onTap: _clearFeedbackData,
                ),
                ListTile(
                  title: const Text(
                    'Log Out',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: const Icon(Icons.exit_to_app, color: Colors.red),
                  onTap: _logout,
                ),
                const Divider(color: Colors.grey),
                const Text(
                  'App Information',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListTile(
                  title: const Text(
                    'App Version',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    'Version 1.0.0',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ListTile(
                  title: const Text(
                    'Contact Support',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    'support@universitytransport.com',
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.email, color: Colors.blue),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatbotScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text(
                    'Help',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    'How to submit feedback',
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.help, color: Colors.blue),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            backgroundColor: Colors.black,
                            title: const Text(
                              'Help',
                              style: TextStyle(color: Colors.white),
                            ),
                            content: const Text(
                              'To submit feedback:\n1. Enter your Name and System ID.\n2. Select a route.\n3. Provide text or voice feedback.\n4. Click Submit.',
                              style: TextStyle(color: Colors.white),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'OK',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                    );
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
