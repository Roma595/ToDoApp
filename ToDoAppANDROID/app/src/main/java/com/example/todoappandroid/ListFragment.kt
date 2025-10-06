package com.example.todoappandroid

import android.os.Bundle
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.fragment.app.Fragment
import com.example.todoappandroid.AddTaskFragment
import android.widget.Button
import com.example.todoappandroid.R

class ListFragment : Fragment() {
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val textView = TextView(context).apply {
            text = "скоро здесь будет список"
            gravity = Gravity.CENTER
            textSize = 20f
        }
        return textView
    }
}

