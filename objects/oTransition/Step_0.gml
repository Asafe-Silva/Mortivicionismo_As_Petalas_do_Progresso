live_auto_call

if (state == 1) { // Fade Out (screen gets dark)
    alpha += fade_speed;
    if (alpha >= 1) {
        alpha = 1;
        state = 2; // Switch to Fade In
        if (room_exists(target_room)) {
            room_goto(target_room);
        }
    }
} else if (state == 2) { // Fade In (screen gets bright)
    alpha -= fade_speed;
    if (alpha <= 0) {
        alpha = 0;
        instance_destroy(); // Destroy transition object once complete
    }
}
