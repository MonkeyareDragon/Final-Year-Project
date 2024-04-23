# FitnestX - Django REST Framework Project

Welcome to FitNestX! This project utilizes Django REST Framework to provide a robust backend solution for fitness-related applications.

## Prerequisites

Ensure you have the following dependencies installed:

- Docker
- Docker Compose

## Setup and Installation

### Step 1: Navigate to Project Directory

```bash
$ cd fitnestx/
```

### Step 2: Build the Docker Containers

Building the Docker containers can be time-consuming during the first run.

```bash
$ docker compose -f local.yml build
```

### Step 3: Run the Development Stack

This command starts both Django and PostgreSQL. The initial startup may take some time, but subsequent runs will be faster.

```bash
$ docker compose -f local.yml up
```

## Management Commands

To execute management commands within the Docker container, use the following syntax:

```bash
$ docker compose -f local.yml run --rm django python manage.py <command>
```

### Apply Migrations

```bash
$ docker compose -f local.yml run --rm django python manage.py migrate
```

### Create Superuser

```bash
$ docker compose -f local.yml run --rm django python manage.py createsuperuser
```

## API Documentation

After running the development stack, you can access the API documentation via Swagger at:

```
http://localhost
```

## Testing

### Run Pytest with Coverage

Execute the following command to run pytest and generate a coverage report:

```bash
$ docker compose -f local.yml run --rm django coverage run -m pytest <test_file_or_folder>
```

## Additional Resources

For more detailed information and documentation, please refer to:

[Cookiecutter Django Documentation](https://cookiecutter-django.readthedocs.io/en/latest/index.html)