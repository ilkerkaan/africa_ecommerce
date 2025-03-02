# Phoenix Framework Guides

This directory contains local copies of the Phoenix Framework guides for reference during development of the Dukkadee E-Commerce platform.

## Available Guides

1. [Introduction to Phoenix](introduction.md)
   - Overview of Phoenix
   - Phoenix Features
   - Phoenix Architecture

2. [Phoenix Components](components.md)
   - Function Components
   - Component Attributes
   - Component Slots
   - Core Components
   - JavaScript Interoperability
   - Avoiding Name Conflicts

3. [Phoenix Controllers](controllers.md)
   - Basic Controller
   - Controller Actions
   - Rendering Templates
   - Redirecting
   - Flash Messages
   - Status Codes
   - Content Types
   - Plugs
   - JSON Responses

4. [Phoenix Routing](routing.md)
   - Basic Routing
   - Route Helpers
   - Resources
   - Nested Resources
   - Scopes
   - Pipelines
   - LiveView Routing
   - Path Helpers

5. [Phoenix LiveView](liveview.md)
   - LiveView Lifecycle
   - LiveView State
   - LiveView Events
   - LiveView Bindings
   - LiveComponents
   - LiveView Uploads
   - JS Interoperability
   - LiveView Navigation

6. [Phoenix LiveView JS Interoperability](liveview_js.md)
   - Basic Usage
   - Available JS Commands
   - Chaining Commands
   - Targeting Elements
   - Transitions
   - Custom JS Hooks
   - Avoiding Name Conflicts

7. [Phoenix Contexts](contexts.md)
   - What are Contexts
   - Basic Context
   - Context Organization
   - Context Functions
   - Cross-Context Communication
   - Testing Contexts
   - Best Practices for Contexts

## How to Use These Guides

These guides are meant to be a quick reference for Phoenix concepts and patterns. They are not exhaustive, but they cover the most important aspects of Phoenix development that are relevant to the Dukkadee E-Commerce platform.

When you encounter a Phoenix-related issue or need to implement a new feature, start by checking these guides. If you need more detailed information, refer to the official Phoenix documentation:

- [Official Phoenix Documentation](https://github.com/phoenixframework/phoenix/tree/v1.7.20/guides)
- [Phoenix HexDocs](https://hexdocs.pm/phoenix/1.7.20/Phoenix.html)
- [Phoenix LiveView Documentation](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html)

## Contributing to These Guides

If you find that these guides are missing important information or contain errors, please update them. These guides are meant to be a living document that evolves with the project.

When adding new information to these guides, please follow these guidelines:

1. Keep the information concise and focused on what's relevant to the Dukkadee platform
2. Include code examples where appropriate
3. Link to the official documentation for more detailed information
4. Update the index.md file to reflect any new guides or sections

## Relation to Dukkadee E-Commerce Platform

Each guide includes a section that explains how the Phoenix concept is used in the Dukkadee platform. This helps to connect the general Phoenix knowledge with our specific implementation.

For example, the LiveView guide explains how we use LiveView for real-time features like URL validation, image uploads, and the admin dashboard. This makes it easier to understand how Phoenix concepts are applied in our codebase.
