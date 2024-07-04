// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goals_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$GoalsStore on _GoalsStore, Store {
  late final _$goalsListAtom =
      Atom(name: '_GoalsStore.goalsList', context: context);

  @override
  ObservableList<GoalsData> get goalsList {
    _$goalsListAtom.reportRead();
    return super.goalsList;
  }

  @override
  set goalsList(ObservableList<GoalsData> value) {
    _$goalsListAtom.reportWrite(value, super.goalsList, () {
      super.goalsList = value;
    });
  }

  late final _$_GoalsStoreActionController =
      ActionController(name: '_GoalsStore', context: context);

  @override
  void loadGoals() {
    final _$actionInfo = _$_GoalsStoreActionController.startAction(
        name: '_GoalsStore.loadGoals');
    try {
      return super.loadGoals();
    } finally {
      _$_GoalsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addGoal(GoalsData goal) {
    final _$actionInfo =
        _$_GoalsStoreActionController.startAction(name: '_GoalsStore.addGoal');
    try {
      return super.addGoal(goal);
    } finally {
      _$_GoalsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeGoal(GoalsData goal) {
    final _$actionInfo = _$_GoalsStoreActionController.startAction(
        name: '_GoalsStore.removeGoal');
    try {
      return super.removeGoal(goal);
    } finally {
      _$_GoalsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleGoal(GoalsData goal) {
    final _$actionInfo = _$_GoalsStoreActionController.startAction(
        name: '_GoalsStore.toggleGoal');
    try {
      return super.toggleGoal(goal);
    } finally {
      _$_GoalsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
goalsList: ${goalsList}
    ''';
  }
}
