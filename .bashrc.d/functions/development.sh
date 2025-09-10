#!/bin/bash

# Enable pipefail for better error handling in pipelines
set -o pipefail

gitclone() {
    if [[ $# -eq 0 ]]; then
        print_error "Usage: gitclone <repository_url> [directory]"
        return 1
    fi

    local repo="$1"
    local dir="$2"

    print_info "Cloning repository: $repo"

    if [[ -n "$dir" ]]; then
        git clone "$repo" "$dir" && cd "$dir" || return
    else
        git clone "$repo"
        local repo_name
        repo_name=$(basename "$repo" .git)
        [[ -d "$repo_name" ]] && cd "$repo_name" || return
    fi
}

# Python project initializer
pyinit() {
    local project_name="${1:-$(basename "$PWD")}"

    print_info "Initializing Python project: $project_name"

    # Create virtual environment
    if command -v python3 >/dev/null; then
        python3 -m venv .venv
        source .venv/bin/activate
        pip install --upgrade pip
        print_success "Virtual environment created and activated"
    else
        print_error "Python 3 not found"
        return 1
    fi

    # Create basic files
    [[ ! -f "requirements.txt" ]] && touch requirements.txt
    [[ ! -f ".gitignore" ]] && curl -s https://raw.githubusercontent.com/github/gitignore/main/Python.gitignore > .gitignore
    [[ ! -f "README.md" ]] && echo "# $project_name" > README.md

    # Initialize git if not already a repo
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        git init || return
        git add . || return
        git commit -m "Initial commit" || return
        print_success "Git repository initialized"
    fi

    print_success "Python project setup complete!"
}

# Enhanced Python project initializer with common tools
pyinitplus() {
    local project_name="${1:-$(basename "$PWD")}"

    print_info "Initializing enhanced Python project: $project_name"

    # Create virtual environment
    if command -v python3 >/dev/null; then
        python3 -m venv .venv
        source .venv/bin/activate
        pip install --upgrade pip
        print_success "Virtual environment created and activated"
    else
        print_error "Python 3 not found"
        return 1
    fi

    # Install common development tools
    print_info "Installing development tools..."
    pip install black flake8 isort pytest pytest-cov pre-commit

    # Create basic files
    [[ ! -f "requirements.txt" ]] && touch requirements.txt
    [[ ! -f "requirements-dev.txt" ]] && echo -e "black
flake8
isort
pytest
pytest-cov
pre-commit" > requirements-dev.txt
    [[ ! -f ".gitignore" ]] && curl -s https://raw.githubusercontent.com/github/gitignore/main/Python.gitignore > .gitignore
    [[ ! -f "README.md" ]] && echo "# $project_name" > README.md

    # Create basic project structure
    mkdir -p src/"$project_name" tests
    touch src/"$project_name"/__init__.py
    touch tests/__init__.py

    # Create basic test file
    cat > tests/test_main.py << 'EOF'
import pytest

def test_example():
    assert True
EOF

    # Create basic main file
    cat > src/"$project_name"/main.py << 'EOF'
def main():
    print("Hello from $project_name!")

if __name__ == "__main__":
    main()
EOF

    # Create configuration files
    cat > pyproject.toml << 'EOF'
[build-system]
requires = ["setuptools", "wheel"]

[tool.black]
line-length = 88
target-version = ['py38']

[tool.isort]
profile = "black"

[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
python_classes = ["Test*"]
python_functions = ["test_*"]
addopts = "-v --cov=src --cov-report=html --cov-report=term-missing"
EOF

    # Initialize git if not already a repo
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        git init || return
        git add . || return
        git commit -m "Initial commit" || return
        print_success "Git repository initialized"
    fi

    print_success "Enhanced Python project setup complete!"
}

# Node.js project initializer
nodeinit() {
    local project_name="${1:-$(basename "$PWD")}"

    print_info "Initializing Node.js project: $project_name"

    # Initialize npm
    npm init -y

    # Install common dev dependencies
    print_info "Installing common development dependencies..."
    npm install --save-dev eslint prettier nodemon

    # Create basic files
    [[ ! -f ".gitignore" ]] && curl -s https://raw.githubusercontent.com/github/gitignore/main/Node.gitignore > .gitignore
    [[ ! -f "README.md" ]] && echo "# $project_name" > README.md

    # Create basic scripts
    cat > index.js << 'EOF'
// Main application file
console.log('Hello, World!');
EOF

    # Initialize git if not already a repo
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        git init || return
        git add . || return
        git commit -m "Initial commit" || return
        print_success "Git repository initialized"
    fi

    print_success "Node.js project setup complete!"
}

# Enhanced Node.js project initializer with TypeScript support
nodeinitplus() {
    local project_name="${1:-$(basename "$PWD")}"
    local use_typescript="${2:-false}"

    print_info "Initializing enhanced Node.js project: $project_name"

    # Initialize npm
    npm init -y

    # Install common dev dependencies
    print_info "Installing development dependencies..."
    npm install --save-dev eslint prettier nodemon

    # Add TypeScript dependencies if requested
    if [[ "$use_typescript" == "true" ]]; then
        print_info "Adding TypeScript support..."
        npm install --save-dev typescript @types/node ts-node
        npm install --save-dev @typescript-eslint/eslint-plugin @typescript-eslint/parser
    fi

    # Create basic files
    [[ ! -f ".gitignore" ]] && curl -s https://raw.githubusercontent.com/github/gitignore/main/Node.gitignore > .gitignore
    [[ ! -f "README.md" ]] && echo "# $project_name" > README.md

    # Create project structure
    mkdir -p src tests

    if [[ "$use_typescript" == "true" ]]; then
        # Create TypeScript files
        cat > src/index.ts << 'EOF'
console.log('Hello, World!');
EOF

        cat > tests/example.test.ts << 'EOF'
import { describe, it, expect } from 'vitest';

describe('example', () => {
    it('should work', () => {
        expect(true).toBe(true);
    });
});
EOF
    else
        # Create JavaScript files
        cat > src/index.js << 'EOF'
console.log('Hello, World!');
EOF

        cat > tests/example.test.js << 'EOF'
const { describe, it, expect } = require('@jest/globals');

describe('example', () => {
    it('should work', () => {
        expect(true).toBe(true);
    });
});
EOF
    fi

    # Create configuration files
    cat > .prettierrc << 'EOF'
{
    "semi": true,
    "trailingComma": "es5",
    "singleQuote": true,
    "printWidth": 80,
    "tabWidth": 2
}
EOF

    if [[ "$use_typescript" == "true" ]]; then
        cat > tsconfig.json << 'EOF'
{
    "compilerOptions": {
        "target": "ES2020",
        "module": "commonjs",
        "lib": ["ES2020"],
        "outDir": "./dist",
        "rootDir": "./src",
        "strict": true,
        "esModuleInterop": true,
        "skipLibCheck": true,
        "forceConsistentCasingInFileNames": true,
        "resolveJsonModule": true
    },
    "include": ["src/**/*"],
    "exclude": ["node_modules", "dist"]
}
EOF

        # Update package.json for TypeScript
        npm pkg set scripts.build="tsc"
        npm pkg set scripts.start="node dist/index.js"
        npm pkg set scripts.dev="ts-node src/index.ts"
    else
        npm pkg set scripts.start="node src/index.js"
        npm pkg set scripts.dev="nodemon src/index.js"
    fi

    # Add test script
    npm pkg set scripts.test="jest"

    # Initialize git if not already a repo
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        git init || return
        git add . || return
        git commit -m "Initial commit" || return
        print_success "Git repository initialized"
    fi

    print_success "Enhanced Node.js project setup complete!"
}

# Web development project initializer
webinit() {
    local project_name="${1:-$(basename "$PWD")}"

    print_info "Initializing web development project: $project_name"

    # Create basic project structure
    mkdir -p src/{css,js,assets} dist

    # Create basic HTML file
    cat > src/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$project_name</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <h1>Hello, World!</h1>
    <script src="js/main.js"></script>
</body>
</html>
EOF

    # Create basic CSS file
    cat > src/css/style.css << 'EOF'
/* Add your styles here */
body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 20px;
    background-color: #f5f5f5;
}

h1 {
    color: #333;
}
EOF

    # Create basic JavaScript file
    cat > src/js/main.js << 'EOF'
// Add your JavaScript code here
console.log('Hello, World!');
EOF

    # Create .gitignore
    cat > .gitignore << 'EOF'
# Build artifacts
dist/
*.min.css
*.min.js

# Node modules
node_modules/

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

    # Initialize git if not already a repo
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        git init || return
        git add . || return
        git commit -m "Initial commit" || return
        print_success "Git repository initialized"
    fi

    print_success "Web development project setup complete!"
}