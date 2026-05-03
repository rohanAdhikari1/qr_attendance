import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/attendance_controller.dart';
import '../models/attendance_model.dart';
import '../widgets/widgets.dart';

/// Example: Attendance List View with GetX and Reusable Widgets
class AttendanceListExample extends StatelessWidget {
  final controller = Get.find<AttendanceController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Records'),
      ),
      body: Column(
        children: [
          // Filter chips row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                FilterChip(
                  label: 'All',
                  isSelected: controller.filterStatus.value == null,
                  onTap: () => controller.setFilter(null),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: 'Synced',
                  isSelected: controller.filterStatus.value == SyncStatus.synced,
                  onTap: () => controller.setFilter(SyncStatus.synced),
                  selectedColor: Colors.green,
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: 'Pending',
                  isSelected: controller.filterStatus.value == SyncStatus.pending,
                  onTap: () => controller.setFilter(SyncStatus.pending),
                  selectedColor: Colors.orange,
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: 'Failed',
                  isSelected: controller.filterStatus.value == SyncStatus.failed,
                  onTap: () => controller.setFilter(SyncStatus.failed),
                  selectedColor: Colors.red,
                ),
              ],
            ),
          ),
          // Stats card
          Obx(
            () => AttendanceStatsCard(
              total: controller.todayTotal.value,
              synced: controller.todaySynced.value,
              pending: controller.todayPending.value,
            ),
          ),
          // Records list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return LoadingWidget(message: 'Loading records...');
              }

              if (controller.records.isEmpty) {
                return EmptyState(
                  icon: Icons.inbox,
                  title: 'No Records',
                  subtitle: 'No attendance records found',
                  onRetry: () => controller.refresh(),
                );
              }

              return ListView.builder(
                itemCount: controller.records.length,
                itemBuilder: (context, index) {
                  final record = controller.records[index];
                  return AttendanceRecordCard(
                    record: record,
                    onTap: () => _showRecordDetails(context, record),
                    onDelete: () => _deleteRecord(record),
                    onRetry: controller.filterStatus.value == SyncStatus.failed
                        ? () => _retrySync(record)
                        : null,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showRecordDetails(BuildContext context, AttendanceModel record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(record.studentName),
        content: AppContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _InfoRow('Student ID', record.studentId),
              _InfoRow('Class', record.className),
              _InfoRow('Grade', record.grade),
              _InfoRow('Time', _formatDateTime(record.timestamp)),
              _InfoRow('Status', record.syncStatus.name.toUpperCase()),
              _InfoRow('Retry Count', record.retryCount.toString()),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _deleteRecord(AttendanceModel record) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Record?'),
        content: Text(
          'Are you sure you want to delete the record for ${record.studentName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              // Implement delete logic
              Get.snackbar('Success', 'Record deleted');
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _retrySync(AttendanceModel record) {
    Get.snackbar('Retry', 'Syncing ${record.studentName}...');
    // Implement retry logic
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

/// Example: Attendance Form with GetX and Widgets
class AttendanceFormExample extends StatefulWidget {
  @override
  _AttendanceFormExampleState createState() => _AttendanceFormExampleState();
}

class _AttendanceFormExampleState extends State<AttendanceFormExample> {
  final _formKey = GlobalKey<FormState>();
  final _studentIdController = TextEditingController();
  final _isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mark Attendance')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AppContainer(
              backgroundColor: Colors.blue.withOpacity(0.1),
              borderRadius: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Entry',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _studentIdController,
                    hintText: 'Scan or enter student ID',
                    labelText: 'Student ID',
                    prefixIcon: Icons.qr_code_2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Obx(
              () => AppButton(
                label: 'Submit Attendance',
                onPressed: _submitAttendance,
                isLoading: _isLoading.value,
                width: double.infinity,
                icon: Icons.check_circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitAttendance() async {
    if (!_formKey.currentState!.validate()) return;

    _isLoading.value = true;
    try {
      // Implement submission logic
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        'Success',
        'Attendance marked for ${_studentIdController.text}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      _studentIdController.clear();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to mark attendance',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    super.dispose();
  }
}

/// Helper widget for displaying info rows
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
