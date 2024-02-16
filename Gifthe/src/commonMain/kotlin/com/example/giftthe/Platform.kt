package com.example.giftthe

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform