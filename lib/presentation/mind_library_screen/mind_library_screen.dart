import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/note_card_widget.dart';
import './widgets/note_context_menu_widget.dart';
import './widgets/note_list_item_widget.dart';
import './widgets/search_bar_widget.dart';

class MindLibraryScreen extends StatefulWidget {
  const MindLibraryScreen({super.key});

  @override
  State<MindLibraryScreen> createState() => _MindLibraryScreenState();
}

class _MindLibraryScreenState extends State<MindLibraryScreen>
    with TickerProviderStateMixin {
  bool _isGridView = false; // start in list view
  String _searchQuery = '';
  List<String> _selectedTags = [];
  String _sortBy = 'date_desc';
  bool _showFavoritesOnly = false;
  bool _showArchivedNotes = false;
  // unused: bool _isLoading = false;
  bool _isSyncing = false;

  final List<String> _recentQueries = [
    'meeting notes',
    'project ideas',
    'daily journal',
    'learning',
  ];

  // Mock notes data
  final List<Map<String, dynamic>> _allNotes = [
    {
      'id': 1,
      'title': 'Product Strategy Meeting Notes',
      'content':
          'Discussed Q4 roadmap priorities, user feedback analysis, and competitive landscape. Key decisions: Focus on mobile experience improvements and AI integration features.',
      'tags': ['work', 'meeting', 'strategy'],
      'isFavorite': true,
      'isArchived': false,
      'createdAt': DateTime.now().subtract(const Duration(hours: 2)),
      'modifiedAt': DateTime.now().subtract(const Duration(hours: 1)),
    },
    {
      'id': 2,
      'title': 'Daily Reflection - October 20',
      'content':
          'Today was productive. Completed the user research analysis and started working on the new feature specifications. Feeling energized about the upcoming sprint.',
      'tags': ['personal', 'journal', 'reflection'],
      'isFavorite': false,
      'isArchived': false,
      'createdAt': DateTime.now().subtract(const Duration(days: 1)),
      'modifiedAt': DateTime.now().subtract(const Duration(hours: 3)),
    },
    {
      'id': 3,
      'title': 'Flutter Development Best Practices',
      'content':
          'Key principles for scalable Flutter apps: proper state management, widget composition over inheritance, consistent naming conventions, and comprehensive testing strategies.',
      'tags': ['learning', 'flutter', 'development'],
      'isFavorite': true,
      'isArchived': false,
      'createdAt': DateTime.now().subtract(const Duration(days: 3)),
      'modifiedAt': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'id': 4,
      'title': 'Weekend Project Ideas',
      'content':
          'Build a habit tracking app, create a personal finance dashboard, experiment with AR features, contribute to open source projects.',
      'tags': ['ideas', 'projects', 'personal'],
      'isFavorite': false,
      'isArchived': false,
      'createdAt': DateTime.now().subtract(const Duration(days: 5)),
      'modifiedAt': DateTime.now().subtract(const Duration(days: 4)),
    },
    {
      'id': 5,
      'title': 'Book Notes: Atomic Habits',
      'content':
          'The compound effect of small habits. 1% better every day leads to 37x improvement over a year. Focus on systems, not goals. Make it obvious, attractive, easy, and satisfying.',
      'tags': ['learning', 'books', 'habits'],
      'isFavorite': true,
      'isArchived': false,
      'createdAt': DateTime.now().subtract(const Duration(days: 7)),
      'modifiedAt': DateTime.now().subtract(const Duration(days: 6)),
    },
    {
      'id': 6,
      'title': 'Old Meeting Notes - Archive',
      'content':
          'Legacy meeting notes from previous quarter. Keeping for reference but no longer actively needed.',
      'tags': ['work', 'meeting', 'archive'],
      'isFavorite': false,
      'isArchived': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 30)),
      'modifiedAt': DateTime.now().subtract(const Duration(days: 25)),
    },
  ];

  List<Map<String, dynamic>> get _filteredNotes {
    var notes = List<Map<String, dynamic>>.from(_allNotes);

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      notes = notes.where((note) {
        final title = (note['title'] as String).toLowerCase();
        final content = (note['content'] as String).toLowerCase();
        final tags = (note['tags'] as List).join(' ').toLowerCase();
        final query = _searchQuery.toLowerCase();

        return title.contains(query) ||
            content.contains(query) ||
            tags.contains(query);
      }).toList();
    }

    // Filter by tags
    if (_selectedTags.isNotEmpty) {
      notes = notes.where((note) {
        final noteTags = (note['tags'] as List).cast<String>();
        return _selectedTags.any((tag) => noteTags.contains(tag));
      }).toList();
    }

    // Filter by favorites
    if (_showFavoritesOnly) {
      notes = notes.where((note) => note['isFavorite'] == true).toList();
    }

    // Filter by archived status
    if (!_showArchivedNotes) {
      notes = notes.where((note) => note['isArchived'] != true).toList();
    }

    // Sort notes
    switch (_sortBy) {
      case 'date_asc':
        notes.sort(
          (a, b) => (a['createdAt'] as DateTime).compareTo(
            b['createdAt'] as DateTime,
          ),
        );
        break;
      case 'title_asc':
        notes.sort(
          (a, b) => (a['title'] as String).compareTo(b['title'] as String),
        );
        break;
      case 'title_desc':
        notes.sort(
          (a, b) => (b['title'] as String).compareTo(a['title'] as String),
        );
        break;
      case 'modified':
        notes.sort(
          (a, b) => (b['modifiedAt'] as DateTime).compareTo(
            a['modifiedAt'] as DateTime,
          ),
        );
        break;
      case 'date_desc':
      default:
        notes.sort(
          (a, b) => (b['createdAt'] as DateTime).compareTo(
            a['createdAt'] as DateTime,
          ),
        );
        break;
    }

    return notes;
  }

  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onRecentQueryTap(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => FilterBottomSheetWidget(
          selectedTags: _selectedTags,
          selectedSortBy: _sortBy,
          showFavoritesOnly: _showFavoritesOnly,
          showArchivedNotes: _showArchivedNotes,
          onTagsChanged: (tags) => setState(() => _selectedTags = tags),
          onSortChanged: (sort) => setState(() => _sortBy = sort),
          onFavoritesChanged: (favorites) =>
              setState(() => _showFavoritesOnly = favorites),
          onArchivedChanged: (archived) =>
              setState(() => _showArchivedNotes = archived),
          onReset: () {
            setState(() {
              _selectedTags.clear();
              _sortBy = 'date_desc';
              _showFavoritesOnly = false;
              _showArchivedNotes = false;
            });
          },
          onApply: () {},
        ),
      ),
    );
  }

  void _showNoteContextMenu(Map<String, dynamic> note) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.all(4.w),
        child: NoteContextMenuWidget(
          note: note,
          onEdit: () => _editNote(note),
          onShare: () => _shareNote(note),
          onDuplicate: () => _duplicateNote(note),
          onArchive: () => _toggleArchiveNote(note),
          onDelete: () => _deleteNote(note),
          onFavorite: () => _toggleFavoriteNote(note),
        ),
      ),
    );
  }

  Future<void> _createNote({String? template}) async {
    // Navigate to note editor and await created note
    final result = await Navigator.pushNamed(
      context,
      '/note-editor',
      arguments: {'isNew': true, 'template': template},
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _allNotes.insert(0, result);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note created'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _editNote(Map<String, dynamic> note) async {
    final result = await Navigator.pushNamed(
      context,
      '/note-editor',
      arguments: {'isNew': false, 'note': note},
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        final idx = _allNotes.indexWhere((n) => n['id'] == result['id']);
        if (idx != -1) {
          _allNotes[idx] = result;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note saved'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _shareNote(Map<String, dynamic> note) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing "${note['title']}"...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _duplicateNote(Map<String, dynamic> note) {
    setState(() {
      final newNote = Map<String, dynamic>.from(note);
      newNote['id'] = _allNotes.length + 1;
      newNote['title'] = '${note['title']} (Copy)';
      newNote['createdAt'] = DateTime.now();
      newNote['modifiedAt'] = DateTime.now();
      _allNotes.insert(0, newNote);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note duplicated successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleArchiveNote(Map<String, dynamic> note) {
    setState(() {
      final index = _allNotes.indexWhere((n) => n['id'] == note['id']);
      if (index != -1) {
        _allNotes[index]['isArchived'] =
            !(_allNotes[index]['isArchived'] ?? false);
        _allNotes[index]['modifiedAt'] = DateTime.now();
      }
    });

    final isArchived = note['isArchived'] ?? false;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isArchived ? 'Note unarchived' : 'Note archived'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteNote(Map<String, dynamic> note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: Text(
          'Are you sure you want to delete "${note['title']}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _allNotes.removeWhere((n) => n['id'] == note['id']);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Note deleted'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _toggleFavoriteNote(Map<String, dynamic> note) {
    setState(() {
      final index = _allNotes.indexWhere((n) => n['id'] == note['id']);
      if (index != -1) {
        _allNotes[index]['isFavorite'] =
            !(_allNotes[index]['isFavorite'] ?? false);
        _allNotes[index]['modifiedAt'] = DateTime.now();
      }
    });
  }

  Future<void> _refreshNotes() async {
    setState(() {
      _isSyncing = true;
    });

    // Simulate network sync
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSyncing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notes synced successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final filteredNotes = _filteredNotes;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Mind Library',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          // Sync indicator
          if (_isSyncing)
            Padding(
              padding: EdgeInsets.only(right: 2.w),
              child: SizedBox(
                width: 5.w,
                height: 5.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryBlue,
                  ),
                ),
              ),
            ),

          // View toggle button
          IconButton(
            onPressed: _toggleView,
            icon: CustomIconWidget(
              iconName: _isGridView ? 'view_list' : 'grid_view',
              color: colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            tooltip: _isGridView ? 'List View' : 'Grid View',
          ),

          SizedBox(width: 2.w),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: SearchBarWidget(
              hintText: 'Search notes and tags...',
              onChanged: _onSearchChanged,
              onFilterTap: _showFilterBottomSheet,
              recentQueries: _recentQueries,
              onRecentQueryTap: _onRecentQueryTap,
            ),
          ),

          // Active filters indicator
          if (_selectedTags.isNotEmpty ||
              _showFavoritesOnly ||
              _showArchivedNotes)
            Container(
              height: 5.h,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  if (_showFavoritesOnly)
                    _buildFilterChip('Favorites', () {
                      setState(() => _showFavoritesOnly = false);
                    }),
                  if (_showArchivedNotes)
                    _buildFilterChip('Archived', () {
                      setState(() => _showArchivedNotes = false);
                    }),
                  ..._selectedTags
                      .map(
                        (tag) => _buildFilterChip('#$tag', () {
                          setState(() => _selectedTags.remove(tag));
                        }),
                      )
                      .toList(),
                ],
              ),
            ),

          // Notes content
          Expanded(
            child: filteredNotes.isEmpty
                ? EmptyStateWidget(
                    title: _searchQuery.isNotEmpty || _selectedTags.isNotEmpty
                        ? 'No Notes Found'
                        : 'Start Your Knowledge Journey',
                    subtitle:
                        _searchQuery.isNotEmpty || _selectedTags.isNotEmpty
                        ? 'Try adjusting your search or filters to find what you\'re looking for.'
                        : 'Create your first note and begin capturing ideas, thoughts, and insights.',
                    buttonText: 'Create First Note',
                    onButtonPressed: () => _createNote(),
                    onTemplateTap: (template) =>
                        _createNote(template: template),
                  )
                : RefreshIndicator(
                    onRefresh: _refreshNotes,
                    color: AppTheme.primaryBlue,
                    child: _isGridView
                        ? _buildGridView(filteredNotes)
                        : _buildListView(filteredNotes),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createNote(),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: AppTheme.surfaceWhite,
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.surfaceWhite,
          size: 6.w,
        ),
      ),
      bottomNavigationBar: CustomBottomBar.productivity(
        currentIndex: 2, // Mind Library tab
        context: context,
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(right: 2.w),
      child: Chip(
        label: Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppTheme.primaryBlue,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.1),
        deleteIcon: CustomIconWidget(
          iconName: 'close',
          color: AppTheme.primaryBlue,
          size: 4.w,
        ),
        onDeleted: onRemove,
        side: BorderSide(
          color: AppTheme.primaryBlue.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
    );
  }

  Widget _buildGridView(List<Map<String, dynamic>> notes) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 2.h,
        crossAxisSpacing: 3.w,
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return NoteCardWidget(
            note: note,
            onTap: () => _editNote(note),
            onLongPress: () => _showNoteContextMenu(note),
            onFavorite: () => _toggleFavoriteNote(note),
            onArchive: () => _toggleArchiveNote(note),
          );
        },
      ),
    );
  }

  Widget _buildListView(List<Map<String, dynamic>> notes) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return NoteListItemWidget(
          note: note,
          onTap: () => _editNote(note),
          onLongPress: () => _showNoteContextMenu(note),
          onFavorite: () => _toggleFavoriteNote(note),
          onArchive: () => _toggleArchiveNote(note),
        );
      },
    );
  }
}
