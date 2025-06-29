# Project Idea: Mobile-First TODO Web App

Design a modern, minimalist, dark-themed web application for managing TODO items. The app is mobile-first, operates entirely on the client, and persists data using browser local storage. No authentication is required. The app can be deployed as static files.

## Technology Requirements

- Use the latest stable or recommended versions of all languages, tools, and frameworks.

## Data Model

Each TODO item includes:

- `text`: The task description.
- `created_on`: Creation timestamp.
- `due_date`: Due date.
- `completed`: Boolean indicating completion status.

## Application Pages

### 1. TODO List (Home)

- Display all TODO items as single-line summaries.
- Show a checkbox for each item to indicate completion.
- Include a search field to filter items by text.
- Add a filter/sort icon with a dropdown to:
  - Sort by due date (ascending/descending)
  - Sort by completion status
- Clicking an item navigates to its detail view.

### 2. TODO Detail

- Display the TODO's text and due date.
- Provide a "Completed" button to mark the item as complete.
- Provide a "Delete" button (with trash icon) to remove the item.

## Local Development

- Add README instructions for running the project locally with a development server and hot reload.
