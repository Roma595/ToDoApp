package com.example.todoappandroid

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.CalendarView
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.ItemTouchHelper
import java.util.Calendar

class CalendarFragment : Fragment() {

    private lateinit var calendarView: CalendarView
    private lateinit var tasksRecyclerView: RecyclerView
    private lateinit var activeTaskAdapter: TaskAdapter
    private val viewModel: TaskViewModel by activityViewModels()
    private lateinit var tasksLabel: TextView
    private lateinit var monthYearLabel: TextView

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_calendar, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        // Инициализация UI элементов
        calendarView = view.findViewById(R.id.calendarView)
        tasksRecyclerView = view.findViewById(R.id.tasksRecyclerView)
        tasksLabel = view.findViewById(R.id.tasksLabel)

        // Настройка RecyclerView
        activeTaskAdapter = TaskAdapter(
            onTaskToggle = { task -> viewModel.updateTask(task) },
            onTaskClick = { task -> openEditTask(task) }
        )
        tasksRecyclerView.layoutManager = LinearLayoutManager(context)
        tasksRecyclerView.adapter = activeTaskAdapter

        // Восстанавливаем сохранённую дату или используем сегодня
        val (year, month, day) = loadDateFromPrefs() ?: run {
            val today = Calendar.getInstance()
            Triple(
                today.get(Calendar.YEAR),
                today.get(Calendar.MONTH),
                today.get(Calendar.DAY_OF_MONTH)
            )
        }

        val calendar = Calendar.getInstance().apply {
            set(year, month, day)
        }

        calendarView.setDate(calendar.timeInMillis, false, true)
        loadTasksForDate(year, month + 1, day)

        // Обработка выбора даты в календаре
        calendarView.setOnDateChangeListener { view, year, month, dayOfMonth ->
            saveDateToPrefs(year, month, dayOfMonth)  // ← СОХРАНЯЕМ
            loadTasksForDate(year, month + 1, dayOfMonth)

            val selectedDate = Calendar.getInstance().apply {
                set(year, month, dayOfMonth)
            }
        }



        // Удаление по свайпу
        val swipeCallback = object : SwipeCallback(requireContext()) {
            override fun onDelete(position: Int) {
                val task = activeTaskAdapter.currentList.getOrNull(position)
                if (task != null) {
                    cancelTaskNotification(requireContext(), task.id.toInt())
                    viewModel.removeTask(task)
                }
            }
        }
        ItemTouchHelper(swipeCallback).attachToRecyclerView(tasksRecyclerView)
    }
    private fun saveDateToPrefs(year: Int, month: Int, day: Int) {
        val prefs = requireContext().getSharedPreferences("calendar_prefs", 0)
        prefs.edit().apply {
            putInt("saved_year", year)
            putInt("saved_month", month)
            putInt("saved_day", day)
            apply()
        }
    }

    private fun loadDateFromPrefs(): Triple<Int, Int, Int>? {
        val prefs = requireContext().getSharedPreferences("calendar_prefs", 0)
        val year = prefs.getInt("saved_year", -1)
        val month = prefs.getInt("saved_month", -1)
        val day = prefs.getInt("saved_day", -1)

        return if (year != -1 && month != -1 && day != -1) {
            Triple(year, month, day)
        } else {
            null
        }
    }

    private fun loadTasksForDate(year: Int, month: Int, day: Int) {
        viewModel.getTasksForDate(year, month, day)
            .observe(viewLifecycleOwner) { allTasks ->
                val activeTasks = allTasks.filter { !it.isCompleted }
                activeTaskAdapter.submitList(activeTasks)
                tasksLabel.text = "Задачи на $day.$month.$year (${activeTasks.size})"
            }
    }

    private fun updateCalendarDots(tasks: List<Task>) {
        // Встроенный CalendarView не поддерживает точки
        // Это ограничение Android
    }

    private fun cancelTaskNotification(context: android.content.Context, taskId: Int) {
        val alarmManager = context.getSystemService(android.content.Context.ALARM_SERVICE) as android.app.AlarmManager

        val intent = android.content.Intent(context, TaskNotificationReceiver::class.java).apply {
            action = "com.example.todoappandroid.TASK_NOTIFICATION"
            putExtra("taskId", taskId)
        }

        val pendingIntent = android.app.PendingIntent.getBroadcast(
            context,
            taskId,
            intent,
            android.app.PendingIntent.FLAG_UPDATE_CURRENT or android.app.PendingIntent.FLAG_IMMUTABLE
        )

        alarmManager.cancel(pendingIntent)
    }

    private fun openEditTask(task: Task) {
        val bundle = Bundle().apply {
            putLong("task_id", task.id)
            putString("task_title", task.title)
            putString("task_description", task.description)
            putString("task_date", task.date)
            putString("task_category", task.category)
            putBoolean("task_isCompleted", task.isCompleted)
            putBoolean("task_reminder", task.reminder)
            putString("task_reminder_date_time", task.reminderDateTime)
        }
        findNavController().navigate(R.id.action_calendarFragment_to_editTaskFragment, bundle)
    }
}
