# e-Cuti: legacy classic ASP module for training

e-Cuti is a small staff leave application system written in classic ASP with a SQL Server database. It is the legacy ASP Application of the AI-Driven Software Development Workshop, where participants migrate it to ASP.NET Core Web API and React.

The system is invented for training. No code or data comes from a real system. Every person, identity number and password in the database is made up. The code holds deliberate defects and security weaknesses for participants to find. Do not use it for real work.

## Contents

| Path | Contents |
| --- | --- |
| `legacy/` | 14 `.asp` pages, 5 include files in `inc/`, `global.asa`, `misc.js`, `Loader/d_loader.js`, `css/style.css` |
| `database/ecuti_db.sql` | Creates database `LegacyDb` with 7 tables, 1 stored procedure and the seed rows |
| `CLAUDE.md`, `docs/agents/` | What `/setup-matt-pocock-skills` writes: GitHub issues as the tracker, the five default triage labels, one `GLOSSARY.md` |

The migrated application goes into this same repository: the ASP.NET Core API in `server/` and the React app in `client/`.

## Getting your own copy

Each participant works in a private copy, not a fork: a fork of this public repository would be public too. The project folder is the folder of the Code tab environment, for example an empty `ecuti` folder in Documents, and the copy goes straight into it.

In a Code tab session started from that environment:

```text
Clone https://github.com/sooyewguan/sample-asp directly into this folder, not into a subfolder. Then remove the remote that points to sample-asp, create a private GitHub repository named sample-asp under my account from this folder, add it as the origin remote and push. Create the triage labels listed in docs/agents/triage-labels.md in that repository.
```

## Database setup

The script runs on the Day 1 container `sql-workshop`, which is SQL Server 2025 Express, the free edition. It creates `LegacyDb` if it does not exist, and drops and recreates the e-Cuti objects if it does. The passwords come from the environment variables `WS_SQL_SA_PASSWORD`, `WS_SQL_APP_PASSWORD` and `WS_SQL_MCP_PASSWORD` saved in the Code tab environment.

In a Code tab session, with this repository as the project folder:

```text
In sql-workshop, create two logins: workshop_app with the password in WS_SQL_APP_PASSWORD, and workshop_mcp with the password in WS_SQL_MCP_PASSWORD. Then run database/ecuti_db.sql as sa, with the password in WS_SQL_SA_PASSWORD, to create database LegacyDb. In LegacyDb make workshop_app db_owner, and give workshop_mcp read-only access and VIEW DEFINITION on schema dbo. Don't print the passwords.
```

| Login | Used by |
| --- | --- |
| `workshop_app` | EF Core, the migrated app, and legacy e-Cuti on IIS |
| `workshop_mcp` | SQL MCP Server: reads rows and table definitions, and cannot change anything |

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

Classic ASP runs only on IIS on Windows. The connection string is in `legacy/inc/conn.asp`, with the placeholder `TUKAR_KATA_LALUAN_DI_SINI` where the password of `workshop_app` goes. IIS can't read the Code tab's environment variables, so the password has to be in `conn.asp`. To keep it out of git, IIS serves a copy of `legacy/` from `C:\inetpub\ecuti`, and only that copy holds the password. `legacy/inc/conn.asp` in this repository keeps the placeholder: never put a real password in it.

In a Code tab session, with this repository as the project folder:

```text
Set up legacy e-Cuti on IIS at http://localhost:8080. Serve a copy of legacy/ from C:\inetpub\ecuti, with the workshop_app password from WS_SQL_APP_PASSWORD in the copy's conn.asp. Don't change anything in this project or print the password. Ask me to approve any step that needs administrator rights.
```

Approve each Windows administrator prompt. Then open `http://localhost:8080` and log in with a test login below.

The pages connect with the provider `SQLOLEDB`, which is built into Windows. A first run on IIS on 10 November 2026 confirmed that this provider connects to SQL Server 2025 Express in `sql-workshop`: the login, Senarai Permohonan and Mohon Cuti pages loaded. The other pages are still being checked, see the issues.

## Test logins

| No. Staf | Role | Password |
| --- | --- | --- |
| S1004 | Staff | latihan123 |
| S1007 | Staff | latihan123 |
| S1001 | Supervisor | latihan123 |
| S1002 | Supervisor | latihan123 |
| S1000 | Administrator | admin123 |

The seed data assumes the date is between 10 and 19 November 2026.
