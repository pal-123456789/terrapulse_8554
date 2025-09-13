import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CreateRoomModal extends StatefulWidget {
  final Function(Map<String, dynamic> roomConfig)? onCreateRoom;

  const CreateRoomModal({
    super.key,
    this.onCreateRoom,
  });

  @override
  State<CreateRoomModal> createState() => _CreateRoomModalState();
}

class _CreateRoomModalState extends State<CreateRoomModal> {
  final TextEditingController _roomNameController = TextEditingController();
  String _selectedDisaster = 'Earthquake';
  String _selectedDifficulty = 'Medium';
  int _maxPlayers = 4;
  bool _isPrivate = false;
  bool _allowSpectators = true;
  int _estimatedDuration = 30;

  final List<String> _disasterTypes = [
    'Earthquake',
    'Tsunami',
    'Hurricane',
    'Volcanic Eruption',
    'Flood',
    'Drought',
    'Wildfire',
    'Tornado',
  ];

  final List<String> _difficultyLevels = [
    'Easy',
    'Medium',
    'Hard',
    'Expert',
  ];

  @override
  void dispose() {
    _roomNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildModalHeader(context, colorScheme),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 3.h),
                  _buildRoomNameSection(context, colorScheme),
                  SizedBox(height: 3.h),
                  _buildDisasterSelectionSection(context, colorScheme),
                  SizedBox(height: 3.h),
                  _buildGameSettingsSection(context, colorScheme),
                  SizedBox(height: 3.h),
                  _buildPrivacySettingsSection(context, colorScheme),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          _buildCreateButton(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildModalHeader(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Create New Room',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: CustomIconWidget(
              iconName: 'close',
              size: 24,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomNameSection(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Room Name',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
        ),
        SizedBox(height: 1.h),
        TextField(
          controller: _roomNameController,
          decoration: const InputDecoration(
            hintText: 'Enter room name...',
            prefixIcon: Icon(Icons.meeting_room),
          ),
          textCapitalization: TextCapitalization.words,
        ),
      ],
    );
  }

  Widget _buildDisasterSelectionSection(
      BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Disaster Type',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _disasterTypes.map((disaster) {
            final isSelected = disaster == _selectedDisaster;
            return FilterChip(
              label: Text(disaster),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedDisaster = disaster;
                });
              },
              backgroundColor: colorScheme.surfaceContainerHighest,
              selectedColor: colorScheme.primary.withValues(alpha: 0.2),
              checkmarkColor: colorScheme.primary,
              labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGameSettingsSection(
      BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Game Settings',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
        ),
        SizedBox(height: 2.h),
        _buildDifficultySelector(context, colorScheme),
        SizedBox(height: 2.h),
        _buildMaxPlayersSelector(context, colorScheme),
        SizedBox(height: 2.h),
        _buildDurationSelector(context, colorScheme),
      ],
    );
  }

  Widget _buildDifficultySelector(
      BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Difficulty Level',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
        ),
        SizedBox(height: 1.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            border:
                Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedDifficulty,
              isExpanded: true,
              items: _difficultyLevels.map((difficulty) {
                return DropdownMenuItem<String>(
                  value: difficulty,
                  child: Row(
                    children: [
                      Container(
                        width: 3.w,
                        height: 3.w,
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(difficulty),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Text(difficulty),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedDifficulty = value;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMaxPlayersSelector(
      BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Maximum Players: $_maxPlayers',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
        ),
        SizedBox(height: 1.h),
        Slider(
          value: _maxPlayers.toDouble(),
          min: 2,
          max: 6,
          divisions: 4,
          label: '$_maxPlayers players',
          onChanged: (value) {
            setState(() {
              _maxPlayers = value.round();
            });
          },
        ),
      ],
    );
  }

  Widget _buildDurationSelector(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estimated Duration: ${_estimatedDuration}min',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
        ),
        SizedBox(height: 1.h),
        Slider(
          value: _estimatedDuration.toDouble(),
          min: 15,
          max: 120,
          divisions: 7,
          label: '${_estimatedDuration}min',
          onChanged: (value) {
            setState(() {
              _estimatedDuration = value.round();
            });
          },
        ),
      ],
    );
  }

  Widget _buildPrivacySettingsSection(
      BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Privacy & Access',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
        ),
        SizedBox(height: 2.h),
        SwitchListTile(
          title: Text(
            'Private Room',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          subtitle: Text(
            'Only invited players can join',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          value: _isPrivate,
          onChanged: (value) {
            setState(() {
              _isPrivate = value;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          title: Text(
            'Allow Spectators',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          subtitle: Text(
            'Others can watch the simulation',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          value: _allowSpectators,
          onChanged: (value) {
            setState(() {
              _allowSpectators = value;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildCreateButton(BuildContext context, ColorScheme colorScheme) {
    final bool canCreate = _roomNameController.text.trim().isNotEmpty;

    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: canCreate ? _handleCreateRoom : null,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Create Room',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleCreateRoom() {
    final roomConfig = {
      'roomName': _roomNameController.text.trim(),
      'disasterType': _selectedDisaster,
      'difficulty': _selectedDifficulty,
      'maxPlayers': _maxPlayers,
      'isPrivate': _isPrivate,
      'allowSpectators': _allowSpectators,
      'estimatedDuration': _estimatedDuration,
      'createdAt': DateTime.now(),
    };

    widget.onCreateRoom?.call(roomConfig);
    Navigator.of(context).pop();
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppTheme.successLight;
      case 'medium':
        return AppTheme.warningLight;
      case 'hard':
        return AppTheme.errorLight;
      case 'expert':
        return const Color(0xFF8B5CF6);
      default:
        return AppTheme.warningLight;
    }
  }
}
