import 'package:crisp/crisp.dart';
import 'package:flutter/material.dart';

class SupportChat extends StatefulWidget {
  final String email, fullname;
  const SupportChat({super.key,required this.email,required this.fullname});

  @override
  State<SupportChat> createState() => _SupportChatState();
}

class _SupportChatState extends State<SupportChat> {
  CrispMain crispMain = CrispMain(
    websiteId: 'WEBSITE_ID',
    locale: 'pt-br',
  );

  @override
  void initState() {
    super.initState();

    crispMain = CrispMain(
      websiteId: "d9fca5d4-16b4-4c6c-a9e8-71be2c0cf8a9",
    );

    crispMain.register(
      user: CrispUser(
        email: widget.email,
        nickname: widget.fullname,
        phone: '07045802442',
      ),
    );

    crispMain.setSessionData({
      "order_id": '07045802442',
      "app_version": "0.1.1",
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
     
      child: CrispView(
          crispMain: crispMain,
          clearCache: true,
        ),
    );
  }
}
