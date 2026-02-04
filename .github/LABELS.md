Repository labels for Gårdsbutikker submissions
===============================================

This file documents the labels used for the Gårdsbutikker (farm shops) submission flow.

- `create-data-pr` (color: ffcc00)
  - Purpose: When a maintainer adds this label to an issue, the Issue→PR workflow will create a pull request that adds the submitted data JSON to `docs/data/submissions/`.
  - How to use (web): open the issue, click "Labels" and select `create-data-pr`.
  - How to use (CLI):
    ```bash
    gh issue edit <ISSUE_NUMBER> --add-label create-data-pr
    ```

- `data-submission` (color: 0e8a16)
  - Purpose: Marks an issue as a content/data submission (informational). Use this for incoming submissions that need triage.
  - How to use (web): select the label in the issue UI.

Maintainer workflow (recommended)
---------------------------------
1. Review the incoming issue using the `.github/ISSUE_TEMPLATE/farmshop_submission.md` template.
2. If the submission is valid and you want the workflow to create a PR, add the `create-data-pr` label. The workflow will run and open a PR containing the submission JSON under `docs/data/submissions/`.
3. Review the created PR, run any local checks or tests, and either merge or request changes. The PR is intended to be reviewed like any other code/data change.

Notes & troubleshooting
----------------------
- The workflow uses the repository's Actions token to create PRs; if a submission PR is not created after labeling, check the Actions run for errors and that the `create-data-pr` label exists.
- You can always create or edit the PR manually using the branch created by the workflow or by opening the compare page for the labeled branch.

Example: open the compare page the workflow will use (replace branch name if needed):
```
https://github.com/Einars-Apps/Matsjekk/compare/main...feature/gardsbutikker-issue-submissions
```

If you need this behavior changed (e.g., auto-merge, different target folder), edit `.github/workflows/issue-to-pr.yml` and coordinate with the maintainers.

Thanks — this keeps submissions reviewable and auditable.
