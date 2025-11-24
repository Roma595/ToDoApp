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
import java.util.Calendar

class CalendarFragment : Fragment() {

    private lateinit var calendarView: CalendarView
    private lateinit var tasksRecyclerView: RecyclerView
    private lateinit var activeTaskAdapter: TaskAdapter
    private val viewModel: TaskViewModel by activityViewModels()
    private lateinit var tasksLabel: TextView

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_calendar, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        calendarView = view.findViewById(R.id.calendarView)
        tasksRecyclerView = view.findViewById(R.id.tasksRecyclerView)
        tasksLabel = view.findViewById(R.id.tasksLabel)

        activeTaskAdapter = TaskAdapter(
            onTaskToggle = { task -> viewModel.updateTask(task) },
            onTaskClick = { task -> openEditTask(task) }
        )
        tasksRecyclerView.layoutManager = LinearLayoutManager(context)
        tasksRecyclerView.adapter = activeTaskAdapter

        val today = Calendar.getInstance()
        calendarView.setDate(today.timeInMillis, false, true)
        loadTasksForDate(
            today.get(Calendar.YEAR),
            today.get(Calendar.MONTH) + 1,
            today.get(Calendar.DAY_OF_MONTH)
        )

        calendarView.setOnDateChangeListener { _, year, month, dayOfMonth ->
            loadTasksForDate(year, month + 1, dayOfMonth)
            val selectedDate = Calendar.getInstance().apply {
                set(year, month, dayOfMonth)
            }
        }
    }

    private fun loadTasksForDate(year: Int, month: Int, day: Int) {
        viewModel.getTasksForDate(year, month, day)
            .observe(viewLifecycleOwner) { allTasks ->
                val activeTasks = allTasks.filter { !it.isCompleted }
                activeTaskAdapter.submitList(activeTasks)
                tasksLabel.text = "Задачи на $day.$month.$year"
            }
    }
    private fun openEditTask(task: Task) {
        val bundle = Bundle().apply {
            putInt("task_id", task.id)
            putString("task_title", task.title)
            putString("task_description", task.description)
            putString("task_date", task.date)
            putString("task_category", task.category)
            putBoolean("task_isCompleted", task.isCompleted)
            putBoolean("task_reminder", task.reminder)
            putString("task_reminder_date_time", task.reminderDateTime)
        }
        findNavController().navigate(R.id.action_navigation_calendar_to_profileFragment, bundle)
    }
}
