package com.example.todoappandroid

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.launch

class TaskViewModel(application: Application) : AndroidViewModel(application) {

    private val db = AppDatabase.getInstance(application)
    private val taskDao = db.taskDao()
    private val categoryDao = db.categoryDao()

    enum class SortBy {
        BY_CREATION,           // без сортировки
        ALPHABETICAL,   // по алфавиту
        BY_DATE         // по дате
    }
    // Все задачи из БД
    private val _sortBy = MutableLiveData(SortBy.BY_CREATION)
    val sortBy: LiveData<SortBy> = _sortBy
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
        val sortedTasks: LiveData<List<Task>> = object : LiveData<List<Task>>() {
        private val tasksObserver = androidx.lifecycle.Observer<List<Task>> { allTasks ->
            updateSortedTasks(allTasks)
        }

        private val sortObserver = androidx.lifecycle.Observer<SortBy> { _ ->
            _tasks.value?.let { updateSortedTasks(it) }
        }

        private fun updateSortedTasks(tasks: List<Task>) {
            value = sortTasks(tasks, _sortBy.value ?: SortBy.BY_CREATION)
        }

        override fun onActive() {
            _tasks.observeForever(tasksObserver)
            _sortBy.observeForever(sortObserver)
        }

        override fun onInactive() {
            _tasks.removeObserver(tasksObserver)
            _sortBy.removeObserver(sortObserver)
        }

    }
    val sortedActiveTasks: LiveData<List<Task>> = object : LiveData<List<Task>>() {
        private val observer = androidx.lifecycle.Observer<List<Task>> { allTasks ->
            value = allTasks.filter { !it.isCompleted }
        }

        override fun onActive() {
            sortedTasks.observeForever(observer)
        }

        override fun onInactive() {
            sortedTasks.removeObserver(observer)
        }
    }

    val sortedCompletedTasks: LiveData<List<Task>> = object : LiveData<List<Task>>() {
        private val observer = androidx.lifecycle.Observer<List<Task>> { allTasks ->
            value = allTasks.filter { it.isCompleted }
        }

        override fun onActive() {
            sortedTasks.observeForever(observer)
        }

        override fun onInactive() {
            sortedTasks.removeObserver(observer)
        }
    }

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

    // Категории
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

    private fun sortTasks(tasks: List<Task>, sortBy: SortBy): List<Task> {
        return when (sortBy) {
            SortBy.ALPHABETICAL -> tasks.sortedBy { it.title }  // По алфавиту A-Z
            SortBy.BY_DATE -> tasks.sortedBy { it.date ?: "" }  // По дате (пустые вперёд)
            SortBy.BY_CREATION -> tasks                                 // Без сортировки
        }
    }
    fun setSortBy(sortBy: SortBy) {
        _sortBy.value = sortBy
    }
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


    fun addCategory(category: Category) {
        viewModelScope.launch {
            categoryDao.insert(category.toEntity())
        }
    }
    fun updateCategory(category: Category) {
        viewModelScope.launch {
            categoryDao.update(category.toEntity())
        }
    }
    fun deleteCategoryWithTasks(categoryName: String) {
        viewModelScope.launch {
            // Удаляем все задачи с этой категорией
            taskDao.deleteTasksByCategory(categoryName)
            // Удаляем саму категорию
            categoryDao.deleteByName(categoryName)
        }
    }

}
