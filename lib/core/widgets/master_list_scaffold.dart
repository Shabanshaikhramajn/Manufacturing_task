import 'package:flutter/material.dart';

class MasterListScaffold extends StatefulWidget {
  final String title;
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final VoidCallback onAdd;
  final VoidCallback onRefresh;
  final bool isLoading;
  final String? errorMessage;

  const MasterListScaffold({
    super.key,
    required this.title,
    required this.columns,
    required this.rows,
    required this.onAdd,
    required this.onRefresh,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  State<MasterListScaffold> createState() => MasterListScaffoldState();
}

class MasterListScaffoldState extends State<MasterListScaffold> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        elevation: 2,
      ),
      body: widget.isLoading
          ? const Center(child: CircularProgressIndicator())
          : widget.errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${widget.errorMessage}',
                    style: theme.textTheme.titleMedium,
                  ),
                  TextButton(
                    onPressed: widget.onRefresh,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: widget.rows.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 16),
                                const Text(
                                  'No records. Tap + to add.',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          )
                        : Card(
                            clipBehavior: Clip.antiAlias,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: theme.colorScheme.outlineVariant,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Scrollbar(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SingleChildScrollView(
                                  child: DataTable(
                                    headingRowColor: WidgetStateProperty.all(
                                      theme.colorScheme.primaryContainer
                                          .withOpacity(0.2),
                                    ),
                                    headingTextStyle: theme.textTheme.titleSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                    dataRowMinHeight: 48,
                                    dataRowMaxHeight: 64,
                                    columns: widget.columns,
                                    rows: widget.rows,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: widget.onAdd,
        icon: const Icon(Icons.add),
        label: const Text('Add New'),
      ),
    );
  }
}
