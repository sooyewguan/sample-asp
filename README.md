# e-Cuti: legacy classic ASP module for training

e-Cuti is a small staff leave application system written in classic ASP with a SQL Server database. It is the legacy ASP Application of the AI-Driven Software Development Workshop, where participants migrate it to ASP.NET Core Web API and React.

The system is invented for training. No code or data comes from a real system. Every person, identity number and password in the database is made up. The code holds deliberate defects and security weaknesses for participants to find. Do not use it for real work.

## Contents

| Path | Contents |
| --- | --- |
| `legacy/` | 14 `.asp` pages, 5 include files in `inc/`, `global.asa`, `misc.js`, `Loader/d_loader.js`, `css/style.css` |
| `database/ecuti_db.sql` | Creates database `LegacyDb` with 7 tables, 1 stored procedure and the seed rows |
| `.claude/skills/` | The 14 Matt Pocock skills the workshop uses, copied from [mattpocock/skills](https://github.com/mattpocock/skills) at commit `4ae2317` under its MIT licence. `grilling` has the workshop's one-question line added at the end |
| `.claude/settings.json` | A deny rule that stops Claude from editing `legacy/` |
| `CLAUDE.md`, `docs/agents/` | What `/setup-matt-pocock-skills` writes: GitHub issues as the tracker, the five default triage labels, one `GLOSSARY.md` |

The migrated application goes into this same repository: the ASP.NET Core API in `server/` and the React app in `client/`.

## Getting your own copy

In a Code tab session in a new, empty folder:

```text
Clone https://github.com/sooyewguan/sample-asp directly into this folder, not into a subfolder. Then remove the remote that points to sooyewguan/day2, create a private GitHub repository named day2 under my account from this folder, add it as the origin remote and push. Create the triage labels listed in docs/agents/triage-labels.md in that repository.
```

## Database setup

The script runs on the Day 1 container `sql-workshop`, which is SQL Server 2025 Express, the free edition. It creates `LegacyDb` if it does not exist, and drops and recreates the e-Cuti objects if it does.

In a Code tab session, with this repository as the project folder:

```text
Run database/ecuti_db.sql in sql-workshop as sa, with the password in WS_SQL_SA_PASSWORD, to create database LegacyDb. In LegacyDb make workshop_app db_owner, and give workshop_mcp read-only access and VIEW DEFINITION on schema dbo. Don't print the passwords.
```

Expected row counts:

| Table | Rows |
| --- | --- |
| tblJabatan | 3 |
| tblStaf | 12 |
| tblJenisCuti | 5 |
| tblCutiUmum | 30 |
| tblBakiCuti | 52 |
| tblPermohonanCuti | 80 |
| tblAuditLog | 312 |

## Running the legacy pages

Classic ASP runs only on IIS on Windows. The connection string is in `legacy/inc/conn.asp`, with the placeholder `TUKAR_KATA_LALUAN_DI_SINI` where the password of `workshop_app` goes. Do not commit a real password.

The pages connect with the provider `SQLOLEDB`, which is built into Windows. A first run on IIS on 10 November 2026 confirmed that this provider connects to SQL Server 2025 Express in `sql-workshop`: the login, Senarai Permohonan and Mohon Cuti pages loaded. The other pages are still being checked, see the issues. A setup script for IIS is not part of this repository yet.

## Test logins

| No. Staf | Role | Password |
| --- | --- | --- |
| S1004 | Staff | latihan123 |
| S1007 | Staff | latihan123 |
| S1001 | Supervisor | latihan123 |
| S1002 | Supervisor | latihan123 |
| S1000 | Administrator | admin123 |

The seed data assumes the date is between 10 and 19 November 2026.
