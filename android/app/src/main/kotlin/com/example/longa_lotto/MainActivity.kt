package com.example.longa_lotto

import io.flutter.embedding.android.FlutterActivity
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.util.Log
import android.widget.Toast
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import android.provider.Settings

class MainActivity: FlutterActivity() {

    private val CHANNEL = "com.example.longa_lotto/loader_inner_bg"
    private lateinit var channel: MethodChannel

    lateinit var downloadController: DownloadController

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        channel.setMethodCallHandler { call, result ->

            val argument = call.arguments!! as Map<*, *>;
            val downloadUrl = argument["url"]
            downloadController = DownloadController(this, downloadUrl.toString())

            if (call.method == "_downloadUpdatedAPK") {
                Log.d("TaG", "url----->$downloadUrl")

                /*if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

                    Log.d("TAG", "11111111111111111")
                    if (!packageManager.canRequestPackageInstalls()) {
                        startActivityForResult(

                            Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES)
                                .setData(Uri.parse(String.format("package:%s", packageName))), 1
                        )
                    }
                }
                    //Storage Permission

                    //Storage Permission
                if (ContextCompat.checkSelfPermission(
                        this,
                        Manifest.permission.READ_EXTERNAL_STORAGE
                    ) != PackageManager.PERMISSION_GRANTED
                ) {
                    ActivityCompat.requestPermissions(
                        this,
                        arrayOf(
                            Manifest.permission.WRITE_EXTERNAL_STORAGE,
                            Manifest.permission.READ_EXTERNAL_STORAGE
                        ),
                        1
                    )
                }

                if (ContextCompat.checkSelfPermission(
                        this,
                        Manifest.permission.WRITE_EXTERNAL_STORAGE
                    ) != PackageManager.PERMISSION_GRANTED
                ) {
                    ActivityCompat.requestPermissions(
                        this,
                        arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE),
                        1
                    )
                }*/


                /*if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

                    Log.d("TAG", "permission")
                    if (!packageManager.canRequestPackageInstalls()) {
                        startActivityForResult(

                            Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES).setData(Uri.parse(String.format("package:%s", packageName))), 1
                        )
                    }
                }*/

                downloadController.enqueueDownload()
            }
        }
    }

    /*override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        Log.d("TaG", "onRequestPermissionsResult---->$requestCode")
        if (requestCode == 0) {
            // Request for camera permission.
            Log.d("TaG", "333333333333333---${grantResults}")
            if (grantResults.size == 1 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // start downloading
                Log.d("TaG", "<----- granted ---->")
                downloadController.enqueueDownload()

            } else {
                // Permission request was denied.
                Toast.makeText(context, "Permission Denied", Toast.LENGTH_LONG).show()
            }
        }
    }*/
}
