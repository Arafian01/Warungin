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
  late Animation<double> _widthAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _widthAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
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
    // Account for: padding (32), search icon (48), filter icon (48 if shown), clear icon (48 if shown)
    final iconsWidth = 48 + (widget.showFilter ? 48 : 0) + (_searchController.text.isNotEmpty ? 48 : 0) + 32;
    final maxSearchWidth = screenWidth - iconsWidth;

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.primary,
      ),
      child: Row(
        children: [
          if (!_isSearching) ...[
            Expanded(
              child: Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          if (_isSearching) ...[
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return SizedBox(
                  width: maxSearchWidth * _widthAnimation.value,
                  child: SlideTransition(
                    position: _slideAnimation,
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
                );
              },
            ),
            if (_searchController.text.isNotEmpty)
              SlideTransition(
                position: _slideAnimation,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: _clearSearch,
                ),
              ),
          ],
          IconButton(
            icon: Icon(
              _isSearching ? Icons.search : Icons.search,
              color: Colors.white,
            ),
            onPressed: _toggleSearch,
          ),
          if (widget.showFilter && widget.onFilterPressed != null)
            IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.white),
              onPressed: widget.onFilterPressed,
            ),
        ],
      ),
    );
  }
}
