import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// app_export not required in this file

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isNew = true;
  Map<String, dynamic>? _note;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _isNew = args['isNew'] as bool? ?? true;
      if (!_isNew && args['note'] != null) {
        _note = Map<String, dynamic>.from(args['note'] as Map<String, dynamic>);
        _titleController.text = _note?['title'] as String? ?? '';
        _contentController.text = _note?['content'] as String? ?? '';
      }
      if (_isNew && args['template'] != null) {
        final template = args['template'] as String?;
        if (template != null) {
          _titleController.text = template;
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      // don't save empty notes
      Navigator.of(context).pop(null);
      return;
    }

    final now = DateTime.now();

    if (_isNew) {
      final newNote = {
        'id': now.millisecondsSinceEpoch,
        'title': title.isNotEmpty ? title : 'Untitled',
        'content': content,
        'tags': <String>[],
        'isFavorite': false,
        'isArchived': false,
        'createdAt': now,
        'modifiedAt': now,
      };
      Navigator.of(context).pop(newNote);
    } else {
      final updated = Map<String, dynamic>.from(_note ?? {});
      updated['title'] = title.isNotEmpty ? title : 'Untitled';
      updated['content'] = content;
      updated['modifiedAt'] = now;
      Navigator.of(context).pop(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _isNew ? 'New Note' : 'Edit Note',
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveNote,
            child: Text(
              'Save',
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            children: [
              // Title field
              TextField(
                controller: _titleController,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                  hintStyle: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),

              // a little breathing room and a subtle divider between title and body
              SizedBox(height: 2.h),
              Divider(color: colorScheme.outline, height: 1),
              SizedBox(height: 1.h),

              // Body - make the hint and cursor start at the top of the expanded field
              Expanded(
                child: TextField(
                  controller: _contentController,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Write your note here...',
                    border: InputBorder.none,
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    // ensure the hint appears at the top of the field
                    contentPadding: EdgeInsets.only(top: 12.0),
                  ),
                  textAlignVertical: TextAlignVertical.top,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
