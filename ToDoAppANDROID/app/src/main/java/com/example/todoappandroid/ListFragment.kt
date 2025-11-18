package com.example.todoappandroid
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.button.MaterialButton

class ListFragment : Fragment() {

    private lateinit var recyclerView: RecyclerView
    private lateinit var createTaskButton: MaterialButton

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_list, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        // Получаем элементы из макета
        recyclerView = view.findViewById(R.id.recyclerView)
        createTaskButton = view.findViewById(R.id.createTaskButton)

        // ========== ОБРАБОТКА КЛИКА НА КНОПКУ ==========
        createTaskButton.setOnClickListener {
            // Переходим на CreateTaskFragment
            findNavController().navigate(
                R.id.action_listFragment_to_createTaskFragment
            )
        }

        // TODO: Инициализация адаптера и данных
    }
}