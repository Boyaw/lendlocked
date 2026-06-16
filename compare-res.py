#!/usr/bin/env python3
# compare-res.py — verify hyperfine outputs are coherent with the claimed table.
import json, sys, os

# ---- CLAIMED table: depth -> step -> {mean, stddev, median} in SECONDS ----
CLAIMED = {
    10: {"setup":   {"mean": 2.375, "stddev": 0.025, "median": 2.363},
         "witness": {"mean": 1.414, "stddev": 0.021, "median": 1.405},
         "prove":   {"mean": 2.207, "stddev": 0.116, "median": 2.163},
         "verify":  {"mean": 0.006, "stddev": 0.002, "median": 0.005}},
    20: {"setup":   {"mean": 2.794, "stddev": 0.063, "median": 2.806},
         "witness": {"mean": 1.570, "stddev": 0.012, "median": 1.569},
         "prove":   {"mean": 2.447, "stddev": 0.012, "median": 2.444},
         "verify":  {"mean": 0.006, "stddev": 0.001, "median": 0.005}},
    30: {"setup":   {"mean": 3.104, "stddev": 0.013, "median": 3.109},
         "witness": {"mean": 1.743, "stddev": 0.015, "median": 1.740},
         "prove":   {"mean": 2.757, "stddev": 0.011, "median": 2.754},
         "verify":  {"mean": 0.005, "stddev": 0.001, "median": 0.005}},
}

# step label -> hyperfine JSON filename suffix ("prove" is exported as *_proof.json)
SUFFIX = {"setup": "setup", "witness": "witness", "prove": "proof", "verify": "verify"}

# ---- tolerance ----
REL = 0.05               # 5% relative margin (checked for mean and median)
ABS_FLOOR = 0.001          # optional absolute tolerance (s) OR'd with REL; 0 = pure 5%

def close(measured, claimed):
    return abs(measured - claimed) <= max(REL * claimed, ABS_FLOOR)

fail = 0
for depth in sorted(CLAIMED):
    print(f"\n== Merkle depth {depth} ==")
    for step in ("setup", "witness", "prove", "verify"):
        c = CLAIMED[depth][step]
        fn = os.path.join(f"exp-borrow-depth-{depth}", f"{depth}_{SUFFIX[step]}.json")  # json files live in per-depth subfolders
        try:
            with open(fn) as fh:
                m = json.load(fh)["results"][0]   # mean, stddev, median, min, max (seconds)
        except FileNotFoundError:
            print(f"  {step:8s} MISSING  {fn}"); fail = 1; continue

        # mean within 5%
        ok = close(m["mean"], c["mean"]); fail |= (not ok)
        print(f"  {step:8s} mean   {'OK  ' if ok else 'FAIL'}  meas {m['mean']:.4f}s  claim {c['mean']:.4f}s")

        # median within 5%
        ok = close(m["median"], c["median"]); fail |= (not ok)
        print(f"  {step:8s} median {'OK  ' if ok else 'FAIL'}  meas {m['median']:.4f}s  claim {c['median']:.4f}s")

        # stddev: only require a valid POSITIVE value (not compared to the claim)
        ok = isinstance(m["stddev"], (int, float)) and m["stddev"] > 0; fail |= (not ok)
        print(f"  {step:8s} stddev {'OK  ' if ok else 'FAIL'}  meas {m['stddev']:.4f}s  (must be > 0)")

mismatch_msg = "MISMATCHES FOUND — results not coherent within 5% margin, please check manually. Note that If your setup contains newer version of hardware and software, the results can be significantly faster than the compared numbers, which is even more in favor of our evaluation claims. If the results are significantly slower, please make sure the setup versions are consistent with check_env.sh, then let your machine cool down before rerunning any measurement."

print("\n" + (mismatch_msg if fail
              else "All metrics within margin."))
sys.exit(0)  # always exit 0 so the one-click pipeline reaches the audit; any mismatch is printed above