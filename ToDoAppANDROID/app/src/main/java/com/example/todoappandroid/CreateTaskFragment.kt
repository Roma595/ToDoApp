package com.example.todoappandroid

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
import com.google.android.material.timepicker.MaterialTimePicker
import com.google.android.material.timepicker.TimeFormat
import yuku.ambilwarna.AmbilWarnaDialog

class CreateTaskFragment : Fragment() {

    private lateinit var categoryAdapter: CategoryAdapter
    private var selectedCategory: Category? = null
    private val viewModel: TaskViewModel by activityViewModels()
    private var selectedColor: Int = Color.parseColor("#ED9121")

    private var reminderDate: String? = null
    private var reminderTime: String? = null

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

        // Элементы
        val topAppBar = view.findViewById<MaterialToolbar>(R.id.topAppBar)
        val titleEditText = view.findViewById<EditText>(R.id.taskTitleEditText)
        val dateEditText = view.findViewById<EditText>(R.id.taskDateEditText)
        val descriptionEditText = view.findViewById<EditText>(R.id.taskDescriptionEditText)
        val categoriesRecyclerView = view.findViewById<RecyclerView>(R.id.categoriesRecyclerView)
        val reminderEditText = view.findViewById<EditText>(R.id.reminderEditText)

        // Карусель категорий
        setupCategoryCarousel(categoriesRecyclerView)

        // Календарь
        dateEditText.setOnClickListener {
            val datePicker = MaterialDatePicker.Builder.datePicker()
                .setTitleText("Выберите дату")
                .build()
            datePicker.addOnPositiveButtonClickListener {
                dateEditText.setText(datePicker.headerText)
            }
            datePicker.show(parentFragmentManager, "datePicker")
        }
        // Стрелка назад
        topAppBar.setNavigationOnClickListener {
            findNavController().navigateUp()
        }

        // Галочка сохранить
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

                        val newTask = Task(
                            title = title,
                            description = if (description.isNotEmpty()) description else null,
                            date = if (date.isNotEmpty()) date else null,
                            category = selectedCategory?.name,
                            reminder = false,
                            isCompleted = false
                        )

