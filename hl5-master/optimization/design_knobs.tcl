# ============================================================
# EE292A Cadence Flow Knobs
# ============================================================

# -------------------------
# Clock
# -------------------------
# Top-level clock port name in hl5
set CLK_PORT clk

# Clock period in ns
# Example:
#   20.0 ns = 50 MHz
set CLK_PERIOD 20.0

# -------------------------
# Genus synthesis knobs
# -------------------------
# Allowed values are typically: low, medium, high
set SYN_GENERIC_EFFORT medium
set SYN_MAP_EFFORT     medium
set SYN_OPT_EFFORT     medium

# Optional area constraint
# Set to 0 to disable
set MAX_AREA 0

# -------------------------
# Innovus floorplan knobs
# -------------------------
# Aspect ratio for floorplan
set CORE_ASPECT_RATIO 1.0

# Core utilization / density target
set CORE_DENSITY 0.50

# Core margins in microns
set CORE_MARGIN_L 20
set CORE_MARGIN_B 20
set CORE_MARGIN_R 20
set CORE_MARGIN_T 20

# -------------------------
# Innovus flow control
# -------------------------
# 1 = run CTS
# 0 = skip CTS
set RUN_CTS 0
