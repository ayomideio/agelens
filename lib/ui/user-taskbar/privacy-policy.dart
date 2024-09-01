import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy', style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Issy Tour!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade700,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'At Issy Tour, we are committed to protecting your privacy. This policy outlines how we collect, use, and safeguard your personal information.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            _buildSectionTitle('Information Collection and Use'),
            Text(
              'We collect information to provide a better experience for all our users. This includes information you provide directly to us when booking tours or making payments, as well as data collected through your usage of the app.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            _buildSectionTitle('How We Use Your Information'),
            Text(
              '• To process and confirm your bookings.\n'
              '• To facilitate payments and generate tickets.\n'
              '• To provide currency conversion services.\n'
              '• To improve the functionality and user experience of the app.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            _buildSectionTitle('Data Security'),
            Text(
              'We implement appropriate security measures to protect your data from unauthorized access, alteration, or destruction.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            _buildSectionTitle('Third-Party Services'),
            Text(
              'We may share your information with third-party services for processing payments, booking management, and other necessary operations. These services are obligated to maintain the confidentiality of your data.',
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
              'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new policy on this page.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'If you have any questions about this Privacy Policy, please contact us at support@Issytour.com.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Back', style: TextStyle(fontSize: 18)),
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
        color: Colors.teal.shade600,
      ),
    );
  }
}
