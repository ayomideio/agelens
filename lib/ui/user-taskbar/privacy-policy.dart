import 'package:flutter/material.dart';
import 'package:readmitpredictor/ui/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Privacy Policy', style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold)),
      //   backgroundColor: Colors.black,
      // ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40,),
            Text(
              'Welcome to AgeLens!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'At AgeLens, we are committed to protecting your privacy. This policy outlines how we collect, use, and safeguard your personal information.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            _buildSectionTitle('Information Collection and Use'),
            Text(
              'We collect information to provide a better experience for all our users. This includes the data you provide directly through our facial analysis feature, as well as information collected through your usage of the app.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            _buildSectionTitle('How We Use Your Information'),
            Text(
              '• To analyze and predict your age based on facial appearance.\n'
              '• To improve the accuracy of our age prediction models.\n'
              '• To provide personalized insights and age comparison features.\n'
              '• To enhance the functionality and user experience of AgeLens.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            _buildSectionTitle('Data Security'),
            Text(
              'We implement robust security measures to protect your data from unauthorized access, alteration, or destruction.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            _buildSectionTitle('Third-Party Services'),
            Text(
              'We may share your information with third-party services for data analysis and to improve our app’s performance. These services are obligated to maintain the confidentiality of your data.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            _buildSectionTitle('Your Rights'),
            Text(
              'You have the right to access, update, or delete your personal information at any time. Please contact us if you have any concerns.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            _buildSectionTitle('Changes to This Policy'),
            Text(
              'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the updated policy on this page.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'If you have any questions about this Privacy Policy, please contact us at support@AgeLens.com.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () async{
               SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                },
                child: Text('Log Out', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}
