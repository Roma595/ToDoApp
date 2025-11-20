package com.example.todoappandroid

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.LiveData
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.launch

class TaskViewModel(application: Application) : AndroidViewModel(application) {

    private val db = AppDatabase.getInstance(application)
    private val taskDao = db.taskDao()
    private val categoryDao = db.categoryDao()

    // Все задачи из БД
    private val allTasksFromDb: LiveData<List<TaskEntity>> = taskDao.getAllTasks()

    // Преобразуем в Model
    private val _tasks = object : LiveData<List<Task>>() {
        private val observer = androidx.lifecycle.Observer<List<TaskEntity>> { entities ->
            value = entities.map { it.toTask() }
        }

        override fun onActive() {
            allTasksFromDb.observeForever(observer)
        }

        override fun onInactive() {
            allTasksFromDb.removeObserver(observer)
        }
    }
    val tasks: LiveData<List<Task>> = _tasks

    // Активные и выполненные
    val activeTasks: LiveData<List<Task>> = object : LiveData<List<Task>>() {
        private val observer = androidx.lifecycle.Observer<List<Task>> { allTasks ->
            value = allTasks.filter { !it.isCompleted }
        }

        override fun onActive() {
            _tasks.observeForever(observer)
        }

        override fun onInactive() {
            _tasks.removeObserver(observer)
        }
    }

    val completedTasks: LiveData<List<Task>> = object : LiveData<List<Task>>() {
        private val observer = androidx.lifecycle.Observer<List<Task>> { allTasks ->
            value = allTasks.filter { it.isCompleted }
        }

        override fun onActive() {
            _tasks.observeForever(observer)
        }

        override fun onInactive() {
            _tasks.removeObserver(observer)
        }
    }

    // ⭐ КАТЕГОРИИ
    val categories: LiveData<List<Category>> = object : LiveData<List<Category>>() {
        private val observer = androidx.lifecycle.Observer<List<CategoryEntity>> { entities ->
            value = entities.map { it.toCategory() }
        }

        override fun onActive() {
            categoryDao.getAllCategories().observeForever(observer)
        }

        override fun onInactive() {
            categoryDao.getAllCategories().removeObserver(observer)
        }
    }

    // ========== ОПЕРАЦИИ С ЗАДАЧАМИ ==========
    fun addTask(task: Task) {
        viewModelScope.launch {
            taskDao.insert(task.toEntity())
        }
    }

    fun updateTask(task: Task) {
        viewModelScope.launch {
            taskDao.update(task.toEntity())
        }
    }

    fun removeTask(task: Task) {
        viewModelScope.launch {
            taskDao.delete(task.toEntity())
        }
    }

    // ========== ОПЕРАЦИИ С КАТЕГОРИЯМИ ==========
    fun addCategory(category: Category) {
        viewModelScope.launch {
            categoryDao.insert(category.toEntity())
        }
    }

    fun removeCategory(category: Category) {
        viewModelScope.launch {
            categoryDao.delete(category.toEntity())
        }
    }

}
