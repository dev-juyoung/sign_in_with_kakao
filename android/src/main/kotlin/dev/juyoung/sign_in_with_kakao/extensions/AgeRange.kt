package dev.juyoung.sign_in_with_kakao.extensions

import com.kakao.sdk.user.model.AgeRange

val AgeRange.rawValue: String?
    get() = when (this) {
        AgeRange.AGE_0_9 -> "0~9"
        AgeRange.AGE_10_14 -> "10~14"
        AgeRange.AGE_15_19 -> "15~19"
        AgeRange.AGE_20_29 -> "20~29"
        AgeRange.AGE_30_39 -> "30~39"
        AgeRange.AGE_40_49 -> "40~49"
        AgeRange.AGE_50_59 -> "50~59"
        AgeRange.AGE_60_69 -> "60~69"
        AgeRange.AGE_70_79 -> "70~79"
        AgeRange.AGE_80_89 -> "80~89"
        AgeRange.AGE_90_ABOVE -> "90~"
        else -> null
    }
