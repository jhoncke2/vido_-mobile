package com.example.vido

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

class MainActivity: FlutterActivity() {
    private val channelName = "image_reader"
    private val readImageMethodName = "read_image"
    private lateinit var channel: MethodChannel
    private lateinit var readImageText : ImageReader
    val executorService : ExecutorService = Executors.newFixedThreadPool(2)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        readImageText = ImageReader(super.getContext())
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
        channel.setMethodCallHandler{ call, result ->
            if(call.method == readImageMethodName){
                executorService.execute{
                    val text = readImageText.processImageRotating(call.arguments as String, "spa_old")
                    result.success(text)
                }
            }
        }
    }

}
