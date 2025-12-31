import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../data/models/project_model.dart';

class ProjectFilter extends StatelessWidget {
  final ProjectCategory selectedCategory;
  final Function(ProjectCategory) onCategorySelected;

  const ProjectFilter({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _FilterChip(
            label: AppStrings.projectsFilterAll,
            isSelected: selectedCategory == ProjectCategory.all,
            onTap: () => onCategorySelected(ProjectCategory.all),
          ),
          const SizedBox(width: 12),
          _FilterChip(
            label: AppStrings.projectsFilterCRM,
            isSelected: selectedCategory == ProjectCategory.crm,
            onTap: () => onCategorySelected(ProjectCategory.crm),
          ),
          const SizedBox(width: 12),
          _FilterChip(
            label: AppStrings.projectsFilterPOS,
            isSelected: selectedCategory == ProjectCategory.pos,
            onTap: () => onCategorySelected(ProjectCategory.pos),
          ),
          const SizedBox(width: 12),
          _FilterChip(
            label: AppStrings.projectsFilterAsset,
            isSelected: selectedCategory == ProjectCategory.assetManagement,
            onTap: () => onCategorySelected(ProjectCategory.assetManagement),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? theme.colorScheme.primary
                : _isHovered
                    ? theme.colorScheme.primary.withValues(alpha: 0.1)
                    : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isSelected || _isHovered
                  ? theme.colorScheme.primary
                  : theme.dividerColor,
              width: 1,
            ),
          ),
          child: Text(
            widget.label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: widget.isSelected
                  ? Colors.white
                  : _isHovered
                      ? theme.colorScheme.primary
                      : theme.textTheme.labelLarge?.color,
              fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
