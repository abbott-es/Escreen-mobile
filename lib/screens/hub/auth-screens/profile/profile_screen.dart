import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/buttons/app_button.dart';
import 'package:flutter_application_1/core/services/auth/auth_controller.dart';
import 'package:flutter_application_1/core/services/auth/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final auth = AuthProvider.of(context) as AuthController;

    final displayName = 'John Doe';
    final email = 'john.doe@example.com';
    final roleText = switch (auth.role) {
      null => '—',
      _ => auth.role.toString().split('.').last,
    };

    Future<void> _onLogout() async {
      try {
        await auth.logout();
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Logout failed $e')));
      }
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _HeaderCard(
                name: displayName,
                role: roleText,
                scheme: scheme,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: _InfoCard(
                email: email,
                phone: '+63 912 345 6789', // TODO: auth.user?.phone
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: _SettingsCard(
                onOpenSettings: () {
                  /* TODO */
                },
                onOpenPrivacy: () {
                  /* TODO */
                },
                onOpenSupport: () {
                  /* TODO */
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: AppButton(
                label: 'Logout',
                variant: AppButtonVariant.filled,
                fullWidth: true,
                backgroundColor: scheme.error,
                foregroundColor: scheme.onError,
                icon: const Icon(Icons.logout),
                onPressedAsync: _onLogout,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.name,
    required this.role,
    required this.scheme,
  });

  final String name;
  final String role;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: scheme.primaryContainer,
            child: Icon(
              Icons.person,
              size: 42,
              color: scheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            role,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.email, required this.phone});

  final String email;
  final String phone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(12),
      ),
      child: Column(
        children: [
          _ProfileTile(
            icon: Icons.email_outlined,
            title: 'Email',
            subtitle: email,
          ),
          Divider(height: 1, color: scheme.outlineVariant),
          _ProfileTile(
            icon: Icons.phone_outlined,
            title: 'Phone',
            subtitle: phone,
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.onOpenSettings,
    required this.onOpenPrivacy,
    required this.onOpenSupport,
  });

  final VoidCallback onOpenSettings;
  final VoidCallback onOpenPrivacy;
  final VoidCallback onOpenSupport;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(12),
      ),
      child: Column(
        children: [
          _ProfileTile(
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: onOpenSettings,
          ),
          Divider(height: 1, color: scheme.outlineVariant),
          _ProfileTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy',
            onTap: onOpenPrivacy,
          ),
          Divider(height: 1, color: scheme.outlineVariant),
          _ProfileTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Help & Support',
            onTap: onOpenSupport,
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: scheme.primary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
