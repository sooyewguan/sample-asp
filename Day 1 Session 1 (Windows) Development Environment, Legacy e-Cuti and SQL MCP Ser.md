# Day 1 Session 1 (Windows): Development Environment, Legacy e-Cuti and SQL MCP Server

Nov 11, 2026 · @Soo Yew Guan

This guide is for 64-bit Windows 10 or 11 on Intel or AMD chips. If your laptop has an Arm chip, tell the organiser before 12 Nov.

By the end of this session your project folder holds your own private copy of the legacy e-Cuti application, its database `LegacyDb` runs in Docker, Claude can read and write that database through SQL MCP Server, and e-Cuti runs on IIS on your laptop.

Parts C and D also give PowerShell commands from each vendor's own installation documentation, which you can run yourself instead of the installer. Run the commands marked "as administrator" in PowerShell opened as administrator.

## Part A: register a GitHub account

1. Sign up at [github.com/signup](https://github.com/signup).
2. Verify your email address from the message GitHub sends.
3. Turn on two-factor authentication with an authenticator app, and save the recovery codes.

Check: you can sign in at github.com with your password and 2FA code.

## Part B: install Git

Download Git for Windows from [git-scm.com/downloads/win](https://git-scm.com/downloads/win), run the installer and keep the default options.

## Part C: install Docker Desktop

1. Open Task Manager, Performance, CPU. If it shows "Virtualization: Disabled", turn on virtualization in BIOS/UEFI.
2. Open Start, search for "Turn Windows features on or off", tick **Virtual Machine Platform** and **Windows Subsystem for Linux**, select OK and restart Windows.
3. Download Docker Desktop for Windows from [docs.docker.com/desktop/setup/install/windows-install](https://docs.docker.com/desktop/setup/install/windows-install/) and run it. Choose the WSL 2 backend.
4. Restart Windows, open Docker Desktop and accept the terms.

Or, in place of steps 2 and 3, run these in PowerShell as administrator, then do step 4:

```
wsl --install --no-distribution
Invoke-WebRequest -Uri "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe" -OutFile "Docker Desktop Installer.exe"
Start-Process 'Docker Desktop Installer.exe' -Wait install
```

Check: Docker Desktop shows the engine running.

## Part D: install the .NET 10 SDK, VS Code and Node.js

1. Download the .NET 10 SDK installer for Windows x64 from [dotnet.microsoft.com/download/dotnet/10.0](https://dotnet.microsoft.com/download/dotnet/10.0) and run it.
2. Download the VS Code installer for Windows from [code.visualstudio.com](https://code.visualstudio.com/) and run it.
3. In VS Code, open the Extensions view (Ctrl+Shift+X) and install **C# Dev Kit**, **SQL Server (mssql)** and **Claude Code**.
4. Download the Node.js LTS installer for Windows from [nodejs.org](https://nodejs.org/) and run it.

Or install the .NET 10 SDK in PowerShell:

```
winget install Microsoft.DotNet.SDK.10
```

After installing VS Code, you can install the extensions in a new PowerShell window:

```
code --install-extension ms-dotnettools.csdevkit
code --install-extension ms-mssql.mssql
code --install-extension anthropic.claude-code
```

Check: .NET SDK, VS Code and Node.js appear in Settings, Apps, Installed apps, and the Extensions view shows the three extensions as installed.

## Part E: install Claude

You need a Claude Pro or Max account.

### E1. Claude desktop app

1. Download the Windows installer from [claude.com/download](https://claude.com/download) and run it.
2. Open the app and sign in.

Check: the **Code** tab opens.

### E2. Claude Code CLI

1. Open **PowerShell** from the Start menu.
2. Paste this command and press Enter. It shows no progress while it downloads:

```
irm https://claude.ai/install.ps1 | iex
```

3. Close PowerShell, open a new PowerShell window and run `claude --version`.
4. Run `claude`, choose your Claude subscription, and finish the sign-in in the browser. Type `/exit` to leave.

Check: `claude --version` prints a version number. If PowerShell says `'claude' is not recognized`, see [Fix your PATH](https://code.claude.com/docs/en/troubleshoot-install).

### E3. Connect GitHub

Before you connect GitHub, find these in the Claude desktop app:

- **Code tab**: where you work with Claude Code. Each conversation is a session with its own chat history and project folder.
- **Customize** in the sidebar: where you manage connectors, skills and plugins.
- **Connectors** connect Claude to external tools. Each connector is an MCP server with a graphical setup flow. GitHub is your first connector. In Part G you add a second MCP server, SQL MCP Server, through a file in your project folder instead.

1. In the desktop app, open **Customize**, then **Connectors**.
2. Select **GitHub Integration**, then **Connect**, and sign in with your GitHub account.
3. For a private repository: when Claude shows "Claude cannot access that resource", select the **here** link in that message and allow the Claude GitHub App access to the repository.

Check: in a chat, **+** shows **Add from GitHub** with your repositories.

Then install the GitHub CLI (`gh`) and sign in. In F2, Claude uses `gh` to clone e-Cuti into your project folder and create your private repository, and later the skills use it to create and read the tickets there. The connector above can't do that: it only adds a repository's files to a chat.

1. Open **PowerShell** from the Start menu and run:

   ```text
   winget install --id GitHub.cli --source winget
   ```
2. Close PowerShell and open a new PowerShell window. The installer changes PATH, and a new tab isn't enough.
3. Run this, then follow it: it shows a one-time code and opens your browser, where you enter the code and sign in with your GitHub account:

   ```text
   gh auth login --web --git-protocol https
   ```

Check: `gh auth status` shows your GitHub account.

### E4. Control Claude in the Code tab

From F1 on you work in the Code tab, and from F2 on Claude runs commands and edits files for you. The mode decides what Claude does before it asks you. Keep the mode on **Auto**, the mode a new session opens in, for the whole workshop: the check at the end of each step tells you what to look at afterwards.

| Mode | Claude does without asking | Claude asks you before |
| --- | --- | --- |
| **Auto** | Reads, edits files and runs commands. A separate checker reviews each action first | Nothing it allows. It blocks risky actions such as `curl \| bash`, force pushes and deleting critical paths |
| **Manual** | Reads files | Every file edit and every command |
| **Edit automatically** | Reads, edits files, and runs common file commands (`mkdir`, `touch`, `mv`, `cp`) | Every other command |
| **Plan** | Reads files and proposes changes | It makes no changes at all |

| Control | What it does |
| --- | --- |
| Mode selector, in the row under the prompt box | Switches between the modes above |
| Stop button, or Esc | Stops Claude's response |
| **Changes** in the session's title bar | Shows what Claude changed, as a diff |
| **+ New** in the sidebar, or Ctrl+N | Starts a new session |
| `@` and a file name | Adds that file to your request |
| `/` | Lists commands and skills |
| Ctrl+/ | Shows all Code tab shortcuts |

## Part F: your copy of e-Cuti and its database

e-Cuti is a small staff leave application written in classic ASP. It is invented for training: every person, identity number and password in its database is made up, and its code holds deliberate defects and security weaknesses for you to find. On Day 1 you migrate it to ASP.NET Core and React. On Day 2 you add a new module to the migrated application, in the same folder.

### F1. Create the project folder and the passwords

Passwords need at least 8 characters with three of: uppercase, lowercase, digits, symbols. Don't use `;` `'` `"` `$` or spaces.

1. In File Explorer, create an empty folder named `ecuti` in Documents. This folder is your project for both days: in F2 your e-Cuti is cloned straight into it, Claude runs its commands there, and G2 saves `.mcp.json` and `dab-config.json` in it.
2. In the desktop app, open **Code**. Open the environment selector under the prompt box and select **New environment**.
3. On the **Local** tab, choose the folder you created in step 1.
4. Select **Environment variables**, enter these three lines with your own passwords, and select **Done**:

```
WS_SQL_SA_PASSWORD=<sa password>
WS_SQL_APP_PASSWORD=<app login password>
WS_SQL_MCP_PASSWORD=<MCP login password>
```

5. Select **Create environment**, then start a new session from it.

Start every session in this workshop from this environment, so Claude works in your project folder and can read the three passwords.

Each prompt below does one job. In your own projects, reuse the same prompt and change the names.

### F2. Copy e-Cuti into your project folder

Your copy is a private GitHub repository under your account, named ecuti, made from your project folder, with e-Cuti in its legacy and database folders. Your specs and tickets become issues in it, and your commits go to it.

```text
Clone https://github.com/sooyewguan/sample-asp directly into this folder, not into a subfolder, and remove its .git. Add a .gitignore for .claude/, .agents/, skills-lock.json, .mcp.json and dab-config.json. Then commit everything as "Add legacy e-Cuti" and push it to a new private GitHub repository named ecuti.
```

Your repository is private: only you and the people you invite can see it. Still, never put a password or real personal data in it.

Check: ask Claude "Show me the GitHub repository for this folder, whether it is private, and its latest commit." The repository is `ecuti` under your GitHub account, it is private, and its latest commit is `Add legacy e-Cuti`. In File Explorer, your project folder holds `legacy`, `database`, `README.md` and `.gitignore`, and `database` holds `ecuti_db.sql`.

### F3. Start SQL Server

```text
Start SQL Server 2025 Express in Docker: container sql-workshop, port 1433, volume sql-workshop-data, restart it automatically when Docker starts. Take the sa password from WS_SQL_SA_PASSWORD and don't print it.
```

Check: Docker Desktop shows sql-workshop running.

### F4. Create LegacyDb and the logins

`database/ecuti_db.sql` in your project creates the e-Cuti database `LegacyDb` with its tables, one stored procedure and the seed rows.

```text
In sql-workshop, create two logins: workshop_app with the password in WS_SQL_APP_PASSWORD, and workshop_mcp with the password in WS_SQL_MCP_PASSWORD. Then run database/ecuti_db.sql as sa, with the password in WS_SQL_SA_PASSWORD, to create database LegacyDb. In LegacyDb make workshop_app db_owner, and give workshop_mcp read and write access to the data and VIEW DEFINITION on schema dbo. Don't print the passwords.
```

| Login | Used by |
| --- | --- |
| workshop\_app | EF Core, your migrated app, and legacy e-Cuti on IIS |
| workshop\_mcp | SQL MCP Server: reads, adds, changes and deletes rows, and views table definitions |

SQL MCP Server reads each table's column details, such as which columns have a default value. Without VIEW DEFINITION it can't see them.

## Part G: connect SQL MCP Server

### G1. Install SQL MCP Server

SQL MCP Server is Microsoft's Data API builder running as an MCP server. Data API builder is the `dab` command, installed as a .NET global tool from the NuGet package `Microsoft.DataApiBuilder`.

```text
Install SQL MCP Server (Data API builder, the dab .NET tool). Make sure the dab command works in a new PowerShell window, then show me its version.
```

Check: the version is 2.0 or later. Then quit the Claude desktop app from the system tray icon and open it again, so the app can find dab in G2.

### G2. Connect SQL MCP Server to LegacyDb

```text
Connect SQL MCP Server to LegacyDb in this project as a server named sqlmcp that can read, add, change and delete rows. Log in as workshop_mcp with the password in WS_SQL_MCP_PASSWORD, and don't write the password into any file. Include the seven tables in schema dbo with a description for each field, and check that each description is saved in full.
```

The `.gitignore` you wrote in F2 lists `.mcp.json` and `dab-config.json`, so neither file goes into git.

Start a new session from the saved environment, and approve the sqlmcp server if the app asks.

### G3. Use SQL MCP Server in Code

Ask Claude:

1. "What tables can you see through sqlmcp?" Claude lists the seven e-Cuti tables.
2. "How many rows does tblPermohonanCuti have? Use sqlmcp." Claude answers 80.
3. "Show all rows of tblJenisCuti through sqlmcp." Claude shows 5 rows.
4. "Through sqlmcp only, add a department to tblJabatan. Don't use any other tool."

Check: ask "How many rows does tblJabatan have? Use sqlmcp." Claude answers 4. Then ask "Through sqlmcp, delete the department you just added to tblJabatan." and ask for the count again. Claude answers 3, the count in README.md.

## Part H: run legacy e-Cuti on IIS

Classic ASP runs only on IIS on Windows. You run e-Cuti on your laptop so that, after each migrated page, you and Claude can compare it with the page it replaces.

### H1. Set up e-Cuti on IIS

Ask Claude:

```text
Set up legacy e-Cuti on IIS at http://localhost:8080. Serve a copy of legacy/ from C:\inetpub\ecuti, with the workshop_app password from WS_SQL_APP_PASSWORD in the copy's inc/conn.asp. Don't change anything in this project or print the password. Ask me to approve any step that needs administrator rights.
```

Approve each Windows administrator prompt. The password goes only into the copy in `C:\inetpub\ecuti`, outside your project folder, so git never sees it.

Or do it in steps yourself:

1. Open Start, search for "Turn Windows features on or off" and open it. Tick **Internet Information Services**, then expand **Internet Information Services**, **World Wide Web Services**, **Application Development Features**, and tick **ASP**. Select OK and wait until Windows finishes.
2. Ask Claude: "Copy legacy/ to C:\\inetpub\\ecuti and put the workshop\_app password from WS\_SQL\_APP\_PASSWORD into the copy's inc/conn.asp. Don't change anything in this project or print the password." Approve the Windows administrator prompt.
3. Open Start, search for "Internet Information Services (IIS) Manager" and open it. In **Connections**, expand your computer, right-click **Sites** and select **Add Website**. Site name `ecuti`, physical path `C:\inetpub\ecuti`, port `8080`. Select OK.

Check: ask Claude "Which files would git commit now?" The answer is none.

### H2. Log in to e-Cuti

Open `http://localhost:8080` in a browser and log in with a test login:

| No. Staf | Role | Password |
| --- | --- | --- |
| S1004 | Staff | latihan123 |
| S1007 | Staff | latihan123 |
| S1001 | Supervisor | latihan123 |
| S1002 | Supervisor | latihan123 |
| S1000 | Administrator | admin123 |

Check: S1004 logs in and the main screen shows the leave balance for this year. Log out before you close the browser.

## Final check and troubleshooting

- [ ] You can sign in to github.com with your password and 2FA code
- [ ] `claude --version` prints a version number
- [ ] `gh auth status` shows your GitHub account
- [ ] Your project folder is linked to your private e-Cuti repository on GitHub
- [ ] Docker Desktop shows the sql-workshop container running
- [ ] VS Code shows the three extensions
- [ ] dab is 2.0 or later
- [ ] In Code, Claude reads LegacyDb through sqlmcp, and adds and deletes a row in tblJabatan through it
- [ ] `http://localhost:8080` shows e-Cuti and S1004 logs in
- [ ] The workshop\_app password is only in `C:\inetpub\ecuti`, and git would commit nothing

| Symptom | Fix |
| --- | --- |
| Docker Desktop doesn't start, or shows a WSL error | Turn on virtualization in BIOS/UEFI. In "Turn Windows features on or off", tick Virtual Machine Platform and Windows Subsystem for Linux, then restart Windows |
| Claude says git, dotnet, docker, gh or dab is not found | Quit the Claude desktop app from the system tray icon and open it again. Closing the window is not enough. If dab is still missing, repeat G1 |
| Claude says a WS\_SQL\_ variable is empty | Start a new session from the saved environment, and check its three environment variables |
| The clone in F2 fails because the folder is not empty | Ask Claude: "Clone sample-asp into this folder anyway, keeping the files that are here" |
| Port 1433 is already allocated | In Docker Desktop, Containers, stop the other container. For a SQL Server installed on Windows, stop its service in Services. Then repeat F3 |
| The container stops or never becomes ready | In Docker Desktop, open sql-workshop and read its Logs. Set a stronger WS\_SQL\_SA\_PASSWORD in the saved environment, start a new session, ask Claude to remove sql-workshop, and repeat F3 |
| Login failed for workshop\_app or workshop\_mcp | Repeat F4 |
| No sqlmcp tools in Code | Ask Claude: "Check .mcp.json and dab-config.json, and run dab validate." |
| sqlmcp shows tables without fields | Ask Claude to add a description for each field of the entity |
| A field description stops at a comma | Ask Claude to write the full description in dab-config.json |
| No Add from GitHub in a chat | Repeat E3 |
| Docker says `no space left on device` in F3 | SQL Server needs about 4 GB of free Docker disk space. In PowerShell, run `docker system df` to see what uses the space, then `docker builder prune` to remove the build cache. Repeat F3 |
| `http://localhost:8080` shows an error about the handler or a 404.3 | ASP is not turned on. Repeat H1 |
| `http://localhost:8080` says access is denied | Repeat H1 |
| The e-Cuti login page shows a database error | Ask Claude: "Check that C:\\inetpub\\ecuti\\inc\\conn.asp has the workshop\_app password and that workshop\_app can log in to LegacyDb." |
| G3 shows no rows or the wrong row counts | Check the database without Claude. In VS Code, in the SQL Server view, add a connection to server localhost,1433 with SQL login workshop\_mcp and its password, database LegacyDb, and trust the server certificate. Run SELECT COUNT(\*) FROM dbo.tblPermohonanCuti. If it returns 80, the database is fine: ask Claude "Check .mcp.json and dab-config.json, and run dab validate." If not, repeat F4 |
