import 'package:flutter/material.dart';
import '../utils/constants.dart';

class AnimatedSearchHeader extends StatefulWidget {
  final String title;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback? onFilterPressed;
  final bool showFilter;

  const AnimatedSearchHeader({
    Key? key,
    required this.title,
    required this.onSearchChanged,
    this.onFilterPressed,
    this.showFilter = false,
  }) : super(key: key);

  @override
  State<AnimatedSearchHeader> createState() => _AnimatedSearchHeaderState();
}

class _AnimatedSearchHeaderState extends State<AnimatedSearchHeader>
    with SingleTickerProviderStateMixin {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _searchFieldAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _searchFieldAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (_isSearching) {
        _animationController.forward();
      } else {
        _animationController.reverse();
        _searchController.clear();
        widget.onSearchChanged('');
      }
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      widget.onSearchChanged('');
      _isSearching = false;
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Calculate available width for search field
    // Account for: padding (32), search icon (48), right icon (48)
    final maxSearchWidth = screenWidth - 160;

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.primary,
      ),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Stack(
            children: [
              // Title - fades out and stays on left
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              // Animated content
              Row(
                children: [
                  // Search icon - animates from right to left
                  if (_isSearching) ...[
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: _toggleSearch,
                    ),
                  ],
                  // Spacing for title when not searching
                  if (!_isSearching) const Spacer(),
                  // Search field - expands when searching
                  if (_isSearching) ...[
                    SizedBox(
                      width: maxSearchWidth * _searchFieldAnimation.value,
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Cari...',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onChanged: widget.onSearchChanged,
                      ),
                    ),
                  ],
                  // Spacer to push icons to right
                  if (_isSearching) const Spacer(),
                  // Right side icons when searching
                  if (_isSearching && _searchController.text.isNotEmpty) ...[
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: _clearSearch,
                    ),
                  ] else if (_isSearching && widget.showFilter && widget.onFilterPressed != null) ...[
                    IconButton(
                      icon: const Icon(Icons.filter_list, color: Colors.white),
                      onPressed: widget.onFilterPressed,
                    ),
                  ],
                  // Search icon in initial state
                  if (!_isSearching) ...[
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: _toggleSearch,
                    ),
                  ],
                  // Filter icon in initial state
                  if (!_isSearching && widget.showFilter && widget.onFilterPressed != null) ...[
                    IconButton(
                      icon: const Icon(Icons.filter_list, color: Colors.white),
                      onPressed: widget.onFilterPressed,
                    ),
                  ],
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
