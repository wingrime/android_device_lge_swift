package com.cyanogenmod.swiftparts;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.os.SystemProperties;
import android.preference.ListPreference;
import android.preference.Preference;
import android.preference.Preference.OnPreferenceChangeListener;
import android.preference.PreferenceActivity;
import android.preference.PreferenceCategory;
import android.text.TextUtils;
import android.util.Log;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class SettingsActivity extends PreferenceActivity implements OnPreferenceChangeListener {
    private static final String TAG = "SwiftParts";

    private PreferenceCategory generalSettings;
    private ListPreference chargeLedModePref;
    private ListPreference touchPointsPref;

    private static final String PROP_CHARGE_LED_MODE = "persist.sys.keyboard_led";	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        addPreferencesFromResource(R.xml.settings);

        generalSettings = (PreferenceCategory) getPreferenceScreen().findPreference("general");
        chargeLedModePref = (ListPreference) generalSettings.findPreference("charge_led_mode");
        chargeLedModePref.setOnPreferenceChangeListener(this);
    }

    @Override
    public void onResume() {
        super.onResume();

        chargeLedModePref.setValue(SystemProperties.get(PROP_CHARGE_LED_MODE));
    }

    @Override
    public boolean onPreferenceChange(Preference preference, Object newValue) {
        if (preference == chargeLedModePref) {
            SystemProperties.set(PROP_CHARGE_LED_MODE, (String) newValue);
            /* make NotificationManagerService update the LED, so the new setting takes effect */
            sendBroadcast(new Intent("com.android.server.NotificationManagerService.UPDATE_LED"));
        } else if (preference == touchPointsPref) {
            final String value = (String) newValue;
            final String oldValue = touchPointsPref.getValue();
            final CharSequence defaultValue = touchPointsPref.getEntryValues()[0];


        }

        return true;
    }
}
