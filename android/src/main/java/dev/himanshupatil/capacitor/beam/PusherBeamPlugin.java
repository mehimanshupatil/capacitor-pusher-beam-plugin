package dev.himanshupatil.capacitor.beam;

import android.util.Log;

public class PusherBeamPlugin {

    public String echo(String value) {
        Log.i("Echo", value);
        return value;
    }
}
