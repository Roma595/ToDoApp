import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _currentMonth = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  final List<String> _weekdays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
  final List<String> _months = [
    'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
    'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
  ];

  List<DateTime> _getDaysInMonth(DateTime date) {
    final first = DateTime(date.year, date.month, 1);
    final last = DateTime(date.year, date.month + 1, 0);
    final days = <DateTime>[];
    
    // Добавляем дни предыдущего месяца для заполнения первой недели
    final firstWeekday = first.weekday;
    for (int i = 1; i < firstWeekday; i++) {
      days.add(first.subtract(Duration(days: firstWeekday - i)));
    }
    
    // Добавляем дни текущего месяца
    for (int i = 0; i < last.day; i++) {
      days.add(DateTime(date.year, date.month, i + 1));
    }
    
    // Добавляем дни следующего месяца для заполнения последней недели
    final totalCells = days.length > 35 ? 42 : 35;
    while (days.length < totalCells) {
      days.add(days.last.add(Duration(days: 1)));
    }
    
    return days;
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final monthDays = _getDaysInMonth(_currentMonth);
    final today = DateTime.now();
    
    final selectedDateTasks = taskProvider.getTasksForDate(_selectedDate);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Календарь',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Заголовок месяца
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, size: 20),
                  onPressed: _previousMonth,
                ),
                Text(
                  '${_months[_currentMonth.month - 1]} ${_currentMonth.year}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios, size: 20),
                  onPressed: _nextMonth,
                ),
              ],
            ),
          ),
          
          // Дни недели
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _weekdays.map((day) => Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    day,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              )).toList(),
            ),
          ),
          
          // Календарь
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1.2,
                ),
                itemCount: monthDays.length,
                itemBuilder: (context, index) {
                  final day = monthDays[index];
                  final isCurrentMonth = day.month == _currentMonth.month;
                  final isToday = _isSameDay(day, today);
                  final isSelected = _isSameDay(day, _selectedDate);
                  final dayTasks = taskProvider.getTasksForDate(day);
                  final hasTasks = dayTasks.isNotEmpty && isCurrentMonth;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = day;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : 
                               isToday ? Colors.blue.withOpacity(0.1) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: isToday && !isSelected ? Border.all(color: Colors.blue) : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            day.day.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isCurrentMonth 
                                ? (isSelected ? Colors.white : Colors.black)
                                : Colors.grey[400],
                            ),
                          ),
                          if (hasTasks) ...[
                            SizedBox(height: 2),
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.white : Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Задачи на выбранный день
          Expanded(
            flex: 3,
            child: Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Задачи на ${_formatDate(_selectedDate)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          selectedDateTasks.length.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  if (selectedDateTasks.isNotEmpty) ...[
                    Expanded(
                      child: ListView(
                        children: [
                          ...selectedDateTasks.map((task) => Card(
                            margin: EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: Checkbox(
                                value: task.isCompleted,
                                onChanged: (value) {
                                  taskProvider.toggleComplete(task.id);
                                },
                              ),
                              title: Text(
                                task.title,
                                style: TextStyle(
                                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              subtitle: Text(
                                task.category,
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                            ),
                          )).toList(),
                        ],
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.task_alt, size: 48, color: Colors.grey[300]),
                            SizedBox(height: 8),
                            Text(
                              'Нет задач на этот день',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}