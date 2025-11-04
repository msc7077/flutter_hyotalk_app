import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_notifier.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idTxtEditController = TextEditingController();
    final pwdTxtEditController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: idTxtEditController,
              decoration: const InputDecoration(labelText: 'ID'),
            ),
            TextField(
              controller: pwdTxtEditController,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final id = idTxtEditController.text.trim();
                final pwd = pwdTxtEditController.text.trim();
                if (id.isNotEmpty && pwd.isNotEmpty) {
                  await ref.read(authProvider.notifier).login(id, pwd);
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
