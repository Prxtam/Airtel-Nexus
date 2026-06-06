import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/users/providers/user_provider.dart';
import 'package:frontend/features/users/models/user_admin.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(userListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(userListProvider.notifier).fetchUsers(),
          ),
        ],
      ),
      body: usersAsync.when(
        data: (users) => _buildUserTable(context, ref, users),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error loading users: $e')),
      ),
    );
  }

  Widget _buildUserTable(BuildContext context, WidgetRef ref, List<UserAdmin> users) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Email')),
          DataColumn(label: Text('Roles')),
          DataColumn(label: Text('Active')),
          DataColumn(label: Text('Actions')),
        ],
        rows: users.map((u) {
          return DataRow(cells: [
            DataCell(Text(u.fullName ?? '-')),
            DataCell(Text(u.email)),
            DataCell(Text(u.roles.join(', '))),
            DataCell(
              Switch(
                value: u.isActive,
                onChanged: (val) {
                  ref.read(userListProvider.notifier).updateStatus(u.id, val);
                },
              ),
            ),
            DataCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_note),
                    tooltip: 'Edit Roles',
                    onPressed: () => _showEditRolesDialog(context, ref, u),
                  ),
                  IconButton(
                    icon: const Icon(Icons.key),
                    tooltip: 'Reset Password',
                    onPressed: () => _showResetPasswordDialog(context, ref, u),
                  ),
                  IconButton(
                    icon: const Icon(Icons.manage_accounts),
                    tooltip: 'Assign Manager',
                    onPressed: () => _showAssignManagerDialog(context, ref, u, users),
                  ),
                ],
              ),
            ),
          ]);
        }).toList(),
      ),
    );
  }

  void _showEditRolesDialog(BuildContext context, WidgetRef ref, UserAdmin user) {
    final availableRoles = ['account_manager', 'zonal_sales_manager', 'circle_business_head', 'admin'];
    String selectedRole = user.roles.isNotEmpty ? user.roles.first : 'account_manager';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Role: ${user.email}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: availableRoles.map((role) {
                    return RadioListTile<String>(
                      title: Text(role),
                      value: role,
                      groupValue: selectedRole,
                      onChanged: (String? value) {
                        setState(() {
                          if (value != null) selectedRole = value;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await ref.read(userListProvider.notifier).updateRole(user.id, selectedRole);
                      if (context.mounted) Navigator.pop(context);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAssignManagerDialog(BuildContext context, WidgetRef ref, UserAdmin user, List<UserAdmin> allUsers) {
    String? selectedManagerId = user.managerId;
    final potentialManagers = allUsers.where((u) => u.id != user.id).toList();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Assign Manager: ${user.email}'),
              content: DropdownButtonFormField<String?>(
                value: selectedManagerId,
                decoration: const InputDecoration(labelText: 'Manager'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('No Manager')),
                  ...potentialManagers.map((m) {
                    final label = m.fullName != null ? '${m.fullName} (${m.email})' : m.email;
                    return DropdownMenuItem(
                      value: m.id,
                      child: Text(label),
                    );
                  }),
                ],
                onChanged: (val) {
                  setState(() => selectedManagerId = val);
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await ref.read(userListProvider.notifier).updateManager(user.id, selectedManagerId);
                      if (context.mounted) Navigator.pop(context);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showResetPasswordDialog(BuildContext context, WidgetRef ref, UserAdmin user) {
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Reset Password: ${user.email}'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Password cannot be empty';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    await ref.read(userListProvider.notifier).resetPassword(user.id, passwordController.text);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Password reset successfully.'), backgroundColor: Colors.green),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
                    }
                  }
                }
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }
}
