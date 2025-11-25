package com.example.todoappandroid


import android.graphics.Color
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView

class CategoryAdapter(
    private val onCategoryClick: (Category) -> Unit,
    private val onAddNewClick: () -> Unit,
    private val onCategoryLongClick: (Category) -> Unit
) : RecyclerView.Adapter<RecyclerView.ViewHolder>() {

    private val categories = mutableListOf<Category>()
    private var selectedCategory: Category? = null

    fun selectCategory(category: Category) {
        selectedCategory = category
        notifyDataSetChanged()
    }
    fun clearSelection() {
        selectedCategory = null
        notifyDataSetChanged()
    }
    fun setCategories(newCategories: List<Category>) {
        categories.clear()
        categories.addAll(newCategories)
        notifyDataSetChanged()
    }

    fun setSelectedCategory(category: Category?) {
        selectedCategory = category
        notifyDataSetChanged()
    }
    fun addCategory(category: Category) {
        categories.add(category)
        notifyItemInserted(categories.size - 1)
    }

    override fun getItemViewType(position: Int): Int {
        return if (position == categories.size) 1 else 0  // 1 = добавить категорию, 0 = существующая категория
    }

    override fun getItemCount() = categories.size + 1  // +1 для кнопки добавить


    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {
        return if (viewType == 1) {
            val view = LayoutInflater.from(parent.context)
                .inflate(R.layout.item_category_add, parent, false)
            AddCategoryViewHolder(view)
        } else {
            val view = LayoutInflater.from(parent.context)
                .inflate(R.layout.item_category, parent, false)
            CategoryViewHolder(view)
        }
    }

    override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
        when (holder) {
            is CategoryViewHolder -> {
                val category = categories[position]
                holder.bind(category, category == selectedCategory)
            }
            is AddCategoryViewHolder -> {
                holder.bind()
            }
        }
    }

    inner class CategoryViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        private val colorView: View = itemView.findViewById(R.id.categoryColorView)
        private val nameTextView: TextView = itemView.findViewById(R.id.categoryNameTextView)

        fun bind(category: Category, isSelected: Boolean) {
            nameTextView.text = category.name

            // Создаём круг с нужным цветом
            val drawable = android.graphics.drawable.GradientDrawable().apply {
                shape = android.graphics.drawable.GradientDrawable.OVAL
                setColor(Color.parseColor(category.color))

                // Если выбрана — добавляем рамку
                if (isSelected) {
                    setStroke(5, Color.parseColor("#6750A4"))
                } else {
                    setStroke(0, Color.TRANSPARENT)
                }
            }

            colorView.background = drawable

            itemView.setOnClickListener {
                if (isSelected) {
                    // Если уже выбрана - отменяем выбор
                    clearSelection()
                    onCategoryClick(Category(name = "", color = ""))
                } else {
                    // Если не выбрана - выбираем
                    selectCategory(category)
                    onCategoryClick(category)
                }
            }
            itemView.setOnLongClickListener {
                onCategoryLongClick(category)
                true
            }
        }
    }
    inner class AddCategoryViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        fun bind() {
            itemView.setOnClickListener {
                onAddNewClick()
            }
        }
    }
}