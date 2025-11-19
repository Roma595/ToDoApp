package com.example.todoappandroid

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel


class TaskViewModel : ViewModel() {

    private val _tasks = MutableLiveData<List<Task>>(emptyList())
    val tasks: LiveData<List<Task>> = _tasks

    // Активные задачи
    val activeTasks: LiveData<List<Task>> = object : LiveData<List<Task>>() {
        override fun onActive() {
            value = _tasks.value?.filter { !it.isCompleted } ?: emptyList()
        }
    }

    // Выполненные задачи
    val completedTasks: LiveData<List<Task>> = object : LiveData<List<Task>>() {
        override fun onActive() {
            value = _tasks.value?.filter { it.isCompleted } ?: emptyList()
        }
    }

    fun addTask(task: Task) {
        val currentList = _tasks.value?.toMutableList() ?: mutableListOf()
        currentList.add(task)
        _tasks.value = currentList
    }

    fun updateTask(task: Task) {
        val currentList = _tasks.value?.toMutableList() ?: mutableListOf()
        val index = currentList.indexOfFirst { it.id == task.id }
        if (index != -1) {
            currentList[index] = task
            _tasks.value = currentList
        }
    }

    fun removeTask(task: Task) {
        val currentList = _tasks.value?.toMutableList() ?: mutableListOf()
        currentList.remove(task)
        _tasks.value = currentList
    }
}
