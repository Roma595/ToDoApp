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
        viewModel.categories.observe(this) {
            // ничего не делай, просто нужна подписка для запуска Room
        }
        return inflater.inflate(R.layout.fragment_list, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        activeTasksRecyclerView = view.findViewById(R.id.activeTasksRecyclerView)
        completedTasksRecyclerView = view.findViewById(R.id.completedTasksRecyclerView)
        createTaskButton = view.findViewById(R.id.createTaskButton)

        // ========== АДАПТЕРЫ ==========
        activeTaskAdapter = TaskAdapter { task ->
            viewModel.updateTask(task)
        }
        completedTaskAdapter = TaskAdapter { task ->
            viewModel.updateTask(task)
        }

        activeTasksRecyclerView.adapter = activeTaskAdapter
        completedTasksRecyclerView.adapter = completedTaskAdapter

// ========== SWIPE TO DELETE ДЛЯ АКТИВНЫХ ЗАДАЧ ==========
        val activeSwipeCallback = object : SwipeCallback(requireContext()) {  // ← добавь requireContext()
            override fun onDelete(position: Int) {
                val task = activeTaskAdapter.currentList.getOrNull(position)
                if (task != null) {
                    viewModel.removeTask(task)
                }
            }
        }
        ItemTouchHelper(activeSwipeCallback).attachToRecyclerView(activeTasksRecyclerView)

// ========== SWIPE TO DELETE ДЛЯ ВЫПОЛНЕННЫХ ЗАДАЧ ==========
        val completedSwipeCallback = object : SwipeCallback(requireContext()) {  // ← добавь requireContext()
            override fun onDelete(position: Int) {
                val task = completedTaskAdapter.currentList.getOrNull(position)
                if (task != null) {
                    viewModel.removeTask(task)
                }
            }
        }
        ItemTouchHelper(completedSwipeCallback).attachToRecyclerView(completedTasksRecyclerView)

        // ========== НАБЛЮДЕНИЕ ЗА ЗАДАЧАМИ ==========
        viewModel.activeTasks.observe(viewLifecycleOwner) { tasks ->
            activeTaskAdapter.submitList(tasks)
        }

        viewModel.completedTasks.observe(viewLifecycleOwner) { tasks ->
            completedTaskAdapter.submitList(tasks)
        }

        // ========== КНОПКА ==========
        createTaskButton.setOnClickListener {
            findNavController().navigate(R.id.action_listFragment_to_createTaskFragment)
        }
    }
}
