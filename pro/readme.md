# Pro Plugin - Product Planning & Development Workflows

Elevate your development workflow with intelligent planning, automated branch management, and comprehensive pull request workflows.

## What is Pro?

Pro brings professional software development workflows to Claude Code. Whether you're building a new feature, refactoring legacy code, or managing pull requests, Pro provides structured commands that help you work smarter.

**Perfect for:**
- Feature development with proper planning
- Code refactoring with systematic approaches
- Comprehensive gap analysis and verification
- Pull request creation and management
- Systematic PR comment resolution
- Post-merge cleanup automation

## Quick Start

### Installation

The Pro plugin is included in the Claude Code Marketplace. Once you have the marketplace installed, Pro commands are immediately available!

### Your First Command

Try creating a feature with guided planning:

```bash
/pro:feature "add user profile settings page"
```

Claude Code will:
1. Enter planning mode
2. Discuss requirements with you
3. Create a feature branch
4. Set up planning documentation
5. Guide you through implementation

## Commands Overview

Pro provides 7 powerful commands organized around the feature development lifecycle:

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `/pro:feature` | Create & plan features | Starting new work |
| `/pro:continue` | Resume existing work | Continuing planned features |
| `/pro:gaps` | Analyze completeness | Verifying implementation |
| `/pro:refactor` | Refactor code | Improving code quality |
| `/pro:pr` | Create pull requests | Completing features |
| `/pro:pr.resolve` | Resolve PR comments | During code review |
| `/pro:pr.merged` | Post-merge cleanup | After PR is merged |

## Detailed Command Documentation

### `/pro:feature` - Create Feature Branch with Planning

Creates a new feature branch and enters planning mode to help you define and implement your feature properly.

**Usage:**
```bash
/pro:feature "your feature description"
```

**Example:**
```bash
/pro:feature "add dark mode toggle to application settings"
```

**The workflow:**
1. **Planning Discussion** - Claude asks clarifying questions about requirements
2. **Branch Creation** - Automatically creates a descriptive feature branch
3. **Documentation Setup** - Creates planning docs in `.plan/{branch-name}/`
4. **Implementation Planning** - Breaks down the work into clear steps
5. **Guided Implementation** - Walks through each step systematically
6. **Quality Checks** - Runs verification before completion

**Planning Documentation Location:**
```
.plan/
  docs-your-feature-name/
    implementation-plan.md
    requirements.md
    notes.md
```

---

### `/pro:continue` - Continue Existing Plans

Resumes work on features that have existing planning documentation.

**Usage:**
```bash
/pro:continue
```

**The workflow:**
1. Scans `.plan/` directory for existing plans
2. Presents available plans to continue
3. Loads context from planning docs
4. Resumes implementation where you left off

**When to use:**
- Returning to work after a break
- Context was lost (new session, etc.)
- You need Claude to re-familiarize with the plan
- Collaborating and need to catch up

---

### `/pro:gaps` - Comprehensive Gap Analysis

Creates a thorough verification plan and analyzes your implementation for gaps, missing tests, edge cases, and areas needing attention.

**Usage:**
```bash
/pro:gaps
```

**What gets analyzed:**
- Requirements coverage
- Test coverage and quality
- Error handling completeness
- Edge cases consideration
- Documentation completeness
- Code quality and consistency
- Performance considerations
- Security implications

**Best for:**
- Before creating a pull request
- After completing initial implementation
- Quality assurance checkpoints
- Preparing for deployment

---

### `/pro:refactor` - Refactoring Workflow

Reviews your code against best practices and systematically refactors to improve quality, maintainability, and consistency.

**Usage:**
```bash
/pro:refactor
```

**What gets reviewed:**
- Magic strings and hardcoded values
- Duplicated logic and code
- Type safety and type annotations
- Error handling patterns
- Code organization and structure
- Naming consistency
- Documentation and comments

**Best for:**
- Technical debt reduction
- Code quality improvements
- Preparing for new features
- After rapid prototyping

---

### `/pro:pr` - Create Pull Request

Cleans up planning documentation and creates a comprehensive pull request with a well-formatted description.

