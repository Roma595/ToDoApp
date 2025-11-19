package com.example.todoappandroid
import com.google.android.material.checkbox.MaterialCheckBox
import android.graphics.Paint
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.CheckBox
import android.widget.TextView
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import androidx.recyclerview.widget.DiffUtil

class TaskAdapter(
    private val onTaskClick: (Task) -> Unit,
    private val onTaskToggle: (Task) -> Unit
) : ListAdapter<Task, TaskAdapter.TaskViewHolder>(TaskDiffCallback()) {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): TaskViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.item_task, parent, false)
        return TaskViewHolder(view)
    }

    override fun onBindViewHolder(holder: TaskViewHolder, position: Int) {
        holder.bind(getItem(position))
    }

    inner class TaskViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        private val checkBox: MaterialCheckBox = itemView.findViewById(R.id.taskCheckBox)  // ← изменено
        private val titleTextView: TextView = itemView.findViewById(R.id.taskTitle)
        private val dateTextView: TextView = itemView.findViewById(R.id.taskDate)

        fun bind(task: Task) {
            titleTextView.text = task.title

            // Убираем слушатель, чтобы избежать срабатываний при переиспользовании ViewHolder
            checkBox.setOnCheckedChangeListener(null)
            checkBox.isChecked = task.isCompleted

            // Меняем стиль текста
            if (task.isCompleted) {
                titleTextView.paintFlags = titleTextView.paintFlags or Paint.STRIKE_THRU_TEXT_FLAG
                titleTextView.alpha = 0.5f
            } else {
                titleTextView.paintFlags = titleTextView.paintFlags and Paint.STRIKE_THRU_TEXT_FLAG.inv()
                titleTextView.alpha = 1f
            }

            // Дата задачи
            if (task.date != null) {
                dateTextView.text = task.date
                dateTextView.visibility = View.VISIBLE
            } else {
                dateTextView.visibility = View.GONE
            }

            // Теперь назначаем слушатель заново
            checkBox.setOnCheckedChangeListener { _, isChecked ->
                onTaskToggle(task.copy(isCompleted = isChecked))
            }
        }

    }

}

class TaskDiffCallback : DiffUtil.ItemCallback<Task>() {
    override fun areItemsTheSame(oldItem: Task, newItem: Task) = oldItem.id == newItem.id
    override fun areContentsTheSame(oldItem: Task, newItem: Task) = oldItem == newItem
}
