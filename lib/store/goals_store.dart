import 'package:hive/hive.dart';
import 'package:jumpvalues/store/goals_data_hive.dart';
import 'package:mobx/mobx.dart';

part 'goals_store.g.dart';

class GoalsStore = _GoalsStore with _$GoalsStore;

abstract class _GoalsStore with Store {
  _GoalsStore(this.goalsBox);
  Box<GoalsData> goalsBox;

  @observable
  ObservableList<GoalsData> goalsList = ObservableList<GoalsData>();

  @action
  void loadGoals() {
    goalsList = ObservableList.of(goalsBox.values);
  }

  @action
  void addGoal(GoalsData goal) {
    goalsBox.put(goal.goalId, goal);
    goalsList.add(goal);
  }

  @action
  void removeGoal(GoalsData goal) {
    goalsBox.delete(goal.goalId);
    goalsList.removeWhere((g) => g.goalId == goal.goalId);
  }

  @action
  void toggleGoal(GoalsData goal) {
    final index = goalsList.indexWhere((g) => g.goalId == goal.goalId);
    if (index != -1) {
      goalsList[index].goalSelected = !goalsList[index].goalSelected;
      goalsBox.put(goal.goalId, goalsList[index]);
    }
  }
}
