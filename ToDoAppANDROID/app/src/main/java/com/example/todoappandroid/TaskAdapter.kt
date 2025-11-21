package com.example.todoappandroid

import android.graphics.Paint
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import androidx.recyclerview.widget.DiffUtil
import com.google.android.material.checkbox.MaterialCheckBox

class TaskAdapter(
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
        private val checkBox: MaterialCheckBox = itemView.findViewById(R.id.taskCheckBox)
        private val titleTextView: TextView = itemView.findViewById(R.id.taskTitle)
        private val dateTextView: TextView = itemView.findViewById(R.id.taskDate)

        fun bind(task: Task) {
            titleTextView.text = task.title

            checkBox.setOnCheckedChangeListener(null)
            checkBox.isChecked = task.isCompleted

            // Визуальные эффекты для выполненной задачи
            if (task.isCompleted) {
                titleTextView.paintFlags = titleTextView.paintFlags or Paint.STRIKE_THRU_TEXT_FLAG
                titleTextView.alpha = 0.5f
                dateTextView.alpha = 0.5f
            } else {
                titleTextView.paintFlags = titleTextView.paintFlags and Paint.STRIKE_THRU_TEXT_FLAG.inv()
                titleTextView.alpha = 1f
                dateTextView.alpha = 1f
            }

            // Отображаем дату если есть
            if (task.date != null) {
                dateTextView.text = task.date
                dateTextView.visibility = View.VISIBLE
            } else {
                dateTextView.visibility = View.GONE
            }

            checkBox.setOnCheckedChangeListener { _, isChecked ->
                if (isChecked != task.isCompleted) {
                    onTaskToggle(task.copy(isCompleted = isChecked))
                }
            }
        }
    }
}

class TaskDiffCallback : DiffUtil.ItemCallback<Task>() {
    override fun areItemsTheSame(oldItem: Task, newItem: Task) = oldItem.id == newItem.id
    override fun areContentsTheSame(oldItem: Task, newItem: Task) = oldItem == newItem
}
