# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a multi-project Marp slide generation system that leverages Cline (VS Code AI coding assistant) to automatically generate Markdown slides from free-form outlines. The system supports multiple slide projects organized in separate directories with clear separation between human-managed content and AI-generated content.

## Key Architecture

### Directory Structure
- `projects/` - Multiple slide projects
  - `{project-name}/` - Individual project directory
    - `source/` - Human-managed content (outlines, images)
      - `outline.md` - Free-form slide outline (editable)
      - `images/` - Project-specific slide images
    - `generated/` - AI-generated content (do not edit manually)
      - `slides.md` - Marp-formatted slides
      - `theme.css` - Custom Marp theme
    - `output/` - Generated presentations (PDF, PPTX, HTML)
- `scripts/` - Automation scripts
- `shared/` - Shared themes and templates

### Workflow
1. Create new project: `./scripts/create_project.sh my-project`
2. Edit `projects/my-project/source/outline.md` with free-form content
3. Use Cline to generate Marp-formatted `projects/my-project/generated/slides.md`
4. Generate final presentations: `./scripts/generate_slides.sh -p my-project -f html`

## Common Commands

### Project Management
```bash
# Create new project
./scripts/create_project.sh my-project-name

# List all projects
npm run list-projects

# Alternative: ls projects/
```

### Slide Generation
```bash
# Generate for specific project
./scripts/generate_slides.sh -p my-project --format html --output presentation

# Auto-select project (works only with single project)
./scripts/generate_slides.sh --format html --output presentation

# Generate editable PowerPoint (recommended)
./scripts/generate_slides.sh -p my-project --format pptx --output presentation --editable

# Generate PDF
./scripts/generate_slides.sh -p my-project --format pdf --output presentation
```

### Development with Docker
```bash
# Start Docker container
docker-compose up -d

# Execute commands in container
docker-compose exec app bash
```

### Package Scripts
```bash
# Create new project
npm run create-project my-project-name

# List projects
npm run list-projects

# Generate slides (auto-selects project if only one exists)
npm run generate-html
npm run generate-pdf
npm run generate-pptx
npm run generate-pptx-editable
```

### Python Environment
```bash
# Install Python dependencies
pip install -r requirements.txt

# Run sample image generation
python scripts/create_sample_images.py
```

## Development Guidelines

### Slide Generation with Cline
When generating slides from outlines in `projects/{project}/source/outline.md`, follow these patterns:
- Start with Marp header: `marp: true`, `theme: default`, `paginate: true`
- Use `---` for slide separators
- Use appropriate heading levels (`#`, `##`, `###`)
- Include bullet points and code blocks as needed
- Reference images with relative paths: `../source/images/filename.png`
- Save generated slides to `projects/{project}/generated/slides.md`

### Mermaid Diagrams
1. Create `.mmd` files in `projects/{project}/source/mermaid/`
2. Generate PNG images: `mmdc -i projects/{project}/source/mermaid/filename.mmd -o projects/{project}/source/images/mermaid_diagramX.png -w 800 -H 600`
3. Reference in slides: `![Description](../source/images/mermaid_diagramX.png)`

### File Management Rules
- **Never manually edit** files in `projects/{project}/generated/` - these are AI-generated
- Always edit source content in `projects/{project}/source/outline.md`
- Use Git commands carefully (`git mv`, `git rm` for tracked files)
- Test slide generation after changes: `./scripts/generate_slides.sh -p {project} -f html`

### Editable PowerPoint Generation
- Requires LibreOffice installation
- Use `--editable` flag for fully editable PPTX files
- Standard PPTX files embed slides as images (limited editing)

## Dependencies

### Core Tools
- Marp CLI (`@marp-team/marp-cli`) - Slide generation
- Node.js - Runtime for Marp CLI
- Python 3.x - Automation scripts
- Chromium/Chrome - PDF/PPTX generation
- LibreOffice - Editable PPTX generation (optional)

### Docker Environment
- Includes all dependencies pre-configured
- VSCode Dev Containers support for unified development environment
- Marp for VSCode extension for live preview

## Testing
- No formal test framework - verify slide generation manually
- Test Docker environment: `docker-compose up -d && docker-compose exec app bash`
- Verify output formats in `output/` directory after generation