import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.example.todoappandroid.Task

class TaskViewModel : ViewModel() {

    private val _tasks = MutableLiveData<List<Task>>(emptyList())
    val tasks: LiveData<List<Task>> = _tasks

    // ⭐ АКТИВНЫЕ ЗАДАЧИ - пересчитываются при каждом изменении _tasks
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

    // ⭐ ВЫПОЛНЕННЫЕ ЗАДАЧИ - пересчитываются при каждом изменении _tasks
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

    fun addTask(task: Task) {
        val currentList = _tasks.value?.toMutableList() ?: mutableListOf()
        currentList.add(task)
        _tasks.value = currentList  // ⭐ Вызываем _tasks.value = ... это ОЧЕНЬ важно!
    }

    fun updateTask(task: Task) {
        val currentList = _tasks.value?.toMutableList() ?: mutableListOf()
        val index = currentList.indexOfFirst { it.id == task.id }
        if (index != -1) {
            currentList[index] = task
            _tasks.value = currentList  // ⭐ ЭТА СТРОКА ГЛАВНАЯ!
        }
    }

    fun removeTask(task: Task) {
        val currentList = _tasks.value?.toMutableList() ?: mutableListOf()
        currentList.remove(task)
        _tasks.value = currentList
    }
}
