import 'package:flutter/material.dart';
import 'package:jumpvalues/models/signup_categories.dart';
import 'package:jumpvalues/screens/utils/common.dart';

class CategoryDialog extends StatefulWidget {
  CategoryDialog(
      {required this.categories,
      required this.onConfirm,
      required this.selectedCat});
  final List<SignupCategory> categories;
  final Function(List<SignupCategory>) onConfirm;
  final List<SignupCategory> selectedCat;

  @override
  _CategoryDialogState createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  List<SignupCategory> _filteredCategories = [];
  final List<SignupCategory> _selectedCategories = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (var element in widget.selectedCat) {
      _toggleSelection(element.id);
    }
    _filteredCategories = widget.categories;
  }

  void _filterCategories(String query) {
    setState(() {
      _filteredCategories = widget.categories
          .where((category) =>
              category.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _toggleSelection(int id) {
    setState(() {
      final category = widget.categories.firstWhere((cat) => cat.id == id);
      category.isSelected = !category.isSelected;
      if (category.isSelected) {
        _selectedCategories.add(category);
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
        titleTextStyle: TextStyle(
          fontSize: 20,
          color: textColor,
        ),
        backgroundColor: Colors.white,
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              textFormField(
                controller: _searchController,
                isLabel: false,
                hintText: 'Search Categories',
                label: '',
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
                      title: Text(category.name),
                      trailing: Icon(
                        category.isSelected
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: category.isSelected ? Colors.blue : null,
                      ),
                      onTap: () {
                        _toggleSelection(category.id);
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
