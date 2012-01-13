/*
 * Copyright (C) 2008 The Android Open Source Project
 * Copyright (C) 2010-2011 The CyanogenMod Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


#define LOG_NDEBUG 0
#define LOG_TAG "lights"

#include <cutils/log.h>

#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include <pthread.h>

#include <sys/ioctl.h>
#include <sys/types.h>

#include <hardware/lights.h>

/******************************************************************************/

static pthread_once_t g_init = PTHREAD_ONCE_INIT;
static pthread_mutex_t g_lock = PTHREAD_MUTEX_INITIALIZER;
static int g_haveTrackballLight = 0;
static struct light_state_t g_notification;
static struct light_state_t g_battery;
static struct light_state_t g_applied;
static int g_backlight = 255;
static int g_trackball = -1;
static int g_buttons = 0;
static int g_attention = 0;
static int g_wimax = 0;
static int g_caps = 0;
static int g_func = 0;

char const*const TRACKBALL_FILE
        = "/sys/class/leds/jogball-backlight/brightness";

char const*const RED_LED_FILE
        = "/sys/class/leds/red/brightness";

char const*const GREEN_LED_FILE
        = "/sys/class/leds/green/brightness";

char const*const BLUE_LED_FILE
        = "/sys/class/leds/blue/brightness";

char const*const LCD_FILE
        = "/sys/class/backlight/rt9393/brightness";

char const*const RED_FREQ_FILE
        = "/sys/class/leds/red/device/grpfreq";

char const*const RED_PWM_FILE
        = "/sys/class/leds/red/device/grppwm";

char const*const RED_BLINK_FILE
        = "/sys/class/leds/red/blink";

char const*const GREEN_BLINK_FILE
        = "/sys/class/leds/green/blink";

char const*const KEYBOARD_FILE
        = "/sys/class/leds/keyboard-backlight/brightness";

char const*const BUTTON_FILE
        = "/sys/class/leds/button-backlight/brightness";
char const*const BUTTON_DELAYOFF_FILE
        = "/sys/class/leds/button-backlight/delay_off";
char const*const BUTTON_DELAYON_FILE
        = "/sys/class/leds/button-backlight/delay_on";
char const*const BUTTON_TRIGGER_FILE
        = "/sys/class/leds/button-backlight/trigger";
/**
 * device methods
 */

void init_globals(void)
{
    // init the mutex
    pthread_mutex_init(&g_lock, NULL);

    // figure out if we have the trackball LED or not
    g_haveTrackballLight = (access(TRACKBALL_FILE, W_OK) == 0) ? 1 : 0;

}



static int write_str(char const* path, char const * value)
{
    int fd;
    static int already_warned = 0;

    fd = open(path, O_RDWR);
    if (fd >= 0) {
      int amt = write(fd, value, strlen(value));
        close(fd);
        return amt == -1 ? -errno : 0;
    } else {
        if (already_warned == 0) {
            LOGE("write_str failed to open %s\n", path);
            already_warned = 1;
        }
        return -errno;
    }
}



static int write_int(char const* path, int value)
{
    int fd;
    static int already_warned = 0;

    fd = open(path, O_RDWR);
    if (fd >= 0) {
        char buffer[20];
        int bytes = sprintf(buffer, "%d\n", value);
        int amt = write(fd, buffer, bytes);
        close(fd);
        return amt == -1 ? -errno : 0;
    } else {
        if (already_warned == 0) {
            LOGE("write_int failed to open %s\n", path);
            already_warned = 1;
        }
        return -errno;
    }
}

static int swift_kdb_light_off()
{
  LOGV(__func__);
  write_int(BUTTON_FILE,0);
  
  return 0;
}
static int swift_kdb_light_on()
{
 LOGV(__func__);
  write_int(BUTTON_FILE,255); 
  return 0;
}
static int swift_kdb_blink_on(int on_delay,int off_delay)
{

 LOGV(__func__);
 write_int(BUTTON_FILE,255);
 write_str(BUTTON_TRIGGER_FILE,"timer");
 write_int(BUTTON_DELAYON_FILE,on_delay);
 write_int(BUTTON_DELAYOFF_FILE,off_delay);

  return 0;
}
static int swift_kdb_blink_off()
{
  write_str(BUTTON_TRIGGER_FILE,"none");
  return 0;
}

static int
is_lit(struct light_state_t const* state)
{
    return state->color & 0x00ffffff;
}

static int
handle_trackball_light_locked(struct light_device_t* dev)
{
    int mode = g_attention;

    if (mode == 7 && g_backlight) {
        mode = 0;
    }
    LOGV("%s g_backlight = %d, mode = %d, g_attention = %d\n",
        __func__, g_backlight, mode, g_attention);

    // If the value isn't changing, don't set it, because this
    // can reset the timer on the breathing mode, which looks bad.
    if (g_trackball == mode) {
        return 0;
    }

    return write_int(TRACKBALL_FILE, mode);
}

static int
rgb_to_brightness(struct light_state_t const* state)
{
    int color = state->color & 0x00ffffff;
    return ((77*((color>>16)&0x00ff))
            + (150*((color>>8)&0x00ff)) + (29*(color&0x00ff))) >> 8;
}

static int
set_light_backlight(struct light_device_t* dev,
        struct light_state_t const* state)
{
    int err = 0;
    int brightness = rgb_to_brightness(state);

    if (brightness == 0)
      brightness  = 0;
      else if (brightness  < 32)
	brightness = 32;
    

if (brightness == 255 ) 
      brightness = 16;
    else
      brightness = brightness / 16  ;

