package dev.juyoung.sign_in_with_kakao.extensions

import com.kakao.sdk.common.model.ApiErrorCause

val ApiErrorCause.rawValue: String
    get() = when (this) {
        ApiErrorCause.Unknown -> "unknown"
        ApiErrorCause.InternalError -> "internal"
        ApiErrorCause.IllegalParams -> "bad_parameter"
        ApiErrorCause.UnsupportedApi -> "unsupported_api"
        ApiErrorCause.BlockedAction -> "blocked"
        ApiErrorCause.PermissionDenied -> "permission"
        ApiErrorCause.DeprecatedApi -> "deprecated_api"
        ApiErrorCause.ApiLimitExceeded -> "api_limit_exceed"
        ApiErrorCause.NotRegisteredUser -> "not_signed_up_user"
        ApiErrorCause.AlreadyRegisteredUser -> "already_signed_up_usercase"
        ApiErrorCause.AccountDoesNotExist -> "not_kakao_account_user"
        ApiErrorCause.PropertyKeyDoesNotExist -> "invalid_user_property_key"
        ApiErrorCause.AppDoesNotExist -> "no_such_app"
        ApiErrorCause.InvalidToken -> "invalid_access_token"
        ApiErrorCause.InsufficientScope -> "insufficient_scope"
        ApiErrorCause.UnderAgeLimit -> "lower_age_limit"
        ApiErrorCause.NotTalkUser -> "not_talk_user"
        // ApiErrorCause.NotFriend -> ""
        ApiErrorCause.UserDeviceUnsupported -> "user_deviced_unsupported"
        ApiErrorCause.TalkMessageDisabled -> "talk_message_disabled"
        ApiErrorCause.TalkSendMessageMonthlyLimitExceed -> "talk_send_message_monthly_limit_exceed"
        ApiErrorCause.TalkSendMessageDailyLimitExceed -> "talk_send_message_daily_limit_exceed"
        ApiErrorCause.NotStoryUser -> "not_story_user"
        ApiErrorCause.StoryImageUploadSizeExceeded -> "story_image_upload_size_exceed"
        ApiErrorCause.TimeOut -> "story_upload_timeout"
        ApiErrorCause.StoryInvalidScrapUrl -> "story_invalid_scrap_url"
        ApiErrorCause.StoryInvalidPostId -> "story_invalid_post_id"
        ApiErrorCause.StoryMaxUploadCountExceed -> "story_max_upload_number_exceed"
        ApiErrorCause.DeveloperDoesNotExist -> "unknown"
        ApiErrorCause.UnderMaintenance -> "under_maintenance"
        else -> "unknown"
    }
