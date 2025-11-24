package com.example.todoappandroid

import android.app.AlertDialog
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.ItemTouchHelper
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.appbar.MaterialToolbar
import com.google.android.material.button.MaterialButton


class ListFragment : Fragment() {

    private lateinit var activeTasksRecyclerView: RecyclerView
    private lateinit var completedTasksRecyclerView: RecyclerView
    private lateinit var activeTaskAdapter: TaskAdapter
    private lateinit var completedTaskAdapter: TaskAdapter
    private lateinit var createTaskButton: MaterialButton
    private lateinit var topAppBar: MaterialToolbar
    private val viewModel: TaskViewModel by activityViewModels()

    private var currentFilter: String? = null

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_list, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        activeTasksRecyclerView = view.findViewById(R.id.activeTasksRecyclerView)
        completedTasksRecyclerView = view.findViewById(R.id.completedTasksRecyclerView)
        createTaskButton = view.findViewById(R.id.createTaskButton)
        topAppBar = view.findViewById(R.id.topAppBar)
        activeTaskAdapter = TaskAdapter(
            onTaskToggle = { task -> viewModel.updateTask(task) },
            onTaskClick = { task -> openEditTask(task) }
        )
        completedTaskAdapter = TaskAdapter(
            onTaskToggle = { task -> viewModel.updateTask(task) },
            onTaskClick = { task -> openEditTask(task) }
        )

        activeTasksRecyclerView.adapter = activeTaskAdapter
        completedTasksRecyclerView.adapter = completedTaskAdapter

        // Удаление по свайпу для активных
        val activeSwipeCallback = object : SwipeCallback(requireContext()) {
            override fun onDelete(position: Int) {
                val task = activeTaskAdapter.currentList.getOrNull(position)
                if (task != null) {
                    // ← ДОБАВЬТЕ: Отмена напоминания перед удалением
                    cancelTaskNotification(requireContext(), task.id.toInt())
                    viewModel.removeTask(task)
                }
            }
        }
        ItemTouchHelper(activeSwipeCallback).attachToRecyclerView(activeTasksRecyclerView)


        // Удаление по свайпу для выполненных
        val completedSwipeCallback = object : SwipeCallback(requireContext()) {
            override fun onDelete(position: Int) {
                val task = completedTaskAdapter.currentList.getOrNull(position)
                if (task != null) {
                    // ← ДОБАВЬТЕ: Отмена напоминания перед удалением
                    cancelTaskNotification(requireContext(), task.id.toInt())
                    viewModel.removeTask(task)
                }
            }
        }
        ItemTouchHelper(completedSwipeCallback).attachToRecyclerView(completedTasksRecyclerView)

        topAppBar.setOnMenuItemClickListener { menuItem ->
            when (menuItem.itemId) {
                R.id.action_sort -> {
                    showSortMenu()
                    true
                }
                R.id.action_filter -> {
                    showFilterMenu()
                    true
                }
                else -> false
            }
        }

        viewModel.sortedActiveTasks.observe(viewLifecycleOwner) { tasks ->
            activeTaskAdapter.submitList(tasks)
        }

        viewModel.sortedCompletedTasks.observe(viewLifecycleOwner) { tasks ->
            completedTaskAdapter.submitList(tasks)
        }

        // Копка создать задачу
        createTaskButton.setOnClickListener {
            findNavController().navigate(R.id.action_listFragment_to_createTaskFragment)
        }
        viewModel.categories.observe(viewLifecycleOwner) { categories ->
            viewModel.sortedTasks.observe(viewLifecycleOwner) { allTasks ->
                // Проверяем: есть ли ещё задачи в текущей отфильтрованной категории
                if (currentFilter != null) {
                    val hasTasksInCurrentFilter = allTasks.any { task ->
                        task.category == currentFilter
                    }

                    // Если задач в текущем фильтре нет - переключаемся на "Все"
                    if (!hasTasksInCurrentFilter) {
                        currentFilter = null
                        viewModel.setFilterByCategory(null)
                    }
                }
            }
        }
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


    private fun showSortMenu() {
        val sortOptions = arrayOf(
            "По дате создания",
            "По алфавиту (A-Я)",
            "По дате выполнения"
        )

        AlertDialog.Builder(requireContext())
            .setTitle("Сортировка задач")
            .setItems(sortOptions) { _, which ->
                val sortBy = when (which) {
                    0 -> TaskViewModel.SortBy.BY_CREATION
                    1 -> TaskViewModel.SortBy.ALPHABETICAL
                    2 -> TaskViewModel.SortBy.BY_DATE
                    else -> TaskViewModel.SortBy.BY_CREATION
                }
                viewModel.setSortBy(sortBy)
            }
            .show()
    }
    private fun showFilterMenu() {
        // Получаем актуальные данные
        val allTasks = viewModel.tasks.value ?: emptyList()
        val categories = viewModel.categories.value ?: emptyList()

        // Показывайем категории, у которых есть задачи
        val categoriesWithTasks = categories.filter { category ->
            allTasks.any { task -> task.category == category.name }
        }

        val categoryNames = mutableListOf("Все категории")
        categoryNames.addAll(categoriesWithTasks.map { it.name })

        // Находим текущий выбранный индекс
        var selectedIndex = categoryNames.indexOf(currentFilter)
        if (selectedIndex == -1) {
            selectedIndex = 0  // "Все категории" по умолчанию
        }

        AlertDialog.Builder(requireContext())
            .setTitle("Фильтр по категориям")
            .setSingleChoiceItems(
                categoryNames.toTypedArray(),
                selectedIndex
            ) { dialog, which ->
                // Сохраняем выбор
                val selectedCategory = if (which == 0) {
                    null  // "Все категории"
                } else {
                    categoriesWithTasks[which - 1].name  // Выбранная категория
                }

                currentFilter = selectedCategory
                viewModel.setFilterByCategory(selectedCategory)
                dialog.dismiss()
            }
            .show()
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
        findNavController().navigate(R.id.action_listFragment_to_editTaskFragment, bundle)
    }
}