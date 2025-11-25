import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_item.dart';
import 'add_task_screen.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  bool _showCategoryFilter = false;

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final categories = taskProvider.getCategories();
    
    // Получаем отсортированные и отфильтрованные задачи
    final allTasks = taskProvider.tasks;
    final activeTasks = allTasks.where((task) => !task.isCompleted).toList();
    final completedTasks = allTasks.where((task) => task.isCompleted).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Список задач',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {
              setState(() {
                _showCategoryFilter = !_showCategoryFilter;
              });
            },
            tooltip: 'Фильтр по категориям',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'sort_date') {
                taskProvider.setSort('date');
              } else if (value == 'sort_name') {
                taskProvider.setSort('name');
              } else if (value == 'sort_category') {
                taskProvider.setSort('category');
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'sort_date',
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, size: 20),
                    SizedBox(width: 8),
                    Text('По дате'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'sort_name',
                child: Row(
                  children: [
                    Icon(Icons.sort_by_alpha, size: 20),
                    SizedBox(width: 8),
                    Text('По названию'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'sort_category',
                child: Row(
                  children: [
                    Icon(Icons.category, size: 20),
                    SizedBox(width: 8),
                    Text('По категории'),
                  ],
                ),
              ),
            ],
            icon: Icon(Icons.more_vert, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Блок фильтрации по категориям
          if (_showCategoryFilter) ...[
            Card(
              margin: EdgeInsets.all(16),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Фильтр по категориям',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, size: 20),
                          onPressed: () {
                            setState(() {
                              _showCategoryFilter = false;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: categories.map((category) {
                        final isSelected = taskProvider.currentFilter == category;
                        return FilterChip(
                          label: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            taskProvider.setFilter(category);
                          },
                          selectedColor: Colors.blue,
                          backgroundColor: Colors.grey[200],
                          checkmarkColor: Colors.white,
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 8),
                    if (taskProvider.currentFilter != 'Все')
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                taskProvider.setFilter('Все');
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: BorderSide(color: Colors.red),
                              ),
                              child: Text('Сбросить фильтр'),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
          
          // Информация о текущем фильтре и сортировке
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (taskProvider.currentFilter != 'Все') ...[
                  Row(
                    children: [
                      Icon(Icons.filter_alt, size: 16, color: Colors.blue),
                      SizedBox(width: 4),
                      Text(
                        'Фильтр: ${taskProvider.currentFilter}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          taskProvider.setFilter('Все');
                        },
                        child: Text(
                          '× Сбросить',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                ],
                Row(
                  children: [
                    Icon(Icons.sort, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    Text(
                      _getSortText(taskProvider.currentSort),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(height: 16),
          
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                // Активные задачи
                if (activeTasks.isNotEmpty) ...[
                  _buildSectionHeader(
                    'АКТИВНЫЕ ЗАДАЧИ',
                    '${activeTasks.length} задач',
                  ),
                  SizedBox(height: 8),
                  ...activeTasks.map((task) => TaskItem(task: task)).toList(),
                  SizedBox(height: 24),
                ],
                // Выполненные задачи
                if (completedTasks.isNotEmpty) ...[
                  _buildSectionHeader(
                    'ВЫПОЛНЕННЫЕ ЗАДАЧИ',
                    '${completedTasks.length} задач',
                  ),
                  SizedBox(height: 8),
                  ...completedTasks.map((task) => TaskItem(task: task)).toList(),
                ],
                // Пустой список
                if (activeTasks.isEmpty && completedTasks.isEmpty) ...[
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.task_alt, size: 64, color: Colors.grey[300]),
                        SizedBox(height: 16),
                        Text(
                          'Нет задач',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Нажмите + чтобы добавить задачу',
                          style: TextStyle(
                            color: Colors.grey[400],
                          ),
                        ),
                        SizedBox(height: 16),
                        if (taskProvider.currentFilter != 'Все')
                          ElevatedButton(
                            onPressed: () {
                              taskProvider.setFilter('Все');
                            },
                            child: Text('Показать все задачи'),
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 16),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTaskScreen()),
            );
          },
          child: Icon(Icons.add, size: 24),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: CircleBorder(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSectionHeader(String title, String count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            count,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  String _getSortText(String sortType) {
    switch (sortType) {
      case 'date':
        return 'Сортировка: по дате';
      case 'name':
        return 'Сортировка: по названию';
      case 'category':
        return 'Сортировка: по категории';
      default:
        return 'Сортировка: по дате';
    }
  }
}