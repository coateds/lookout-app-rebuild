# Environments

## Local
- The Docker Engine needs to be running 
  - Can this be automated? through a sceduled task call to a PowerShell script - another day
  - Can I just do this in the Systray?
- This uses the Dockerfile and docker-compose.yml
- Do major dev work here
- Start Procedure
  - From the lookout-app workspace: `docker compose up --build`
  - From the lookout-app workspace: vscode ctrl+shft+p > Dev Containers: Attach to running...  > lookout-app-rebuild-flask-app-1  
  - Depending on how it is set in docker-compose.yml may have to run these commands in the container.
    - `flask db migrate -m 'first migration' || true &&`
    - `flask db upgrade &&`
    - `flask run --host=0.0.0.0 --port=5000`
  - From local browser, validate
    - http://localhost:5000/ > Simple Message:  Welcome to the website!
    - http://localhost:5000/env
    - http://localhost:5000/db-check
  - Or run `pytest` in the container
- Database migration (alembic/Flask-Migrate) notes here.
- Shutdown procedure
  - From the lookout-app workspace: ctrl + c, [enter], wait for everything to stop
  - `docker compose down`  

## CI Validation Workflow
- Uses .github\workflows\ci.yml
  - Pulls secrets and writes them to dynamic .env file
  - Runs `docker compose up --build -d`
  - Runs `run: docker exec ${{ steps.flask_name.outputs.name }} pytest`
  - Tears down the containers

## Codespace - Still does not work (mapman change)
- Uses .devcontainer\devcontainer.json
  - calls the docker-compose.ci.yml file
    - does not start flask
    - starts safe tail cmd.
  - Attempts to write .env file
- Currently, the codespace starts and then ends
  - Flask fails to run becuase it cannot talk to the database
  - the devcontainer file now calls docker-compose.ci.yml
    - does not start flask
    - the .env file can be fixed and flask run manually

The reason the codespace fails is that .env reads:
```
SQL_SERVER_USER=${{ secrets.SQL_SERVER_USER }}
SQL_SERVER_PASSWORD=${{ secrets.SQL_SERVER_PASSWORD }}
SQL_SERVER_CONTAINER_SERVICE=${{ secrets.SQL_SERVER_CONTAINER_SERVICE }}
ENV=local
```
When this file is corrected, flask can be sucessfully run manually

- Codespaces Dashboard >  https://github.com/codespaces
- Other Codespaces link > https://github.com/features/codespaces
- https://github.com/settings/codespaces > find secrets here

GitHub Copilot concludes:
This is likely a Codespaces bug or a limitation of your account/region/plan.

# GitHub cli
- `Choco install gh`
- cmd line for many tasks done on the GitHub Webpage

gh secret set SQL_SERVER_USER --user --app codespaces --body "your_sql_user"
gh secret set SQL_SERVER_PASSWORD --user --app codespaces --body "your_sql_password"
gh secret set SQL_SERVER_CONTAINER_SERVICE --user --app codespaces --body "sqlserver"