                        viewModel.addTask(newTask)
                        findNavController().navigateUp()
                    }
                    true
                }
                else -> false
            }
        }
    }

    // Настройка карусели категорий
    private fun setupCategoryCarousel(recyclerView: RecyclerView) {
        categoryAdapter = CategoryAdapter(
            onCategoryClick = { category ->
                selectedCategory = category
            },
            onAddNewClick = {
                showAddCategoryDialog()
            },
            onCategoryLongClick = { category ->
                showCategoryOptionsDialog(category)
            }
        )

        recyclerView.adapter = categoryAdapter
        recyclerView.layoutManager = LinearLayoutManager(
            requireContext(),
            LinearLayoutManager.HORIZONTAL,
            false
        )

        // Загружаем категории из БД
        viewModel.categories.observe(viewLifecycleOwner) { categories ->
            categoryAdapter.setCategories(categories)
        }
    }

    // Добавление новой категории
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


        val colorContainer = LinearLayout(requireContext()).apply {
            orientation = LinearLayout.HORIZONTAL
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply { bottomMargin = 32 }
            gravity = android.view.Gravity.CENTER_VERTICAL
        }


        val colorCircle = View(requireContext()).apply {
            layoutParams = LinearLayout.LayoutParams(100, 100).apply {
                marginEnd = 24
            }
            background = android.graphics.drawable.GradientDrawable().apply {
                shape = android.graphics.drawable.GradientDrawable.OVAL
                setColor(selectedColor)
                setStroke(4, Color.parseColor("#6750A4"))
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
                    }
                })
                dialog.show()
            }
        }

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


                    viewModel.addCategory(newCategory)


                    categoryAdapter.addCategory(newCategory)
                    selectedCategory = newCategory

                } else {
                    Toast.makeText(
                        requireContext(),
                        "Введите название категории",
                        Toast.LENGTH_SHORT
                    ).show()
                }
            }
            .setNegativeButton("Отмена", null)
            .show()
    }

    private fun showCategoryOptionsDialog(category: Category) {
        val options = arrayOf("Редактировать", "Удалить", "Отмена")

        android.app.AlertDialog.Builder(requireContext())
            .setTitle("Категория: ${category.name}")
            .setItems(options) { _, which ->
                when (which) {
                    0 -> showEditCategoryDialog(category)
                    1 -> showDeleteCategoryDialog(category)
                    2 -> {}
                }
            }
            .show()
    }
    private fun showEditCategoryDialog(category: Category) {
        val dialogView = android.widget.LinearLayout(requireContext()).apply {
            orientation = android.widget.LinearLayout.VERTICAL
            setPadding(32, 32, 32, 32)
        }

        // Поле для названия
        val nameInput = android.widget.EditText(requireContext()).apply {
            setText(category.name)
            hint = "Название категории"
            layoutParams = android.widget.LinearLayout.LayoutParams(
                android.widget.LinearLayout.LayoutParams.MATCH_PARENT,
                android.widget.LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply { bottomMargin = 32 }
        }

        // Выбор цвета
        val colorContainer = android.widget.LinearLayout(requireContext()).apply {
            orientation = android.widget.LinearLayout.HORIZONTAL
            layoutParams = android.widget.LinearLayout.LayoutParams(
                android.widget.LinearLayout.LayoutParams.MATCH_PARENT,
                android.widget.LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply { bottomMargin = 32 }
            gravity = android.view.Gravity.CENTER_VERTICAL
        }

        var currentColor = category.color

        val colorCircle = View(requireContext()).apply {
            layoutParams = android.widget.LinearLayout.LayoutParams(100, 100).apply {
                marginEnd = 24
            }
            background = android.graphics.drawable.GradientDrawable().apply {
                shape = android.graphics.drawable.GradientDrawable.OVAL
                setColor(Color.parseColor(currentColor))
                setStroke(4, Color.parseColor("#6750A4"))
            }
            isClickable = true
            isFocusable = true

            setOnClickListener {
                val dialog = AmbilWarnaDialog(
                    requireContext(),
                    Color.parseColor(currentColor),
                    object : AmbilWarnaDialog.OnAmbilWarnaListener {
                        override fun onOk(dialog: AmbilWarnaDialog?, color: Int) {
                            currentColor = String.format("#%06X", 0xFFFFFF and color)
                            (this@apply.background as? android.graphics.drawable.GradientDrawable)?.setColor(color)
                        }

                        override fun onCancel(dialog: AmbilWarnaDialog?) {}
                    }
                )
                dialog.show()
            }
        }

        val colorLabel = android.widget.TextView(requireContext()).apply {
            text = "Цвет категории"
            textSize = 16f
            layoutParams = android.widget.LinearLayout.LayoutParams(
                android.widget.LinearLayout.LayoutParams.WRAP_CONTENT,
                android.widget.LinearLayout.LayoutParams.WRAP_CONTENT
            )
        }

        colorContainer.addView(colorCircle)
        colorContainer.addView(colorLabel)

        dialogView.addView(nameInput)
        dialogView.addView(colorContainer)

        android.app.AlertDialog.Builder(requireContext())
            .setTitle("Редактировать категорию")
            .setView(dialogView)
            .setPositiveButton("Сохранить") { _, _ ->
                val newName = nameInput.text.toString().trim()
                if (newName.isNotEmpty()) {
                    val updatedCategory = Category(
                        name = newName,
                        color = currentColor
                    )
                    // Обновляем в БД (если у тебя есть updateCategory в ViewModel)
                    viewModel.updateCategory(updatedCategory)
                    categoryAdapter.notifyDataSetChanged()
                } else {
                    Toast.makeText(
                        requireContext(),
                        "Введите название категории",
                        Toast.LENGTH_SHORT
                    ).show()
                }
            }
            .setNegativeButton("Отмена", null)
            .show()
    }

    private fun showDeleteCategoryDialog(category: Category) {
        android.app.AlertDialog.Builder(requireContext())
            .setTitle("Удалить категорию?")
            .setMessage("Все задачи с категорией '${category.name}' будут удалены")
            .setPositiveButton("Удалить") { _, _ ->
                // Удаляем категорию и все связанные задачи
                viewModel.deleteCategoryWithTasks(category.name)
                categoryAdapter.notifyDataSetChanged()
                Toast.makeText(
                    requireContext(),
                    "Категория и задачи удалены",
                    Toast.LENGTH_SHORT
                ).show()
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