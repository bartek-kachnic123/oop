package com.example.demo

import org.springframework.stereotype.Service

@Service
class AuthService {

    private val users = mapOf(
        "magda1" to "123",
        "jan10" to "123",
        "piotr110" to "123"
    )

    fun authenticate(username: String, password: String): Boolean {
        return users[username] == password
    }
}

