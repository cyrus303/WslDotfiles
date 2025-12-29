return {
  "sphamba/smear-cursor.nvim",
  event = "VeryLazy",
  opts = {
    hide_target_hack = true,
    cursor_color = "none",

    -- Moderate balanced config
    stiffness = 0.85, -- Balanced snap
    trailing_stiffness = 0.75, -- Smooth trail following
    stiffness_insert_mode = 0.82, -- Slightly softer in insert
    trailing_stiffness_insert_mode = 0.75, -- Same trail in insert
    damping = 0.92, -- Gentle settling
    damping_insert_mode = 0.92, -- Same for insert
    distance_stop_animating = 0.35, -- Moderate trail fade
  },
  specs = {
    { "nvim-mini/mini.animate", optional = true, opts = { cursor = { enable = false } } },
  },
}
