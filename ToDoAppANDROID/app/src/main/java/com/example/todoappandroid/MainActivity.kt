package com.example.todoappandroid

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.navigation.fragment.NavHostFragment
import androidx.navigation.ui.setupWithNavController
import com.google.android.material.bottomnavigation.BottomNavigationView
import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import androidx.activity.result.contract.ActivityResultContracts

class MainActivity : AppCompatActivity() {
    // Запрос разрешения на уведомления
    private val requestNotificationPermission = registerForActivityResult(
        ActivityResultContracts.RequestPermission()
    ) { isGranted ->
        if (isGranted) {
            // Разрешение получено
            android.util.Log.d("MainActivity", "Разрешение на уведомления получено")
        } else {
            // Разрешение не дано
            android.util.Log.d("MainActivity", "Разрешение на уведомления отклонено")
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        InitDatabase.addDefaultCategories(this)

        // Создание канала для уведомлений
        createNotificationChannel()

        // Запрашиваем разрешение на Android 13+
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            requestNotificationPermission.launch(android.Manifest.permission.POST_NOTIFICATIONS)
        }

        val host: NavHostFragment =
            supportFragmentManager.findFragmentById(R.id.navFragment) as NavHostFragment? ?: return
        val navController = host.navController

        val bottomBar = findViewById<BottomNavigationView>(R.id.bottom_nav_menu)
        bottomBar.setupWithNavController(navController)
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "task_channel",
                "Напоминания о задачах",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Уведомления о задачах ToDo"
            }
            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager?.createNotificationChannel(channel)
        }
    }
}
