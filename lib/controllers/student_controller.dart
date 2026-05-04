import 'dart:async';

import 'package:get/get.dart';
import 'package:qr_attendance/data/database/app_database.dart';
import 'package:qr_attendance/data/database/daos/student_dao.dart';

class StudentController extends GetxController{
  var studentsCount = 0.obs;
  final StudentDao studentDao = StudentDao(AppDatabase());
  late StreamSubscription _sub;

  @override
  void onInit() {
    getStudentCount();
    super.onInit();
  }

 void getStudentCount(){
    _sub = studentDao.watchStudentCount().listen(
          (count) {
        studentsCount.value = count;
      },
    );
  }

  @override
  void onClose() {
    _sub.cancel();
    super.onClose();
  }
}