**Usage:**
```bash
/pro:pr
```

**The workflow:**
1. **Review Changes** - Analyzes all commits in your branch
2. **Archive Planning Docs** - Moves `.plan/{branch}/` to `.plan/.done/`
3. **Generate PR Description** - Creates summary from all commits (not just the latest!)
4. **Create PR** - Uses `gh` CLI to create the pull request
5. **Return PR URL** - Provides link for review

**PR Description Includes:**
- Summary of all changes
- Test plan checklist
- Generated with Claude Code badge

---

### `/pro:pr.resolve` - Resolve All PR Comments

Systematically works through every comment on your pull request, addressing feedback comprehensively.

**Usage:**
```bash
/pro:pr.resolve
```

**The workflow:**
1. **Discovery** - Fetches all PR comments using `gh` CLI
2. **Planning** - Creates a plan to address each comment
3. **Implementation** - Fixes each issue systematically
4. **Quality Checks** - Runs tests and verification
5. **Documentation** - Updates changelog and docs
6. **Verification** - Confirms all comments addressed

---

### `/pro:pr.merged` - Post-Merge Cleanup

Performs cleanup tasks after your pull request has been successfully merged.

**Usage:**
```bash
/pro:pr.merged
```

**The workflow:**
1. Confirms PR is merged
2. Performs cleanup tasks
3. Updates local branches
4. Archives related documentation

---

## Example Workflows

### Complete Feature Development Lifecycle

```bash
# 1. Start a new feature
/pro:feature "add CSV export functionality to reports"

# 2. (Next day) Continue your work
/pro:continue

# 3. Verify completeness before submitting
/pro:gaps

# 4. Create pull request
/pro:pr

# 5. Address review feedback
/pro:pr.resolve

# 6. Clean up after merge
/pro:pr.merged
```

### Code Quality Improvement

```bash
# Refactor legacy code
/pro:refactor

# Verify improvements
/pro:gaps

# Submit improvements
/pro:pr
```

## Tips & Best Practices

### Planning Mode

When commands enter "planning mode," embrace the discussion:
- Answer questions thoughtfully
- Provide context about your project
- Ask questions back if you're unsure
- The planning phase saves time in implementation!

### Branch Naming

Pro automatically creates descriptive branch names like:
- `feature/add-csv-export-to-reports`
- `refactor/improve-error-handling`
- `fix/resolve-memory-leak`

### Planning Documentation

Keep planning docs updated throughout development:
- They're stored in `.plan/{branch-name}/`
- They help when resuming work
- They inform PR descriptions
- They're automatically archived when PRs are created

### Git Workflow Integration

Pro works seamlessly with Git:
- Creates branches automatically
- Stages and commits changes appropriately
- Uses conventional commit messages
- Integrates with GitHub via `gh` CLI

### Quality First

Use the gap analysis command liberally:
- Before creating PRs
- After major changes
- When something feels incomplete
- As a quality gate

## Troubleshooting

### "Can't find planning documentation"

If `/pro:continue` can't find your docs:
- Check `.plan/` directory exists
- Verify you're on the correct branch
- Planning docs match branch name format

### "GitHub CLI not found"

PR commands require `gh` CLI:
```bash
# Install on macOS
brew install gh

# Authenticate
gh auth login
```

### "No PR comments found"

If `/pro:pr.resolve` finds no comments:
- Verify you're on the correct branch
- Check your PR number is correct
- Ensure `gh` is authenticated

## Learn More

Want to understand how Pro commands work? Each command is defined in the `/pro/commands/` directory as markdown files. Feel free to explore and customize them for your needs!

**Command Files:**
- `feature.md` - Feature planning workflow
- `continue.md` - Resume existing plans
- `gaps.md` - Gap analysis logic
- `refactor.md` - Refactoring approach
- `pr.md` - PR creation process
- `pr.resolve.md` - Comment resolution workflow
- `pr.merged.md` - Post-merge cleanup

## Contributing

Found a bug or have ideas for improvement? Contributions are welcome!

1. Open an issue describing the problem or enhancement
2. Submit a PR with your proposed changes
3. Include examples and use cases

---

Happy coding with Pro!
