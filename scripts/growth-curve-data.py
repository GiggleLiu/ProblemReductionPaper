#!/usr/bin/env python3
"""Mine weekly growth of problem types and reduction rules from git history.

Samples the problem-reductions submodule at the last commit of each week,
counting .rs files in src/models/ and src/rules/ (excluding mod.rs and
infrastructure files).

Output: JSON array of {week, date, models, rules} objects to stdout.

Usage:
    python scripts/growth-curve-data.py > data/growth-curve.json
"""

import json
import subprocess
from collections import OrderedDict
from datetime import datetime, timedelta
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent / "problem-reductions"

RULE_EXCLUDE = {"src/rules/mod.rs", "src/rules/analysis.rs", "src/rules/cost.rs"}


def git(*args: str) -> str:
    result = subprocess.run(
        ["git", *args], capture_output=True, text=True, cwd=REPO
    )
    return result.stdout.strip()


def get_weekly_commits() -> OrderedDict:
    """Return {week_start_date: last_commit_sha} for each week."""
    lines = git("log", "--format=%H %ai", "--reverse")
    weekly: OrderedDict[str, tuple[str, str]] = OrderedDict()
    for line in lines.split("\n"):
        parts = line.split()
        sha, date_str = parts[0], parts[1]
        d = datetime.strptime(date_str, "%Y-%m-%d")
        week_start = d - timedelta(days=d.weekday())
        week_key = week_start.strftime("%Y-%m-%d")
        weekly[week_key] = (sha, date_str)
    return weekly


def count_files_at(sha: str, prefix: str, exclude: set[str]) -> int:
    """Count .rs files under prefix at a given commit, excluding specific paths."""
    output = git("ls-tree", "-r", "--name-only", sha, "--", prefix)
    if not output:
        return 0
    files = [
        f
        for f in output.split("\n")
        if f.endswith(".rs") and f not in exclude and "mod.rs" not in f and "test" not in f.lower()
    ]
    return len(files)


def main() -> None:
    weekly = get_weekly_commits()
    first_week = list(weekly.keys())[0]
    first_date = datetime.strptime(first_week, "%Y-%m-%d")

    data = []
    for week_key, (sha, _date) in weekly.items():
        week_date = datetime.strptime(week_key, "%Y-%m-%d")
        week_index = (week_date - first_date).days / 7

        models = count_files_at(sha, "src/models/", set())
        rules = count_files_at(sha, "src/rules/", RULE_EXCLUDE)

        data.append({
            "week": round(week_index),
            "date": week_key,
            "models": models,
            "rules": rules,
        })

    print(json.dumps(data, indent=2))


if __name__ == "__main__":
    main()
