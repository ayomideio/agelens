import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readmitpredictor/currency-converter/screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:readmitpredictor/ui/auth/login.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:readmitpredictor/languages.dart';

class SettingsScreen extends StatefulWidget {
  final String email, fullname;
  const SettingsScreen({Key? key, required this.email, required this.fullname})
      : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String languageCode = 'en';

  void _changeLanguage(String code) {
    setState(() {
      languageCode = code;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white.withOpacity(.94),
        appBar: AppBar(
          title: Text(
            Languages.getTranslation('settings', languageCode),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              SimpleUserCard(
                userName: Languages.getTranslation(
                  'welcome',
                  languageCode,
                  params: {'name': widget.fullname},
                ),
                userProfilePic: AssetImage("assets/vectors/settings.png"),
              ),
              // Language Switcher
              ListTile(
                title: Text('Language'),
                trailing: DropdownButton<String>(
                  value: languageCode,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      _changeLanguage(newValue);
                    }
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'en',
                      child: Text('English'),
                    ),
                    DropdownMenuItem(
                      value: 'es',
                      child: Text('Español'),
                    ),
                  ],
                ),
              ),
              SettingsGroup(
                backgroundColor: Colors.blue,
                items: [
                  SettingsItem(
                    onTap: () {},
                    icons: CupertinoIcons.pencil_outline,
                    iconStyle: IconStyle(),
                    title: Languages.getTranslation('appearance', languageCode),
                    subtitle: Languages.getTranslation('makeItYours', languageCode),
                  ),
                  SettingsItem(
                    onTap: () {},
                    icons: Icons.fingerprint,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.red,
                    ),
                    title: Languages.getTranslation('privacy', languageCode),
                    subtitle: Languages.getTranslation('improvePrivacy', languageCode),
                  ),
                  SettingsItem(
                    onTap: () {},
                    icons: Icons.dark_mode_rounded,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.red,
                    ),
                    title: Languages.getTranslation('emergencyMode', languageCode),
                    subtitle: Languages.getTranslation('automatic', languageCode),
                    trailing: Switch.adaptive(
                      value: false,
                      onChanged: (value) async {
                        await launchUrl(Uri.parse("tel:999"));
                      },
                    ),
                  ),
                ],
              ),
              SettingsGroup(
                items: [
                  SettingsItem(
                    onTap: () {},
                    icons: Icons.info_rounded,
                    iconStyle: IconStyle(
                      backgroundColor: Colors.purple,
                    ),
                    title: Languages.getTranslation('about', languageCode),
                    subtitle: Languages.getTranslation('learnMore', languageCode),
                  ),
                ],
              ),
              SettingsGroup(
                settingsGroupTitle: Languages.getTranslation('account', languageCode),
                items: [
                  SettingsItem(
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.clear();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    icons: Icons.exit_to_app_rounded,
                    title: Languages.getTranslation('signOut', languageCode),
                  ),
                  SettingsItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    icons: CupertinoIcons.repeat,
                    title: Languages.getTranslation('currencyConverter', languageCode),
                  ),
                  SettingsItem(
                    onTap: () {},
                    icons: CupertinoIcons.delete_solid,
                    title: Languages.getTranslation('deleteAccount', languageCode),
                    titleStyle: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
