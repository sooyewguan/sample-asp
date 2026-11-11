# e-Cuti: legacy classic ASP module for training

e-Cuti is a small staff leave application written in classic ASP with a SQL Server database. It is the legacy application of the AI-Driven Software Development Workshop. Participants migrate it to an ASP.NET Core Web API and a React app.

The system is invented for training. No code or data comes from a real system. Every person, identity number and password in the database is made up. The code has deliberate defects and security weaknesses for participants to find. Do not use it for real work.

## Contents

| Path | Contents |
| --- | --- |
| `legacy/` | 14 `.asp` pages, 5 include files in `inc/` (`inc/conn.asp` holds the connection string), `global.asa`, `misc.js`, `Loader/d_loader.js`, `css/style.css` |
| `database/ecuti_db.sql` | Creates database `LegacyDb` with 7 tables, 1 stored procedure and the seed rows |

## Cloning it for the workshop

Each participant works in their own project folder, for example an empty `ecuti` folder in Documents, used as the folder of the Code tab environment. This repository is cloned straight into that folder. The migrated application goes beside `legacy/`: the API in `server/` and the React app in `client/`.

```text
ecuti/
  legacy/       from this repository: the .asp pages
  database/     from this repository: ecuti_db.sql
  server/       ASP.NET Core Web API, created in the workshop
  client/       React app, created in the workshop
```

The participant's project is a private repository of their own, not a fork. A fork of this public repository would be public too.

In a Code tab session started from the empty project folder, send:

```text
Clone https://github.com/sooyewguan/sample-asp directly into this folder, not into a subfolder, and remove its .git. Add a .gitignore for .claude/, .agents/, skills-lock.json, .mcp.json and dab-config.json. Then commit everything as "Add legacy e-Cuti" and push it to a new private GitHub repository named ecuti.
```

Check afterwards:

- The project folder holds `legacy`, `database`, `README.md` and `.gitignore`, and `database` holds `ecuti_db.sql`.
- The repository `ecuti` on GitHub is under your account, is private, and its latest commit is `Add legacy e-Cuti`.

The triage labels and `docs/agents/` come later, from `/setup-matt-pocock-skills` in Day 1 Session 2.

Do not edit the files in `legacy/` during the workshop. They are the reference for the migration.

## Database setup

The script runs on the workshop container `sql-workshop`, which is SQL Server 2025 Express. It creates `LegacyDb` if it does not exist. If it does exist, the script drops and recreates the e-Cuti tables and the stored procedure, so running it again resets the data. The passwords come from the environment variables `WS_SQL_SA_PASSWORD`, `WS_SQL_APP_PASSWORD` and `WS_SQL_MCP_PASSWORD` saved in the Code tab environment.

In a Code tab session started from the project folder, send:

```text
In sql-workshop, create two logins: workshop_app with the password in WS_SQL_APP_PASSWORD, and workshop_mcp with the password in WS_SQL_MCP_PASSWORD. Then run database/ecuti_db.sql as sa, with the password in WS_SQL_SA_PASSWORD, to create database LegacyDb. In LegacyDb make workshop_app db_owner, and give workshop_mcp read and write access to the data and VIEW DEFINITION on schema dbo. Don't print the passwords.
```

| Login | Used by |
| --- | --- |
| `workshop_app` | EF Core, the migrated app, and legacy e-Cuti on IIS |
| `workshop_mcp` | SQL MCP Server: reads and changes rows, reads table definitions |

Expected row counts after the script runs:

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

Classic ASP runs only on IIS on Windows. The connection string is in `legacy/inc/conn.asp`, with the placeholder `TUKAR_KATA_LALUAN_DI_SINI` where the `workshop_app` password goes. IIS can't read the Code tab's environment variables, so the password has to be written into `conn.asp`. To keep it out of git, IIS serves a copy of `legacy/` from `C:\inetpub\ecuti`, and only that copy holds the password. Never put a real password in `legacy/inc/conn.asp`.

In a Code tab session started from the project folder, send:

```text
Set up legacy e-Cuti on IIS at http://localhost:8080 as site ecuti. Serve a copy of legacy/ from C:\inetpub\ecuti, with the workshop_app password from WS_SQL_APP_PASSWORD in the copy's inc/conn.asp. Don't change anything in this project or print the password. Ask me to approve any step that needs administrator rights.
```

Approve each Windows administrator prompt. Then open `http://localhost:8080` and log in with a test login below.

The pages connect with the provider `SQLOLEDB`, which is built into Windows. A first run on IIS on 10 November 2026 confirmed that it connects to SQL Server 2025 Express in `sql-workshop`: the login, Senarai Permohonan and Mohon Cuti pages loaded. The other pages are still being checked.

## Test logins

| No. Staf | Role | Password |
| --- | --- | --- |
| S1004 | Staff | latihan123 |
| S1007 | Staff | latihan123 |
| S1001 | Supervisor | latihan123 |
| S1002 | Supervisor | latihan123 |
| S1000 | Administrator | admin123 |

The seed data assumes the date is between 10 and 19 November 2026.
