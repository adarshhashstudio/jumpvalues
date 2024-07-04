import 'package:hive/hive.dart';

part 'goals_data_hive.g.dart';

@HiveType(typeId: 0)
class GoalsData {
  GoalsData({
    required this.goalId,
    required this.goalName,
    this.goalSelected = false,
  });
  @HiveField(0)
  final int goalId;

  @HiveField(1)
  final String goalName;

  @HiveField(2)
  bool goalSelected;
}
