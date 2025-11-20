package com.example.todoappandroid

import TaskViewModel
import android.app.AlertDialog
import android.graphics.Color
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.EditText
import android.widget.LinearLayout
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.appbar.MaterialToolbar
import com.google.android.material.datepicker.MaterialDatePicker
import yuku.ambilwarna.AmbilWarnaDialog

class CreateTaskFragment : Fragment() {

    private lateinit var categoryAdapter: CategoryAdapter
    private var selectedCategory: Category? = null
    private val viewModel: TaskViewModel by activityViewModels()  // ← ОБЩАЯ ViewModel
    private var selectedColor: Int = Color.parseColor("#ED9121")

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_create_task, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        // Скрываем bottom nav
        (activity as? MainActivity)?.findViewById<View>(R.id.bottom_nav_menu)?.visibility = View.GONE

        // ========== ИНИЦИАЛИЗАЦИЯ ЭЛЕМЕНТОВ ==========
        val topAppBar = view.findViewById<MaterialToolbar>(R.id.topAppBar)
        val titleEditText = view.findViewById<EditText>(R.id.taskTitleEditText)
        val dateEditText = view.findViewById<EditText>(R.id.taskDateEditText)
        val descriptionEditText = view.findViewById<EditText>(R.id.taskDescriptionEditText)
        val categoriesRecyclerView = view.findViewById<RecyclerView>(R.id.categoriesRecyclerView)

        // ========== ИНИЦИАЛИЗАЦИЯ КАРУСЕЛИ КАТЕГОРИЙ ==========
        setupCategoryCarousel(categoriesRecyclerView)

        // ========== КАЛЕНДАРЬ ==========
        dateEditText.setOnClickListener {
            val datePicker = MaterialDatePicker.Builder.datePicker()
                .setTitleText("Выберите дату")
                .build()
            datePicker.addOnPositiveButtonClickListener {
                dateEditText.setText(datePicker.headerText)
            }
            datePicker.show(parentFragmentManager, "datePicker")
        }

        // ========== ИКОНКА "НАЗАД" (стрелка влево) ==========
        topAppBar.setNavigationOnClickListener {
            findNavController().navigateUp()
        }

        // ========== ИКОНКА "СОХРАНИТЬ" (галочка) ==========
        topAppBar.setOnMenuItemClickListener { menuItem ->
            when (menuItem.itemId) {
                R.id.action_save -> {
                    val title = titleEditText.text.toString().trim()
                    val description = descriptionEditText.text.toString().trim()
                    val date = dateEditText.text.toString()

                    if (title.isEmpty()) {
                        Toast.makeText(
                            requireContext(),
                            "Пожалуйста, введите название задачи",
                            Toast.LENGTH_SHORT
                        ).show()
                    } else {
                        // Создаём задачу со всеми данными
                        val newTask = Task(
                            title = title,
                            description = if (description.isNotEmpty()) description else null,
                            date = if (date.isNotEmpty()) date else null,
                            category = selectedCategory?.name,
                            reminder = false,
                            isCompleted = false
                        )

                        // ✅ ДОБАВЛЯЕМ ЗАДАЧУ В VIEWMODEL
                        viewModel.addTask(newTask)

                        Toast.makeText(
                            requireContext(),
                            "Задача \"$title\" создана!",
                            Toast.LENGTH_SHORT
                        ).show()

                        findNavController().navigateUp()
                    }
                    true
                }
                else -> false
            }
        }
    }

    // ========== НАСТРОЙКА КАРУСЕЛИ КАТЕГОРИЙ ==========
    private fun setupCategoryCarousel(recyclerView: RecyclerView) {
        categoryAdapter = CategoryAdapter(
            onCategoryClick = { category ->
                selectedCategory = category
            },
            onAddNewClick = {
                showAddCategoryDialog()
            }
        )

        recyclerView.adapter = categoryAdapter
        recyclerView.layoutManager = LinearLayoutManager(
            requireContext(),
            LinearLayoutManager.HORIZONTAL,
            false
        )

        // Предзаполняем категории
        val defaultCategories = listOf(
            Category(name = "Работа", color = "#FF6B6B"),
            Category(name = "Дом", color = "#4ECDC4"),
            Category(name = "Учеба", color = "#45B7D1"),
            Category(name = "Личное", color = "#FFA07A")
        )
        categoryAdapter.setCategories(defaultCategories)
    }

    // ========== ДИАЛОГ ДОБАВЛЕНИЯ НОВОЙ КАТЕГОРИИ ==========
    private fun showAddCategoryDialog() {
        val dialogView = LinearLayout(requireContext()).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(32, 32, 32, 32)
        }

        val nameInput = EditText(requireContext()).apply {
            hint = "Название категории"
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply { bottomMargin = 32 }
        }

        // ========== КОНТЕЙНЕР ДЛЯ КРУЖКА И ТЕКСТА ==========
        val colorContainer = LinearLayout(requireContext()).apply {
            orientation = LinearLayout.HORIZONTAL
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply { bottomMargin = 32 }
            gravity = android.view.Gravity.CENTER_VERTICAL
        }

        // Большой кружок цвета (кликабельный)
        val colorCircle = View(requireContext()).apply {
            layoutParams = LinearLayout.LayoutParams(100, 100).apply {
                marginEnd = 24
            }
            background = android.graphics.drawable.GradientDrawable().apply {
                shape = android.graphics.drawable.GradientDrawable.OVAL
                setColor(selectedColor)
                setStroke(3, Color.GRAY)
            }
            isClickable = true
            isFocusable = true

            setOnClickListener {
                val dialog = AmbilWarnaDialog(requireContext(), selectedColor, object : AmbilWarnaDialog.OnAmbilWarnaListener {
                    override fun onOk(dialog: AmbilWarnaDialog?, color: Int) {
                        selectedColor = color
                        (this@apply.background as? android.graphics.drawable.GradientDrawable)?.setColor(color)
                    }
                    override fun onCancel(dialog: AmbilWarnaDialog?) {
                        // ничего не делаем
                    }
                })
                dialog.show()
            }
        }

        // Текст "Цвет категории"
        val colorLabel = android.widget.TextView(requireContext()).apply {
            text = "Цвет категории"
            textSize = 16f
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            )
        }

        colorContainer.addView(colorCircle)
        colorContainer.addView(colorLabel)

        dialogView.addView(nameInput)
        dialogView.addView(colorContainer)

        AlertDialog.Builder(requireContext())
            .setTitle("Создать новую категорию")
            .setView(dialogView)
            .setPositiveButton("Добавить") { _, _ ->
                val name = nameInput.text.toString().trim()
                if (name.isNotEmpty()) {
                    val hexColor = String.format("#%06X", 0xFFFFFF and selectedColor)
                    val newCategory = Category(name = name, color = hexColor)
                    categoryAdapter.addCategory(newCategory)
                    selectedCategory = newCategory
                    Toast.makeText(requireContext(), "Категория \"$name\" создана!", Toast.LENGTH_SHORT).show()
                } else {
                    Toast.makeText(requireContext(), "Введите название категории", Toast.LENGTH_SHORT).show()
                }
            }
            .setNegativeButton("Отмена", null)
            .show()
    }

    override fun onDestroyView() {
        super.onDestroyView()
        // Показываем bottom nav обратно
        (activity as? MainActivity)?.findViewById<View>(R.id.bottom_nav_menu)?.visibility = View.VISIBLE
    }
}
