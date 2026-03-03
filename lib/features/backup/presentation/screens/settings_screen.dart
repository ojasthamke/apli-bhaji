import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../backup_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Backup'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Data Management',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          _SettingsCard(
            title: 'Export Database Backup',
            subtitle: 'Save all your data as a JSON file',
            icon: Icons.backup_outlined,
            color: Colors.emerald,
            onTap: () async {
              try {
                await BackupService.exportBackup();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Backup exported successfully!')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Export failed: $e')),
                );
              }
            },
          ),

          const SizedBox(height: 12),

          _SettingsCard(
            title: 'Import Database Backup',
            subtitle: 'Restore your data from a JSON file',
            icon: Icons.restore_outlined,
            color: Colors.orange,
            onTap: () async {
              final result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['json'],
              );

              if (result != null && result.files.single.path != null) {
                final file = File(result.files.single.path!);
                final success = await BackupService.importBackup(file);

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data restored successfully! Please restart the app.')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Import failed! Invalid file.')),
                  );
                }
              }
            },
          ),

          const SizedBox(height: 24),
          const Text(
            'About App',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          const Card(
            child: ListTile(
              title: Text('APLI BHAJI'),
              subtitle: Text('Version 1.0.0\n100% Offline Billing App'),
              isThreeLine: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SettingsCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }
}
