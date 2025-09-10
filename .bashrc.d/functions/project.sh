#!/bin/bash

# Enable pipefail for better error handling in pipelines
set -o pipefail

# Creates a new project with the appropriate structure and initialization based on project type.
#
# This function streamlines the process of starting new projects by automatically creating
# the appropriate directory structure and initializing the project with the correct tools
# and configuration files. It supports multiple project types including Python, Node.js,
# web development, and generic shell projects.
#
# Each project type includes appropriate boilerplate files, configuration, and initialization
# to get you started quickly. The function also initializes a Git repository for version control.
#
# @param $1 - The name of the project to create. This becomes the directory name. Required.
# @param $2 - (Optional) The type of project to create. Can be 'python', 'node', 'web', or 'shell'.
#             Defaults to 'shell' if not specified.
#
# @example
#   newproject my-python-project python
#   newproject my-node-app node
#   newproject my-website web
#   newproject my-shell-script
newproject() {
    if [[ $# -eq 0 ]]; then
        print_error "Usage: newproject <project_name> [type]"
        print_info "Types: python, node, web, shell (default: shell)"
        return 1
    fi

    local project_name="$1"
    local project_type="${2:-shell}"

    # Create project directory
    if [[ -d "$project_name" ]]; then
        print_error "Directory already exists: $project_name"
        return 1
    fi

    mkdir -p "$project_name"
    cd "$project_name" || return 1

    # Initialize based on type
    case "$project_type" in
        python)
            pyinitplus "$project_name"
            ;;
        node)
            nodeinitplus "$project_name"
            ;;
        web)
            webinit "$project_name"
            ;;
        shell|*)
            # Basic shell project
            mkdir -p src tests docs
            touch README.md
            echo "# $project_name" > README.md
            
            # Create basic gitignore
            cat > .gitignore << 'EOF'
# Build artifacts
dist/
*.min.*

# Environment variables
.env
.env.local
.env.*.local

# IDE files
.vscode/
.idea/
*.swp
*.swo

# OS generated files
.DS_Store
Thumbs.db
EOF

            # Initialize git
            git init || return
            git add . || return
            git commit -m "Initial commit" || return
            print_success "Shell project $project_name created!"
            ;;
    esac

    print_success "Project $project_name ($project_type) created successfully!"
}