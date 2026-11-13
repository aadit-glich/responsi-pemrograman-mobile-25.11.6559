import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../widgets/empty_state.dart';


class ApiUsersScreen extends StatefulWidget {
  const ApiUsersScreen({super.key});

  @override
  State<ApiUsersScreen> createState() => _ApiUsersScreenState();
}

class _ApiUsersScreenState extends State<ApiUsersScreen> {
  final _api = ApiService();
  late Future<List<ApiUser>> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.fetchUsers();
  }

  void _retry() => setState(() => _future = _api.fetchUsers());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Pengguna (API)')),
      body: FutureBuilder<List<ApiUser>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off, size: 64),
                  const SizedBox(height: 12),
                  Text('${snapshot.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  FilledButton(onPressed: _retry, child: const Text('Coba lagi')),
                ],
              ),
            );
          }
          final users = snapshot.data ?? const <ApiUser>[];
          if (users.isEmpty) {
            return const EmptyState(
              message: 'Tidak ada data.',
              icon: Icons.people_outline,
            );
          }
          return ListView.separated(
            itemCount: users.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final u = users[i];
              return ListTile(
                leading: CircleAvatar(child: Text('${u.id}')),
                title: Text(u.name),
                subtitle: Text('${u.email}\n${u.company}'),
                isThreeLine: true,
              );
            },
          );
        },
      ),
    );
  }
}
