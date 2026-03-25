---
description: "Morning briefing — today's planned workout, wellness, and fitness status"
user-invocable: true
---

# /today — Morning Briefing

1. Get today's date. Read `knowledge/recovery-overtraining.md` for overtraining warning signs and `knowledge/workout-types.md` for workout execution guidance.
2. Fetch in parallel:
   - `get_events` for today through end of week (oldest=today, newest=Sunday) — today's workout plus upcoming schedule for context
   - `get_wellness` for the last 3 days (oldest=today-2, newest=today) — trend context, not just a snapshot
   - `get_fitness` for the last 7 days to show trend
   - `get_athlete` for zone context (HR, pace, power zones)
3. Display:
   - **Today's Workout:** Name, type, planned distance/duration. If the workout has structured steps, show target zones/paces using the athlete's actual zone values. If rest day, say so.
   - **Coming Up:** Brief preview of the next 2-3 planned sessions (name, day, type) so the athlete sees where today fits in the week.
   - **Wellness:** Sleep, HRV, resting HR, fatigue, mood (whatever is available)
   - **Form Status:** Current TSB with label (fresh/neutral/tired/fatigued)
   - **CTL/ATL:** Current values and 7-day trend direction
4. End with a one-line recommendation grounded in the knowledge base (e.g., reference workout purpose from `knowledge/workout-types.md`, or flag recovery concerns per `knowledge/recovery-overtraining.md`)
5. Flag any injury risk signals (volume spike, sustained negative TSB, poor sleep) using criteria from `knowledge/injury-prevention.md`
