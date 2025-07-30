import 'package:flutter/material.dart';

import '../../domain/entities/categories.dart';
import 'selectable_chip.dart';

typedef OnCategoriesSelected = void Function(
    List<Categories> selectedCategories);

class CategoriesList extends StatefulWidget {
  final OnCategoriesSelected onCategoriesSelected;
  final List<Categories> initialSelectedCategories;

  const CategoriesList({
    super.key,
    required this.onCategoriesSelected,
    this.initialSelectedCategories = const [],
  });

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  late List<bool> _categorySelections;
  final List<Categories> _allCategories = Categories.values;

  @override
  void initState() {
    super.initState();
    _categorySelections = List.generate(_allCategories.length, (index) {
      return widget.initialSelectedCategories.contains(_allCategories[index]);
    });
  }

  @override
  void didUpdateWidget(CategoriesList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSelectedCategories !=
        oldWidget.initialSelectedCategories) {
      setState(() {
        _categorySelections = List.generate(_allCategories.length, (index) {
          return widget.initialSelectedCategories
              .contains(_allCategories[index]);
        });
      });
    }
  }

  void _handleSelectionChange(int index, bool isSelected) {
    setState(() {
      _categorySelections[index] = isSelected;
    });

    List<Categories> currentlySelected = [];
    for (int i = 0; i < _allCategories.length; i++) {
      if (_categorySelections[i]) {
        currentlySelected.add(_allCategories[i]);
      }
    }
    widget.onCategoriesSelected(currentlySelected);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.0,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _allCategories.length,
            (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: SelectableChip(
                  label: _allCategories[index].name,
                  isSelected: _categorySelections[index],
                  onSelected: (isSelected) {
                    _handleSelectionChange(index, isSelected);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
