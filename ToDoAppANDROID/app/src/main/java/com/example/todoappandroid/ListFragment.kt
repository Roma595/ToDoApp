package com.example.todoappandroid

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.button.MaterialButton
import androidx.fragment.app.activityViewModels

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

        // ========== АДАПТЕР ДЛЯ АКТИВНЫХ ЗАДАЧ ==========
        activeTaskAdapter = TaskAdapter(
            onTaskClick = { task ->
                // Можно добавить редактирование задачи
            },
            onTaskToggle = { task ->
                viewModel.updateTask(task)
            }
        )
        activeTasksRecyclerView.adapter = activeTaskAdapter

        // ========== АДАПТЕР ДЛЯ ВЫПОЛНЕННЫХ ЗАДАЧ ==========
        completedTaskAdapter = TaskAdapter(
            onTaskClick = { task ->
                // Можно добавить редактирование задачи
            },
            onTaskToggle = { task ->
                viewModel.updateTask(task)
            }
        )
        completedTasksRecyclerView.adapter = completedTaskAdapter

        // ========== НАБЛЮДЕНИЕ ЗА АКТИВНЫМИ ЗАДАЧАМИ ==========
        viewModel.activeTasks.observe(viewLifecycleOwner) { tasks ->
            activeTaskAdapter.submitList(tasks)
        }

        // ========== НАБЛЮДЕНИЕ ЗА ВЫПОЛНЕННЫМИ ЗАДАЧАМИ ==========
        viewModel.completedTasks.observe(viewLifecycleOwner) { tasks ->
            completedTaskAdapter.submitList(tasks)
        }

        // ========== КНОПКА "СОЗДАТЬ ЗАДАЧУ" ==========
        createTaskButton.setOnClickListener {
            findNavController().navigate(
                R.id.action_listFragment_to_createTaskFragment
            )
        }
    }
}
