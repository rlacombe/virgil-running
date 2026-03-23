---
description: "Post-workout analysis — compare planned vs actual for most recent activity"
user-invocable: true
---

# /review — Post-Workout Analysis

1. Get today's date
2. Fetch in parallel:
   - `get_activities` for the last 3 days (to find the most recent)
   - `get_events` for the last 3 days (to find matching planned workout)
3. Identify the most recent activity and fetch its details with `get_activity` (with intervals)
4. Display:
   - **Workout Summary:** Name, type, date
   - **Planned vs Actual table:**
     | Metric | Planned | Actual | Diff |
     |--------|---------|--------|------|
     | Distance (mi) | | | |
     | Duration | | | |
     | Avg Pace (min/mi) | | | |
     | Elevation (ft) | | | |
   - **Heart Rate:** Avg, max, time in zones (if available)
   - **Cadence:** Avg (if available)
   - **Intervals/Laps:** Key splits if interval data exists
   - **Training Load:** load/TSS from the activity
5. If the activity warrants deeper analysis (tempo runs, intervals, long runs over 2 hours), use `get_activity_streams` to examine:
   - **Pace drift:** Compare first-half vs second-half average pace from `velocity_smooth`
   - **HR decoupling:** Compare pace:HR ratio in first half vs second half (decoupling > 5% suggests aerobic ceiling was reached)
   - **Elevation profile:** Correlate altitude changes with pace/HR to assess climbing efficiency
   Only fetch streams when the analysis would add value — not for every easy run.
6. Flag any planned-vs-actual deviations > 10%
7. One-line coaching note on the workout execution
