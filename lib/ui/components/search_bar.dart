import 'package:flutter/material.dart';
import 'package:offro_cibo/domain/utils/logger.dart';

class SearchBarWidget extends StatefulWidget {
  final String hint;
  final Function(String) onSubmitted;
  final Function() onClear;

  const SearchBarWidget(
      {super.key, required this.hint, required this.onSubmitted, required this.onClear});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidget();
}

class _SearchBarWidget extends State<SearchBarWidget> {
  static final _classTag = "SearchBarWidget";
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _hint = '';
  late Function(String) _onSubmitted;
  late Function() _onClear;

  @override
  void initState() {
    super.initState();
    _hint = widget.hint;
    _onSubmitted = widget.onSubmitted;
    _onClear = widget.onClear;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
    });

    _onClear();
  }

  @override
  Widget build(BuildContext context) {
    final rightIcon = _searchQuery.isNotEmpty
        ? IconButton(
            icon: Icon(Icons.clear),
            onPressed: _clearSearch,
          )
        : Icon(Icons.search);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 403.0,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SearchBar(
            backgroundColor: WidgetStateProperty.all(Colors.white),
            controller: _searchController,
            hintText: _hint,
            leading: null,
            trailing: [rightIcon],
            onChanged: _onSearchChanged,
            onSubmitted: (query) {
              AppLogger.logger.d('$_classTag: Search submitted -> $query');
              _onSubmitted(query);
            },
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
