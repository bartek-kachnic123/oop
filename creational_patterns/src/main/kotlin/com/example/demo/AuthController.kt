package com.example.demo

import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api")
class AuthController(private val authService: AuthService) {

    companion object {
        val USERS = listOf(
            "Joanna",
            "Magda",
            "Piotr",
            "Darek",
            "Marek"
        )
    }

    data class LoginRequest(val username: String, val password: String)

    @GetMapping("/users")
    fun getUsers(): List<String> {
        return USERS
    }

    @PostMapping("/login")
    fun login(@RequestBody request: LoginRequest): Map<String, Boolean> {
        val result = authService.authenticate(request.username, request.password)
        return mapOf("authenticated" to result)
    }
}

