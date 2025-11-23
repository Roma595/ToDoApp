package com.example.todoappandroid

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.navigation.fragment.NavHostFragment
import androidx.navigation.ui.setupWithNavController
import com.google.android.material.bottomnavigation.BottomNavigationView

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        InitDatabase.addDefaultCategories(this)

        val host: NavHostFragment = supportFragmentManager.findFragmentById(R.id.navFragment) as NavHostFragment? ?: return
        val navController = host.navController

        val bottomBar = findViewById<BottomNavigationView>(R.id.bottom_nav_menu)
        bottomBar.setupWithNavController(navController)
    }
}
