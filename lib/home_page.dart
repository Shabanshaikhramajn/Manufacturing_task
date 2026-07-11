import 'package:flutter/material.dart';
import 'app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const entries = [
    ('Machine Manufacturers', AppRoutes.machineManufacturers,),
    ('Locations', AppRoutes.locations),
    ('Machines', AppRoutes.machines, ),
    ('Customers', AppRoutes.customers,),
    ('Components', AppRoutes.components, ),
    ('Component Operations', AppRoutes.componentOperations, ),
    ('Master View', AppRoutes.masterView),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manufacturing'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Text(
              'Dashboard',
              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.3,
              ),
              itemCount: entries.length,
              itemBuilder: (context, i) {
                final (label, route) = entries[i];
                return InkWell(
                  onTap: () => Navigator.pushNamed(context, route),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.colorScheme.primary.withOpacity(0.1)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          label,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

          ],
        ),
      ),
    );
  }
}
