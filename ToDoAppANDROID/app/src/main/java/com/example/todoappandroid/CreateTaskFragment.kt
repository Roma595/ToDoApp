package com.example.todoappandroid
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.EditText
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import com.google.android.material.appbar.MaterialToolbar

class CreateTaskFragment : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_create_task, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        // Получаем элементы
        val topAppBar = view.findViewById<MaterialToolbar>(R.id.topAppBar)
        val titleEditText = view.findViewById<EditText>(R.id.taskTitleEditText)
        val descriptionEditText = view.findViewById<EditText>(R.id.taskDescriptionEditText)

        // ========== ИКОНКА "НАЗАД" (стрелка влево) ==========
        topAppBar.setNavigationOnClickListener {
            // Возвращаемся на список без сохранения
            findNavController().navigateUp()
        }

        // ========== ИКОНКА "СОХРАНИТЬ" (галочка) ==========
        topAppBar.setOnMenuItemClickListener { menuItem ->
            when (menuItem.itemId) {
                R.id.action_save -> {
                    val title = titleEditText.text.toString().trim()
                    val description = descriptionEditText.text.toString().trim()

                    // Проверяем, что название не пусто
                    if (title.isEmpty()) {
                        Toast.makeText(
                            requireContext(),
                            "Пожалуйста, введите название задачи",
                            Toast.LENGTH_SHORT
                        ).show()
                    } else {
                        // TODO: Здесь нужно сохранить задачу в ViewModel или БД
                        Toast.makeText(
                            requireContext(),
                            "Задача \"$title\" создана!",
                            Toast.LENGTH_SHORT
                        ).show()

                        // Возвращаемся на список
                        findNavController().navigateUp()
                    }
                    true
                }
                else -> false
            }
        }
    }
}