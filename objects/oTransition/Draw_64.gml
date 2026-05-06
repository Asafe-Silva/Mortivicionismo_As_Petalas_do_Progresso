live_auto_call

if (alpha > 0) {
    draw_set_alpha(alpha);
    draw_set_color(c_black);
    
    // Using GUI dimensions ensures it covers entire screen correctly (if GUI size matches screen)
    draw_rectangle(0, 0, display_get_gui_width() + 10, display_get_gui_height() + 10, false);
    
    draw_set_alpha(1);
    draw_set_color(c_white);
}
