# Publishing & account setup

## What has already been committed

- [Original GitHub profile README](README.md), legal-tech header SVG and research motion diagram.
- [Responsive interactive portfolio](docs/index.html) with [styles](docs/style.css), [JavaScript](docs/app.js), and a local quality checker.
- [GitHub Actions workflow](.github/workflows/portfolio.yml) that validates the portfolio and deploys once **GitHub Pages is enabled with GitHub Actions**.
- Project-specific README updates throughout the owned repositories.
- Security remediation commits for `atef`, `Legal-management-666`, and `SmartLawyer` (current-tree .env / signing-key removals). Historic exposure and credential rotation remain separate tasks.

## Profile publication status — completed

The user-created **public** special repository [`matef-hub/matef-hub`](https://github.com/matef-hub/matef-hub) now exists. The complete bilingual profile README and both animated original SVG illustrations were copied directly into the matching repository and verified on its default `main` branch.

**No further README creation or copying is required.** The remaining browser-only optional steps are updating GitHub's public About/Bio, selecting profile pins and enabling GitHub Pages for the interactive site in `matef-hub/atefdodo`. This connected integration supports file changes but does not expose the necessary profile or Pages administration actions.

## Optional — Windows setup script for profile metadata and Pages (not needed for README)

1. Clone this repository or pull its latest changes.
2. Install [GitHub CLI](https://cli.github.com/), run `gh auth login` and authenticate as `matef-hub` with repository and profile write permission.
3. In PowerShell 7, from the repository folder, execute:

```powershell
pwsh -File .\scripts\complete-profile-setup.ps1
```

The script validates the connected login, creates the special public profile repo only if missing, publishes the prepared README, updates the six project's descriptions and topics, edits your professional bio and tries to enable/deploy the portfolio via GitHub Pages. It does not touch private repositories or rotate secrets.

**Pinned items still require GitHub's UI** — public GitHub APIs do not currently expose a supported mutation to change user pinned repositories.

## Finish remaining display settings from GitHub mobile

1. Visit **[Profile](https://github.com/matef-hub) → Edit profile**; set the professional bio and `https://ateflaw.com/` website.
2. For [this portfolio repo](https://github.com/matef-hub/atefdodo), choose **Settings → Pages → Source = GitHub Actions**. Then run [Portfolio validation and GitHub Pages](https://github.com/matef-hub/atefdodo/actions) or push a file update.
3. On your profile choose **Customize your pins** and select the six projects below.

## Suggested professional bio

`Egyptian lawyer building legal research, judicial workflows and AI-assisted legal systems | Arabic NLP · Android · Laravel`

## Recommended six pins

1. [ahkam-app](https://github.com/matef-hub/ahkam-app)
2. [agenda](https://github.com/matef-hub/agenda)
3. [Egyptian-Legal-Deadlines-Calculator](https://github.com/matef-hub/Egyptian-Legal-Deadlines-Calculator)
4. [SmartLawyer](https://github.com/matef-hub/SmartLawyer)
5. [Legal-management-666](https://github.com/matef-hub/Legal-management-666)
6. [smart-lawyer-ai-training](https://github.com/matef-hub/smart-lawyer-ai-training)

## Security and transparency

- Verify any active credentials historically tracked in the public repositories, and rotate as needed. File deletion from current HEAD does not purge Git history.
- Treat app signing keys according to Android/Google Play key-rotation policies.
- Validate any genuine application screenshots before showing them as shipped UI; the portfolio currently uses clearly identified **original illustrative diagrams**.
- [Ahkam's public MIT license](https://github.com/matef-hub/ahkam-app/blob/main/LICENSE) requires a licensing/security review before changing the commercial distribution strategy.
- Neither static design nor README changes guarantee server-side authorization, production security or a live deployment.
