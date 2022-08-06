package com.example.vido

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Matrix
import android.media.ExifInterface
import com.googlecode.tesseract.android.TessBaseAPI
import java.io.File
import java.io.InputStream

class ImageReader (val context: Context){
    private var tess = TessBaseAPI()
    private var folderTessDataName : String = "tessdata"
    private var pathDir = context.getExternalFilesDir(null).toString()

    init {
        val folder = File(pathDir, folderTessDataName)
        if(!folder.exists()){

            folder.mkdir()
        }
        addFile("eng.traineddata", R.raw.eng)
        addFile("spa.traineddata", R.raw.spa)
        addFile("spa_old.traineddata", R.raw.spa_old)

    }

    private fun addFile(name: String, source: Int){
        val file = File("$pathDir/$folderTessDataName/$name")
        if(!file.exists()){
            val inputStream: InputStream = context.resources.openRawResource(source)
            file.appendBytes(inputStream.readBytes())
            file.createNewFile()
        }
    }

    fun processImage(image: Bitmap, lang: String): String{
        tess.init(pathDir, lang)
        tess.setImage(image)
        return tess.utF8Text
    }

    fun processImageRotating(path: String, lang: String): String{
        val bitmap: Bitmap = BitmapFactory.decodeFile(path)
        val ei = ExifInterface(path)
        val orientation: Int = ei.getAttributeInt(
                ExifInterface.TAG_ORIENTATION,
                ExifInterface.ORIENTATION_UNDEFINED
        )
        var rotatedBitmap: Bitmap? = null
        when (orientation) {
            ExifInterface.ORIENTATION_ROTATE_90 -> rotatedBitmap = rotateImage(bitmap, 90f)
            ExifInterface.ORIENTATION_ROTATE_180 -> rotatedBitmap = rotateImage(bitmap, 180f)
            ExifInterface.ORIENTATION_ROTATE_270 -> rotatedBitmap = rotateImage(bitmap, 270f)
            ExifInterface.ORIENTATION_NORMAL -> rotatedBitmap = bitmap
            else -> rotatedBitmap = bitmap
        }
        tess.init(pathDir, lang)
        tess.setImage(rotatedBitmap)
        return tess.utF8Text
    }

    private fun rotateImage(source: Bitmap, angle: Float): Bitmap? {
        val matrix = Matrix()
        matrix.postRotate(angle)
        return Bitmap.createBitmap(
                source, 0, 0, source.width, source.height,
                matrix, true
        )
    }

    fun processByteArray(array: ByteArray, lang: String): String{
        tess.init(pathDir, lang)
        tess.setImage(array, 300, 500, 1, 1)
        return tess.utF8Text
    }

    fun recycle(){
        tess.recycle()
    }
}