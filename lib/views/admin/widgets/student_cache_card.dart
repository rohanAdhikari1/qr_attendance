import 'package:flutter/material.dart';
import 'package:qr_attendance/theme/app_theme.dart';
import 'package:qr_attendance/views/admin/widgets/animated_card.dart';

class StudentCacheCard extends StatelessWidget {
  const StudentCacheCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
        icon: Icons.people_rounded,
        title: 'Student Data',
        iconColor: AppColors.accent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [],
        )
    );
  }
}
