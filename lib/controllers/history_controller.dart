import 'package:attendance_tracker/controllers/base_controller.dart';
import 'package:attendance_tracker/models/student_details_model.dart';

class HistoryController extends BaseController {
  final List<StudentDetailsModel> studentDetails = [
    StudentDetailsModel(
      studentName: 'Robert Roy P. Salvo',
      studentId: 2022300157,
      date: '8/20/2024',
      time: '8:40 AM',
    ),
    StudentDetailsModel(
      studentName: 'Ceirik Agustin',
      studentId: 2023402482,
      date: '8/20/2024',
      time: '8:45 AM',
    ),
    StudentDetailsModel(
      studentName: 'Anna Maria Lopez',
      studentId: 2024101987,
      date: '8/21/2024',
      time: '9:00 AM',
    ),
    StudentDetailsModel(
      studentName: 'Juan Carlos Mendoza',
      studentId: 2024501988,
      date: '8/21/2024',
      time: '9:15 AM',
    ),
    StudentDetailsModel(
      studentName: 'Maria Clara Reyes',
      studentId: 2025103456,
      date: '8/22/2024',
      time: '10:00 AM',
    ),
    StudentDetailsModel(
      studentName: 'Carlos Alberto Garcia',
      studentId: 2025307890,
      date: '8/22/2024',
      time: '10:15 AM',
    ),
    StudentDetailsModel(
      studentName: 'Isabella Fernandez',
      studentId: 2025401234,
      date: '8/23/2024',
      time: '11:00 AM',
    ),
    StudentDetailsModel(
      studentName: 'Sebastian Silva',
      studentId: 2025505678,
      date: '8/23/2024',
      time: '11:30 AM',
    ),
  ];
}
