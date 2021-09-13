import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
abstract class AppsChangeListener {
    abstract fun onAppChange(info: String, packageName: String);
}

class AppsChangeBroadcastReceiver : BroadcastReceiver() {

    private lateinit var callback: AppsChangeListener

    fun setListener(functionTo: AppsChangeListener) {
        this.callback = functionTo;
    }

    override fun onReceive(context: Context?, intent: Intent?) {

        val packageName: String = intent?.data.toString()
            Log.i("appchange", packageName)
            when(intent?.action){
                Intent.ACTION_PACKAGE_ADDED->{
                    callback.onAppChange("added",packageName)
                }
                Intent.ACTION_PACKAGE_REMOVED->{
                    callback.onAppChange("removed",packageName)
                }
            }

    }
}