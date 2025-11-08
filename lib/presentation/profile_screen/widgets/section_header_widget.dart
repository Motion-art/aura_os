import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/app_export.dart';
import '../../../main.dart';

class SettingsSectionWidget extends StatefulWidget {
  final Map<String, dynamic> settings;
  final Function(String, dynamic) onSettingChanged;

  const SettingsSectionWidget({
    super.key,
    required this.settings,
    required this.onSettingChanged,
  });

  @override
  State<SettingsSectionWidget> createState() => _SettingsSectionWidgetState();
}

class _SettingsSectionWidgetState extends State<SettingsSectionWidget> {
  Future<void> _saveThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode);
  }

  void _toggleDarkMode(bool value) {
    widget.onSettingChanged("darkModeEnabled", value);
    themeModeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
    _saveThemeMode(value ? 'dark' : 'light');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                _buildSettingItem(
                  icon: 'notifications',
                  title: 'Notifications',
                  subtitle: 'Manage notification preferences',
                  trailing: Switch(
                    value: widget.settings["notificationsEnabled"] as bool,
                    onChanged: (value) {
                      widget.onSettingChanged("notificationsEnabled", value);
                    },
                  ),
                ),
                _buildDivider(),
                _buildSettingItem(
                  icon: 'dark_mode',
                  title: 'Dark Mode',
                  subtitle: 'Toggle appearance mode',
                  trailing: ValueListenableBuilder<ThemeMode>(
                    valueListenable: themeModeNotifier,
                    builder: (context, mode, _) {
                      return Switch(
                        value: mode == ThemeMode.dark,
                        onChanged: _toggleDarkMode,
                      );
                    },
                  ),
                ),
                _buildDivider(),
                _buildSettingItem(
                  icon: 'sync',
                  title: 'Auto Sync',
                  subtitle: 'Automatically sync data',
                  trailing: Switch(
                    value: widget.settings["autoSyncEnabled"] as bool,
                    onChanged: (value) {
                      widget.onSettingChanged("autoSyncEnabled", value);
                    },
                  ),
                ),
                _buildDivider(),
                _buildSettingItem(
                  icon: 'integration_instructions',
                  title: 'Integrations',
                  subtitle: 'Manage third-party app connections',
                  trailing: CustomIconWidget(
                    iconName: 'chevron_right',
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                  onTap: () => _showIntegrationsDialog(context),
                ),
                _buildDivider(),
                _buildSettingItem(
                  icon: 'privacy_tip',
                  title: 'Privacy & Security',
                  subtitle: 'Manage privacy settings',
                  trailing: CustomIconWidget(
                    iconName: 'chevron_right',
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                  onTap: () => _showPrivacyDialog(context),
                ),
                _buildDivider(),
                _buildSettingItem(
                  icon: 'download',
                  title: 'Export Data',
                  subtitle: 'Download your information',
                  trailing: CustomIconWidget(
                    iconName: 'chevron_right',
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                  onTap: () => _showExportDialog(context),
                ),
                _buildDivider(),
                _buildSettingItem(
                  icon: 'help',
                  title: 'Help & Support',
                  subtitle: 'Get help and contact support',
                  trailing: CustomIconWidget(
                    iconName: 'chevron_right',
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                  onTap: () => _showHelpDialog(context),
                ),
                _buildDivider(),
                _buildSettingItem(
                  icon: 'logout',
                  title: 'Sign Out',
                  subtitle: 'Sign out of your account',
                  trailing: CustomIconWidget(
                    iconName: 'chevron_right',
                    color: AppTheme.errorRed,
                    size: 5.w,
                  ),
                  onTap: () => _showSignOutDialog(context),
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required String icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
          color: isDestructive
              ? AppTheme.errorRed.withValues(alpha: 0.1)
              : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: icon,
            color: isDestructive
                ? AppTheme.errorRed
                : Theme.of(context).colorScheme.primary,
            size: 5.w,
          ),
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: isDestructive
              ? AppTheme.errorRed
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: trailing,
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
      indent: 18.w,
    );
  }

  void _showIntegrationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Third-Party Integrations'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIntegrationItem('Google Calendar', true),
              _buildIntegrationItem('Trello', false),
              _buildIntegrationItem('Slack', false),
              _buildIntegrationItem('Notion', true),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildIntegrationItem(String name, bool isConnected) {
    return ListTile(
      title: Text(name),
      trailing: isConnected
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.accentGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Connected',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppTheme.accentGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : TextButton(onPressed: () {}, child: Text('Connect')),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Privacy & Security'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your privacy is important to us. Manage your privacy settings and data sharing preferences.',
              ),
              SizedBox(height: 2.h),
              Text('• Profile visibility settings'),
              Text('• Data sharing preferences'),
              Text('• Account security options'),
              Text('• Delete account option'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Export Your Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Download a copy of your data including:'),
              SizedBox(height: 1.h),
              Text('• Profile information'),
              Text('• Tasks and notes'),
              Text('• Energy tracking data'),
              Text('• Activity history'),
              SizedBox(height: 2.h),
              Text('Export format: JSON'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _exportUserData();
              },
              child: Text('Export'),
            ),
          ],
        );
      },
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Help & Support'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Need help? We\'re here for you!'),
              SizedBox(height: 2.h),
              Text('• FAQ and tutorials'),
              Text('• Contact support team'),
              Text('• Report bugs or issues'),
              Text('• Feature requests'),
              SizedBox(height: 2.h),
              Text('Email: support@auraos.app'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sign Out'),
          content: Text('Are you sure you want to sign out of your account?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _signOut(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorRed,
              ),
              child: Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  void _exportUserData() {
    // Implementation for exporting user data
    // This would typically generate a JSON file with user data
  }

  void _signOut(BuildContext context) {
    // Clear user session here if needed
    // Navigate to login screen
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }
}
