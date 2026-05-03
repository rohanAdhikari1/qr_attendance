import 'package:flutter/material.dart';
import '../models/attendance_model.dart';
import 'base_widgets.dart';

/// Reusable attendance record card widget
class AttendanceRecordCard extends StatelessWidget {
  final AttendanceModel record;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onRetry;

  const AttendanceRecordCard({
    Key? key,
    required this.record,
    this.onTap,
    this.onDelete,
    this.onRetry,
  }) : super(key: key);

  Color _getSyncStatusColor() {
    switch (record.syncStatus) {
      case SyncStatus.synced:
        return Colors.green;
      case SyncStatus.pending:
        return Colors.orange;
      case SyncStatus.failed:
        return Colors.red;
    }
  }

  IconData _getSyncStatusIcon() {
    switch (record.syncStatus) {
      case SyncStatus.synced:
        return Icons.check_circle;
      case SyncStatus.pending:
        return Icons.schedule;
      case SyncStatus.failed:
        return Icons.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with student info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.studentName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      record.studentId,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getSyncStatusColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getSyncStatusIcon(),
                      size: 16,
                      color: _getSyncStatusColor(),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      record.syncStatus.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: _getSyncStatusColor(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Details
          Row(
            children: [
              Expanded(
                child: _DetailItem(
                  label: 'Class',
                  value: record.className,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _DetailItem(
                  label: 'Grade',
                  value: record.grade,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _DetailItem(
            label: 'Time',
            value: _formatTime(record.timestamp),
          ),
          if (record.retryCount > 0) ...[
            const SizedBox(height: 8),
            Text(
              'Retry Count: ${record.retryCount}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
          // Action buttons
          if (onDelete != null || onRetry != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (record.syncStatus == SyncStatus.failed && onRetry != null)
                  TextButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                    ),
                  ),
                if (onDelete != null)
                  TextButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

/// Reusable detail item widget for displaying label-value pairs
class _DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const _DetailItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Reusable attendance statistics card
class AttendanceStatsCard extends StatelessWidget {
  final int total;
  final int synced;
  final int pending;

  const AttendanceStatsCard({
    Key? key,
    required this.total,
    required this.synced,
    required this.pending,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              label: 'Total',
              value: total.toString(),
              color: Colors.blue,
            ),
          ),
          Container(
            width: 1,
            height: 60,
            color: Colors.grey[300],
          ),
          Expanded(
            child: _StatItem(
              label: 'Synced',
              value: synced.toString(),
              color: Colors.green,
            ),
          ),
          Container(
            width: 1,
            height: 60,
            color: Colors.grey[300],
          ),
          Expanded(
            child: _StatItem(
              label: 'Pending',
              value: pending.toString(),
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual stat item within stats card
class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

/// Reusable filter chip widget
class FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? selectedColor;

  const FilterChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.selectedColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? (selectedColor ?? Colors.blue) : Colors.grey[300],
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
