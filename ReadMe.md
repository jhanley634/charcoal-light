
This repo supports performance testing for SE SmokeDetector regexes.
It avoids storing 1.3 Gig of SmokeDetector's git history,
and shows the path to transitioning SmokeDetector code and/or data
to a new, smaller repo.

# quickstart

```bash
make install  # downloads pip deps, and also SmokeDetector if it's missing
```
At the end we'll have this repo and a SmokeDetector repo in the same directory,
as siblings.
A new venv virtual environment will be created in your home directory if necessary.

```bash
make test  # performs a timed run of > 100 regexes
```
