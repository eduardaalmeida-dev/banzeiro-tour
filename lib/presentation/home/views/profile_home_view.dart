import 'package:flutter/material.dart';

import '../../../core/services/api_service.dart';

class ProfileHomeView extends StatelessWidget {
  const ProfileHomeView({super.key, required this.user});

  final RegisteredUser user;

  @override
  Widget build(BuildContext context) {
    final hasPendingVerification =
        user.profileType.isProvider && user.verified == false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Banzeiro Tour'),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Olá, ${user.name}!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Perfil: ${user.profileType.label}',
              key: const Key('home-profile'),
            ),
            if (hasPendingVerification) ...[
              const SizedBox(height: 24),
              const Card(
                color: Color(0xFFFFF8E1),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.pending_outlined, color: Color(0xFFF57F17)),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Homologação pendente. Você já pode acessar sua área de prestador.',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
