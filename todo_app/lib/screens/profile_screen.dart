import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Профиль',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Статистика
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Статистика',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // Круговой индикатор прогресса
                  Container(
                    width: 120,
                    height: 120,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Фон круга
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 8,
                            ),
                          ),
                        ),
                        // Прогресс
                        Container(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            value: taskProvider.completionPercentage,
                            strokeWidth: 8,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ),
                        // Текст процента
                        Text(
                          '${(taskProvider.completionPercentage * 100).toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('Всего', taskProvider.totalTasks.toString(), Icons.format_list_bulleted, Colors.blue),
                      _buildStatItem('Активные', taskProvider.activeTasksCount.toString(), Icons.pending_actions, Colors.orange),
                      _buildStatItem('Выполнено', taskProvider.completedTasksCount.toString(), Icons.check_circle, Colors.green),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 16),
          
          // Быстрые действия
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Быстрые действия',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildActionButton(
                    context,
                    'Очистить выполненные задачи',
                    Icons.delete_sweep,
                    Colors.red,
                    () => _showClearCompletedDialog(context, taskProvider),
                  ),
                  SizedBox(height: 8),
                  _buildActionButton(
                    context,
                    'Задачи на сегодня',
                    Icons.today,
                    Colors.blue,
                    () => _showTodaysTasks(context, taskProvider),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 16),
          
          // Управление категориями
          Card(
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
                    children: [
                      Text(
                        'Управление категориями',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.category, color: Colors.blue, size: 20),
                    ],
                  ),
                  SizedBox(height: 12),
                  
                  if (taskProvider.customCategories.isEmpty) ...[
                    Center(
                      child: Column(
                        children: [
                          Icon(Icons.category, size: 48, color: Colors.grey[300]),
                          SizedBox(height: 8),
                          Text(
                            'Нет категорий',
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    ...taskProvider.customCategories.map((category) => Card(
                      margin: EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: _getCategoryColor(category).withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _getCategoryColor(category),
                              width: 2,
                            ),
                          ),
                        ),
                        title: Text(
                          category,
                          style: TextStyle(fontSize: 14),
                        ),
                        trailing: taskProvider.customCategories.length > 1 
                            ? IconButton(
                                icon: Icon(Icons.delete, color: Colors.red, size: 20),
                                onPressed: () => _showDeleteCategoryDialog(context, taskProvider, category),
                              )
                            : SizedBox(width: 40),
                      ),
                    )).toList(),
                  ],
                  
                  SizedBox(height: 8),
                  _buildActionButton(
                    context,
                    'Добавить новую категорию',
                    Icons.add,
                    Colors.blue,
                    () => _showAddCategoryDialog(context, taskProvider),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, String text, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          text,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
        onTap: onTap,
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Работа':
        return Colors.blue;
      case 'Личное':
        return Colors.green;
      case 'Здоровье':
        return Colors.red;
      case 'Покупки':
        return Colors.orange;
      case 'Образование':
        return Colors.purple;
      case 'Финансы':
        return Colors.teal;
      default:
        final hash = category.hashCode;
        return Color((hash & 0xFFFFFF) | 0xFF000000).withOpacity(1.0);
    }
  }

  void _showClearCompletedDialog(BuildContext context, TaskProvider taskProvider) {
    final completedCount = taskProvider.completedTasks.length;
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Очистить выполненные задачи?'),
        content: Text(
          completedCount > 0 
            ? '$completedCount выполненных задач будут удалены. Это действие нельзя отменить.'
            : 'Нет выполненных задач для очистки.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Отмена'),
          ),
          if (completedCount > 0)
            TextButton(
              onPressed: () {
                taskProvider.clearCompletedTasks();
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Выполненные задачи очищены'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text('Очистить', style: TextStyle(color: Colors.red)),
            ),
        ],
      ),
    );
  }

  void _showTodaysTasks(BuildContext context, TaskProvider taskProvider) {
    final todaysTasks = taskProvider.todaysTasks;
    final completedToday = todaysTasks.where((task) => task.isCompleted).length;
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.today, color: Colors.blue),
            SizedBox(width: 8),
            Text('Задачи на сегодня'),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Выполнено: $completedToday из ${todaysTasks.length}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              SizedBox(height: 12),
              if (todaysTasks.isNotEmpty) ...[
                Container(
                  constraints: BoxConstraints(maxHeight: 300),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: todaysTasks.length,
                    itemBuilder: (context, index) {
                      final task = todaysTasks[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Checkbox(
                            value: task.isCompleted,
                            onChanged: (value) {
                              taskProvider.toggleComplete(task.id);
                              Navigator.pop(ctx);
                              Future.delayed(Duration(milliseconds: 300), () {
                                _showTodaysTasks(context, taskProvider);
                              });
                            },
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 14,
                              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          subtitle: Text(
                            task.category,
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ] else ...[
                Center(
                  child: Column(
                    children: [
                      Icon(Icons.event_available, size: 48, color: Colors.grey[300]),
                      SizedBox(height: 8),
                      Text('На сегодня задач нет', style: TextStyle(color: Colors.grey[500])),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context, TaskProvider taskProvider) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.add, color: Colors.blue),
            SizedBox(width: 8),
            Text('Новая категория'),
          ],
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Введите название категории',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Отмена', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              final categoryName = controller.text.trim();
              if (categoryName.isNotEmpty) {
                if (taskProvider.customCategories.contains(categoryName)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Категория "$categoryName" уже существует'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                } else {
                  await taskProvider.addCategory(categoryName);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Категория "$categoryName" добавлена'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
            child: Text('Добавить', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void _showDeleteCategoryDialog(BuildContext context, TaskProvider taskProvider, String category) {
    final tasksInCategory = taskProvider.tasks.where((task) => task.category == category).length;
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('Удалить категорию?'),
          ],
        ),
        content: Text(
          tasksInCategory > 0
            ? 'В категории "$category" находится $tasksInCategory задач. Они будут перемещены в другую категорию.'
            : 'Категория "$category" будет удалена.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () async {
              await taskProvider.removeCategory(category);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Категория "$category" удалена'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}