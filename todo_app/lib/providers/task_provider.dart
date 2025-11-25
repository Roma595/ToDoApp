import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  List<String> _customCategories = ['Работа', 'Личное', 'Здоровье', 'Покупки'];
  String _currentFilter = 'Все';
  String _currentSort = 'date';

  List<Task> get tasks => _getFilteredAndSortedTasks();
  String get currentFilter => _currentFilter;
  String get currentSort => _currentSort;
  List<String> get customCategories => _customCategories;

  List<Task> get activeTasks => _tasks.where((task) => !task.isCompleted).toList();
  List<Task> get completedTasks => _tasks.where((task) => task.isCompleted).toList();

  // Статистика
  int get totalTasks => _tasks.length;
  int get completedTasksCount => completedTasks.length;
  int get activeTasksCount => activeTasks.length;
  double get completionPercentage => totalTasks > 0 ? completedTasksCount / totalTasks : 0;

  // Получить задачи на сегодня
  List<Task> get todaysTasks {
    final now = DateTime.now();
    return getTasksForDate(DateTime(now.year, now.month, now.day));
  }

  // Получить задачи по дате
  List<Task> getTasksForDate(DateTime date) {
    return _tasks.where((task) => 
      task.date.year == date.year &&
      task.date.month == date.month &&
      task.date.day == date.day
    ).toList();
  }

  TaskProvider() {
    loadTasks();
    loadCategories();
  }

  Future<void> loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getString('tasks');
      
      if (tasksJson != null) {
        final List<dynamic> tasksList = json.decode(tasksJson);
        _tasks = tasksList.map((item) => Task.fromMap(Map<String, dynamic>.from(item))).toList();
      }
      notifyListeners();
    } catch (e) {
      print('Error loading tasks: $e');
    }
  }

  Future<void> loadCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final categoriesJson = prefs.getString('categories');
      
      if (categoriesJson != null) {
        final List<dynamic> categoriesList = json.decode(categoriesJson);
        _customCategories = categoriesList.map((item) => item.toString()).toList();
      }
      notifyListeners();
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  Future<void> _saveTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = json.encode(_tasks.map((task) => task.toMap()).toList());
      await prefs.setString('tasks', tasksJson);
      notifyListeners();
    } catch (e) {
      print('Error saving tasks: $e');
    }
  }

  Future<void> _saveCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final categoriesJson = json.encode(_customCategories);
      await prefs.setString('categories', categoriesJson);
      notifyListeners();
    } catch (e) {
      print('Error saving categories: $e');
    }
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    await _saveTasks();
  }

  Future<void> updateTask(String id, Task updatedTask) async {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      await _saveTasks();
    }
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
    await _saveTasks();
  }

  Future<void> toggleComplete(String id) async {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        isCompleted: !_tasks[index].isCompleted,
      );
      await _saveTasks();
    }
  }

  Future<void> addCategory(String category) async {
    if (!_customCategories.contains(category) && category.isNotEmpty) {
      _customCategories.add(category);
      await _saveCategories();
    }
  }

  Future<void> removeCategory(String category) async {
    if (_customCategories.contains(category)) {
      _customCategories.remove(category);
      
      // Перемещаем задачи из удаляемой категории в первую доступную
      for (var task in _tasks.where((t) => t.category == category).toList()) {
        final index = _tasks.indexWhere((t) => t.id == task.id);
        if (index != -1) {
          _tasks[index] = task.copyWith(
            category: _customCategories.isNotEmpty ? _customCategories.first : 'Личное'
          );
        }
      }
      
      await _saveCategories();
      await _saveTasks();
    }
  }

  Future<void> clearCompletedTasks() async {
    _tasks.removeWhere((task) => task.isCompleted);
    await _saveTasks();
  }

  void setFilter(String filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  void setSort(String sortType) {
    _currentSort = sortType;
    notifyListeners();
  }

  List<Task> _getFilteredAndSortedTasks() {
    List<Task> filteredTasks = _tasks;

    // Применяем фильтр по категории
    if (_currentFilter != 'Все') {
      filteredTasks = _tasks.where((task) => task.category == _currentFilter).toList();
    }

    // Применяем сортировку
    if (_currentSort == 'date') {
      filteredTasks.sort((a, b) => a.date.compareTo(b.date));
    } else if (_currentSort == 'name') {
      filteredTasks.sort((a, b) => a.title.compareTo(b.title));
    } else if (_currentSort == 'category') {
      filteredTasks.sort((a, b) => a.category.compareTo(b.category));
    }

    return filteredTasks;
  }

  List<String> getCategories() {
    return ['Все', ..._customCategories];
  }

  String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}