/// @description 
// Simple debug toggle - kept for legacy support if needed, but cleaned up
if (keyboard_check(vk_tab)) {
    draw_set_color(c_white);
    draw_text(12, 100 - 64, "State: " + (isMoving ? "Moving" : "Idle"));
    draw_text(12, 100 - 48, "Facing: " + string(facingDirection));
    draw_text(12, 100 - 32, "Input: " + string(inputDirection));
}
	