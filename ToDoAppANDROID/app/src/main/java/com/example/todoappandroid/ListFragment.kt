package com.example.todoappandroid


import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.ItemTouchHelper
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.button.MaterialButton


class ListFragment : Fragment() {

    private lateinit var activeTasksRecyclerView: RecyclerView
    private lateinit var completedTasksRecyclerView: RecyclerView
    private lateinit var activeTaskAdapter: TaskAdapter
    private lateinit var completedTaskAdapter: TaskAdapter
    private lateinit var createTaskButton: MaterialButton
    private val viewModel: TaskViewModel by activityViewModels()

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
                    viewModel.removeTask(task)
                }
            }
        }
        ItemTouchHelper(completedSwipeCallback).attachToRecyclerView(completedTasksRecyclerView)


        viewModel.activeTasks.observe(viewLifecycleOwner) { tasks ->
            activeTaskAdapter.submitList(tasks)
        }

        viewModel.completedTasks.observe(viewLifecycleOwner) { tasks ->
            completedTaskAdapter.submitList(tasks)
        }

        // Копка создать задачу
        createTaskButton.setOnClickListener {
            findNavController().navigate(R.id.action_listFragment_to_createTaskFragment)
        }
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