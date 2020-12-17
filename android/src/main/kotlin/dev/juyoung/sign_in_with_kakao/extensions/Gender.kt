package dev.juyoung.sign_in_with_kakao.extensions

import com.kakao.sdk.user.model.Gender

val Gender.rawValue: String?
    get() = when (this) {
        Gender.FEMALE -> "female"
        Gender.MALE -> "male"
        else -> null
    }
