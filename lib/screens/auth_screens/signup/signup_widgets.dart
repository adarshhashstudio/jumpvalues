import 'package:flutter/material.dart';
import 'package:jumpvalues/models/category_dropdown_response.dart';

class CategoryDialog extends StatefulWidget {
  CategoryDialog({
    required this.categories,
    required this.onConfirm,
    required this.selectedCat,
  });
  final List<Category> categories;
  final Function(List<Category>) onConfirm;
  final List<Category> selectedCat;

  @override
  _CategoryDialogState createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  List<Category> _filteredCategories = [];
  late List<Category> _selectedCategories;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeSelectedCategories();
    _filteredCategories = widget.categories;
  }

  void _initializeSelectedCategories() {
    _selectedCategories = List.from(widget.selectedCat);
    for (var selectedCategory in _selectedCategories) {
      _toggleSelection(selectedCategory.id ?? -1, initialize: true);
    }
  }

  void _filterCategories(String query) {
    setState(() {
      _filteredCategories = widget.categories
          .where((category) =>
              (category.name ?? '').toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _toggleSelection(int id, {bool initialize = false}) {
    setState(() {
      final category = widget.categories.firstWhere((cat) => cat.id == id);
      if (!initialize) {
        category.isSelected = !category.isSelected;
      }
      if (category.isSelected) {
        if (!_selectedCategories.contains(category)) {
          _selectedCategories.add(category);
        }
      } else {
        _selectedCategories.remove(category);
      }
    });
  }

  void _selectAll() {
    setState(() {
      final isSelectingAll =
          _selectedCategories.length != widget.categories.length;
      _selectedCategories.clear();
      for (var category in widget.categories) {
        category.isSelected = isSelectingAll;
        if (isSelectingAll) {
          _selectedCategories.add(category);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Column(
          children: [
            Text('Select Categories'),
            SizedBox(
              height: 6,
            ),
            Divider(
              thickness: 0.2,
            )
          ],
        ),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          color: Colors.black, // Adjusted to avoid an undefined variable
        ),
        backgroundColor: Colors.white,
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search Categories',
                ),
                onChanged: _filterCategories,
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: _selectAll,
                  icon: const Icon(Icons.select_all),
                  label: const Text(
                    'Select All',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 0.5,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = _filteredCategories[index];
                    return ListTile(
                      title: Text(category.name ?? ''),
                      trailing: Icon(
                        category.isSelected
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: category.isSelected ? Colors.blue : null,
                      ),
                      onTap: () {
                        _toggleSelection(category.id ?? -1);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text(
              'Exit',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: const Text(
              'Confirm',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () {
              widget.onConfirm(_selectedCategories);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
}
