package com.example.todoappandroid

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.launch
import java.util.Calendar

class TaskViewModel(application: Application) : AndroidViewModel(application) {

    private val db = AppDatabase.getInstance(application)
    private val taskDao = db.taskDao()
    private val categoryDao = db.categoryDao()

    enum class SortBy {
        BY_CREATION,           // без сортировки
        ALPHABETICAL,   // по алфавиту
        BY_DATE         // по дате
    }
    private val _sortBy = MutableLiveData(SortBy.BY_CREATION)
    val sortBy: LiveData<SortBy> = _sortBy
    private val _filterByCategory = MutableLiveData<String?>(null)
    val filterByCategory: LiveData<String?> = _filterByCategory


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

    private fun filterTasks(tasks: List<Task>): List<Task> {
        val category = _filterByCategory.value
        return if (category == null || category.isEmpty()) {
            tasks  // Все задачи
        } else {
            tasks.filter { it.category == category }  // Только выбранной категории
        }
    }
    val sortedTasks: LiveData<List<Task>> = object : LiveData<List<Task>>() {
        private val tasksObserver = androidx.lifecycle.Observer<List<Task>> { allTasks ->
            updateSortedTasks(allTasks)
        }

        private val sortObserver = androidx.lifecycle.Observer<SortBy> { _ ->
            tasks.value?.let { updateSortedTasks(it) }
        }
        private val filterObserver = androidx.lifecycle.Observer<String?> { _ ->
            tasks.value?.let { updateSortedTasks(it) }
        }

        private fun updateSortedTasks(tasks: List<Task>) {
            val filtered = filterTasks(tasks)
            value = sortTasks(filtered, sortBy.value ?: SortBy.BY_CREATION)
        }

        override fun onActive() {
            tasks.observeForever(tasksObserver)
            sortBy.observeForever(sortObserver)
            filterByCategory.observeForever(filterObserver)
        }

        override fun onInactive() {
            tasks.removeObserver(tasksObserver)
            sortBy.removeObserver(sortObserver)
            filterByCategory.removeObserver(filterObserver)
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
            tasks.observeForever(observer)
        }

        override fun onInactive() {
            tasks.removeObserver(observer)
        }
    }

    val completedTasks: LiveData<List<Task>> = object : LiveData<List<Task>>() {
        private val observer = androidx.lifecycle.Observer<List<Task>> { allTasks ->
            value = allTasks.filter { it.isCompleted }
        }

        override fun onActive() {
            tasks.observeForever(observer)
        }

        override fun onInactive() {
            tasks.removeObserver(observer)
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
    fun updateCategoryNameInTasks(oldName: String, newName: String) {
        viewModelScope.launch {
            taskDao.updateTasksCategory(oldName, newName)
        }
    }
    fun deleteCategory(categoryName: String) {
        viewModelScope.launch {
            categoryDao.deleteByName(categoryName)
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
    fun setFilterByCategory(category: String?) {
        _filterByCategory.value = category
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
    //Календарь
    fun getTasksForDate(year: Int, month: Int, day: Int): LiveData<List<Task>> {
        return object : LiveData<List<Task>>() {
            private val observer = androidx.lifecycle.Observer<List<Task>> { allTasks ->
                val filtered = allTasks.filter { task ->
                    try {
                        if (task.date.isNullOrEmpty()) return@filter false

                        // Пробуем несколько форматов
                        val dateFormats = listOf(
                            "dd MMM. yyyy 'г.'",      // 24 нояб. 2025 г.
                            "dd MMMM yyyy",            // 24 ноября 2025
                            "dd.MM.yyyy",              // 24.11.2025
                            "dd MMM yyyy"              // 24 Nov 2025
                        )

                        var parsedDate: java.util.Date? = null
                        for (format in dateFormats) {
                            try {
                                val dateFormat = java.text.SimpleDateFormat(format, java.util.Locale("ru"))
                                parsedDate = dateFormat.parse(task.date)
                                if (parsedDate != null) break
                            } catch (e: Exception) {
                                // Пробуем следующий формат
                            }
                        }

                        if (parsedDate == null) {
                            android.util.Log.w("TaskViewModel", "Could not parse date: ${task.date}")
                            return@filter false
                        }

                        val calendar = Calendar.getInstance()
                        calendar.time = parsedDate

                        val matches = calendar.get(Calendar.YEAR) == year &&
                                calendar.get(Calendar.MONTH) + 1 == month &&
                                calendar.get(Calendar.DAY_OF_MONTH) == day

                        matches
                    } catch (e: Exception) {
                        android.util.Log.e("TaskViewModel", "Error parsing date: ${task.date}", e)
                        false
                    }
                }
                value = filtered
            }

            override fun onActive() {
                tasks.observeForever(observer)
            }

            override fun onInactive() {
                tasks.removeObserver(observer)
            }
        }
    }



}
