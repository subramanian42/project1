import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/settings_item.dart';
import '../widgets/text_custom.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const TextCustom(text: 'Settings', fontSize: 19, fontWeight: FontWeight.w500,color: Colors.white,),
        elevation: 0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white)
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          children: [
            const SizedBox(height: 3.0),
            SettingsItem(
                text: 'Followers/Following',
                icon: Icons.person_add_alt,
                onPressed: (){}
            ),
            const SizedBox(height: 5.0),
            SettingsItem(
                text: 'Notificacions',
                icon: Icons.notifications_none_rounded,
                onPressed: (){}
            ),
            const SizedBox(height: 5.0),
            SettingsItem(
                text: 'Privacy',
                icon: Icons.lock_outline_rounded,
               onPressed: () => {}
            ),
            const SizedBox(height: 5.0),
            SettingsItem(
                text: 'Security',
                icon: Icons.security_outlined,
                onPressed: () => {}
            ),
            const SizedBox(height: 5.0),
            SettingsItem(
                text: 'Account',
                icon: Icons.account_circle_outlined,
                onPressed: () => {}
            ),
            const SizedBox(height: 5.0),
            SettingsItem(
                text: 'Help',
                icon: Icons.help_outline_rounded,
                onPressed: (){}
            ),
            const SizedBox(height: 5.0),
            SettingsItem(
                text: 'About',
                icon: Icons.info_outline_rounded,
                onPressed: (){}
            ),
            const SizedBox(height: 5.0),
            SettingsItem(
                text: 'Themes',
                icon: Icons.palette_outlined,
                onPressed: () => {}
            ),

            const SizedBox(height: 20.0),
            Row(
              children: const [
                Icon(Icons.copyright_outlined),
                SizedBox(width: 5.0),
                TextCustom(text: 'APP DEVELOPER', fontSize: 17, fontWeight: FontWeight.w500,color: Colors.white,),
              ],
            ),
            const SizedBox(height: 30.0),
            const TextCustom(text: 'SESSION', fontSize: 17, fontWeight: FontWeight.w500,color: Colors.white,),

            const SizedBox(height: 10.0),
            SettingsItem(
                text: 'Log Out',
                icon: Icons.logout_rounded,
                colorText: Colors.white,
                onPressed: () {}
            ),
          ],
        ),
      ),
    );
  }
}





