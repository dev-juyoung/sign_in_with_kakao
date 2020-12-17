package dev.juyoung.sign_in_with_kakao

import android.content.ContentProvider
import android.content.ContentValues
import android.content.pm.PackageManager
import android.database.Cursor
import android.net.Uri
import android.util.Log
import com.kakao.sdk.common.KakaoSdk

class SignInWithKakaoContentProvider : ContentProvider() {
    override fun onCreate(): Boolean {
        try {
            val applicationContext = context!!

            val applicationInfo = applicationContext.packageManager.getApplicationInfo(
                applicationContext.packageName,
                PackageManager.GET_META_DATA
            )

            val bundle = applicationInfo.metaData
            val appKey = bundle.getString("plugin.dev.juyoung.kakao.KakaoAppKey")

            KakaoSdk.init(applicationContext, appKey!!)
        } catch (e: Throwable) {
            Log.e(SignInWithKakaoPlugin.TAG, "카카오SDK 초기화 중 오류가 발생했습니다.")
        }

        return true
    }

    override fun query(
        uri: Uri,
        projection: Array<String>?,
        selection: String?,
        selectionArgs: Array<String>?,
        sortOrder: String?
    ): Cursor? {
        throw UnsupportedOperationException()
    }

    override fun insert(uri: Uri, values: ContentValues?): Uri? {
        throw UnsupportedOperationException()
    }

    override fun update(
        uri: Uri,
        values: ContentValues?,
        selection: String?,
        selectionArgs: Array<String>?
    ): Int {
        throw UnsupportedOperationException()
    }

    override fun delete(uri: Uri, selection: String?, selectionArgs: Array<String>?): Int {
        throw UnsupportedOperationException()
    }

    override fun getType(uri: Uri): String? {
        throw UnsupportedOperationException()
    }
}