    pthread_mutex_lock(&g_lock);
    g_backlight = brightness;
    err = write_int(LCD_FILE, (brightness/2));
    if (g_haveTrackballLight) {
        handle_trackball_light_locked(dev);
    }
    pthread_mutex_unlock(&g_lock);
    return err;
}

static int
set_light_keyboard(struct light_device_t* dev,
        struct light_state_t const* state)
{
      int err = 0;
  //  int on = is_lit(state);
  //  pthread_mutex_lock(&g_lock);
  //  err = write_int(KEYBOARD_FILE, on?255:0);
  //  pthread_mutex_unlock(&g_lock);
   return err;
}

static int
set_light_buttons(struct light_device_t* dev,
        struct light_state_t const* state)
{
    int err = 0;
    //int on = is_lit(state);
    // pthread_mutex_lock(&g_lock);
    // g_buttons = on;
    // err = write_int(BUTTON_FILE, on?255:0);
    // pthread_mutex_unlock(&g_lock);
    return err;
}


static int  set_front_light_locked(struct light_device_t* dev,
        struct light_state_t const* state)
{
    int len;
    int alpha, red, green, blue;
    int blink = 0;
    int onMS, offMS;
    unsigned int colorRGB;

    switch (state->flashMode) {
        case LIGHT_FLASH_TIMED:
            onMS = state->flashOnMS;
            offMS = state->flashOffMS;
            break;
        case LIGHT_FLASH_NONE:
        default:
            onMS = 0;
            offMS = 0;
            break;
    }

    colorRGB = state->color;

    LOGV("set_front_light_locked colorRGB=%08X, onMS=%d, offMS=%d\n",
            colorRGB, onMS, offMS);

    red = (colorRGB >> 16) & 0xFF;
    green = (colorRGB >> 8) & 0xFF;
    blue = colorRGB & 0xFF;


    if (red || green)
      {
	swift_kdb_light_on();
      }
    else
      {
	swift_kdb_light_off();
      }

if (onMS > 0 && offMS > 0)
        blink = 1;

    if (blink) {
        if (red || green ) {
	  swift_kdb_blink_on(onMS,offMS);
        }
    }
    else 
      {
      if (red || green)
	{
	  swift_kdb_blink_off();
	}
      } 


    return 0;
}

static void
handle_front_battery_locked(struct light_device_t* dev)
{
    
        g_applied = g_notification;
    set_front_light_locked(dev, &g_applied);
}

static int
set_light_battery(struct light_device_t* dev,
        struct light_state_t const* state)
{
    pthread_mutex_lock(&g_lock);

    g_battery = *state;

    /* LEDs on the Z71 are separate, RED+GREEN != amber */
    if (g_battery.color && g_battery.color == 0xFFFFFF00)
        g_battery.color = 0xFFFF0000;
    if (g_haveTrackballLight) {
        set_front_light_locked(dev, state);
    }
    handle_front_battery_locked(dev);
    pthread_mutex_unlock(&g_lock);
    return 0;
}

static int
set_light_notifications(struct light_device_t* dev,
        struct light_state_t const* state)
{
    pthread_mutex_lock(&g_lock);
    g_notification = *state;
    LOGV("set_light_notifications  color=0x%08x",
             state->color);
    if (g_haveTrackballLight) {
        handle_trackball_light_locked(dev);
    }
    handle_front_battery_locked(dev);
    pthread_mutex_unlock(&g_lock);
    return 0;
}

static int
set_light_attention(struct light_device_t* dev,
        struct light_state_t const* state)
{
    return 0;
}


/** Close the lights device */
static int
close_lights(struct light_device_t *dev)
{
    if (dev) {
        free(dev);
    }
    return 0;
}


/******************************************************************************/

/**
 * module methods
 */

/** Open a new instance of a lights device using name */
static int open_lights(const struct hw_module_t* module, char const* name,
        struct hw_device_t** device)
{
    int (*set_light)(struct light_device_t* dev,
            struct light_state_t const* state);

    if (0 == strcmp(LIGHT_ID_BACKLIGHT, name)) {
        set_light = set_light_backlight;
    }
    else if (0 == strcmp(LIGHT_ID_KEYBOARD, name)) {
        set_light = set_light_keyboard;
    }
    else if (0 == strcmp(LIGHT_ID_BUTTONS, name)) {
        set_light = set_light_buttons;
    }
    else if (0 == strcmp(LIGHT_ID_BATTERY, name)) {
        set_light = set_light_battery;
    }
    else if (0 == strcmp(LIGHT_ID_NOTIFICATIONS, name)) {
        set_light = set_light_notifications;
    }
    else if (0 == strcmp(LIGHT_ID_ATTENTION, name)) {
        set_light = set_light_attention;
    }
    else {
        return -EINVAL;
    }

    pthread_once(&g_init, init_globals);

    struct light_device_t *dev = malloc(sizeof(struct light_device_t));
    memset(dev, 0, sizeof(*dev));

    dev->common.tag = HARDWARE_DEVICE_TAG;
    dev->common.version = 0;
    dev->common.module = (struct hw_module_t*)module;
    dev->common.close = (int (*)(struct hw_device_t*))close_lights;
    dev->set_light = set_light;

    *device = (struct hw_device_t*)dev;
    return 0;
}


static struct hw_module_methods_t lights_module_methods = {
    .open =  open_lights,
};

/*
 * The lights Module
 */
const struct hw_module_t HAL_MODULE_INFO_SYM = {
    .tag = HARDWARE_MODULE_TAG,
    .version_major = 1,
    .version_minor = 0,
    .id = LIGHTS_HARDWARE_MODULE_ID,
    .name = "Swift lights Module",
    .author = "CyanogenMod Project",
    .methods = &lights_module_methods,
};
