# Product Requirements Document

**Product:** Writer Plugin
**Type:** Claude Code Plugin
**Mode:** Autopilot
**Source:** User-provided Idea Pack

---

## 1. Product Thesis

Writer is a Markdown-native authoring and publishing plugin for Claude Code that enables long-form writing workflows such as books, essays, and guides. It prioritizes voice-first input, incremental drafting, Git-based version control, and compilation into multiple publishing targets without introducing CMS overhead or proprietary formats.

The product exists to separate authorship and publishing concerns from execution and operations tooling, which are handled by the Pro plugin.

---

## 2. Core Design Principles

1. Markdown as the single source of truth
2. Voice-first interaction over typed command precision
3. Write once, compile to multiple targets
4. Low ceremony, low friction, repo-first workflows
5. Explicit separation from execution and operational tooling

---

## 3. Personas

### P-001 Long-Form Author

* Writes books, essays, or technical guides
* Prefers voice dictation or long-form prompting
* Values version history and editorial control
* Does not want CMS or WYSIWYG tooling

### P-002 Technical Writer

* Produces structured documentation or manuals
* Needs deterministic outputs for web and print
* Comfortable with Git and Markdown
* Requires repeatable compilation

### P-003 Indie Publisher

* Publishes drafts publicly while iterating
* Ships PDFs or print-ready artifacts
* Needs future-proof formats
* Avoids proprietary platforms

---

## 4. Input Scenarios

* Starting a new book from scratch
* Incrementally drafting chapters over time
* Revising tone, clarity, or length of existing material
* Compiling a manuscript into web and print outputs
* Preparing build artifacts for distribution

---

## 5. User Journeys

### J-001 Initialize Book Project

User creates a new writing repository with standard structure.

### J-002 Draft Chapter

User creates or amends a chapter using voice-first prompts.

### J-003 Revise Manuscript

User refines content at section, chapter, or manuscript scope.

### J-004 Compile Outputs

User generates publishable artifacts for one or more targets.

### J-005 Prepare Distribution

User validates structure and produces final build outputs.

---

## 6. UX Surface Inventory

| Screen ID | Surface                         |
| --------- | ------------------------------- |
| S-001     | Project Initialization Feedback |
| S-002     | Chapter Authoring Feedback      |
| S-003     | Revision Operation Feedback     |
| S-004     | Compilation Summary             |
| S-005     | Publish Validation Report       |

All surfaces are CLI-style textual feedback within Claude Code.

---

## 7. Behavior and Editing Model

* All writing operations mutate Markdown files in-repo.
* No hidden state outside the repository.
* Commands operate idempotently when possible.
* Revisions are additive unless rewrite mode is explicitly chosen.
* Compilation reads only declared manifests and target configs.

---

## 8. Constraints and Anti-Features

### Constraints

* Web-first plugin execution
* Git-backed filesystem
* Lean MVP scope, 2 to 4 week timebox

### Anti-Features

* No WYSIWYG editor
* No CMS dashboards
* No proprietary file formats
* No direct publishing or uploading
* No shared runtime state with Pro plugin

---

## 9. Success and Failure Criteria

### Success

* User can author a multi-chapter manuscript entirely in Markdown
* Outputs compile deterministically across supported targets
* Repo remains portable and tool-agnostic

### Failure

* Hidden schemas or non-obvious structure requirements
* Loss of Markdown fidelity
* Tight coupling to proprietary workflows

---

## 10. North Star

A complete long-form manuscript can be written, revised, versioned, and compiled for web and print without leaving Claude Code or breaking Markdown portability.

---

## 11. Epics

* E-001 [MUST] Project Initialization
* E-002 [MUST] Chapter Authoring
* E-003 [MUST] Revision Operations
* E-004 [MUST] Compilation Engine
* E-005 [SHOULD] Publish Preparation
* E-006 [WONT] Direct Distribution and Uploading

---

## 12. User Stories with Acceptance Criteria

### E-001 Project Initialization

* US-001 [MUST] As an author, I can initialize a new book project
  **Given** no existing `/book` directory
  **When** `/writer.init` is invoked
  **Then** the directory structure and manifest files are created

---

### E-002 Chapter Authoring

* US-002 [MUST] As an author, I can create a new chapter
  **Given** an initialized project
  **When** `/writer.chapter` is invoked with a title
  **Then** a new Markdown file is created in `/chapters`

* US-003 [MUST] As an author, I can append or revise a chapter
  **Given** an existing chapter
  **When** append or revise mode is selected
  **Then** content is updated without deleting unrelated sections

---

### E-003 Revision Operations

* US-004 [MUST] As an author, I can revise content for clarity
  **Given** existing Markdown content
  **When** `/writer.revise` with clarity mode is invoked
  **Then** meaning is preserved while improving readability

* US-005 [SHOULD] As an author, I can revise tone across a manuscript
  **Given** a full manuscript
  **When** tone alignment mode is selected
  **Then** stylistic consistency is improved

---

### E-004 Compilation Engine

* US-006 [MUST] As an author, I can compile to SpecMD
  **Given** valid manifests
  **When** `/writer.compile` is invoked
  **Then** SpecMD output is generated

* US-007 [MUST] As an author, I can compile to LaTeX
  **Given** valid content
  **When** LaTeX target is selected
  **Then** a print-ready PDF artifact is produced

---

### E-005 Publish Preparation

* US-008 [SHOULD] As an author, I can prepare distribution artifacts
  **Given** compiled outputs
  **When** `/writer.publish` is invoked
  **Then** validated artifacts are written to `/dist`

---

## 13. Traceability Map

| Story  | Epic  | Journey | Screen | Priority |
| ------ | ----- | ------- | ------ | -------- |
| US-001 | E-001 | J-001   | S-001  | MUST     |
| US-002 | E-002 | J-002   | S-002  | MUST     |
| US-003 | E-002 | J-002   | S-002  | MUST     |
| US-004 | E-003 | J-003   | S-003  | MUST     |
| US-005 | E-003 | J-003   | S-003  | SHOULD   |
| US-006 | E-004 | J-004   | S-004  | MUST     |
| US-007 | E-004 | J-004   | S-004  | MUST     |
| US-008 | E-005 | J-005   | S-005  | SHOULD   |

---

## 14. Lo-fi UI Mockups (ASCII)

### S-002 Chapter Authoring Feedback

```
[ writer.chapter ]
------------------
Title: Foundations
Mode: Append

✔ Chapter located: /chapters/02-foundations.md
✔ Content appended successfully
```

---

## 15. Decision Log

### D-001 Repository-First Storage

* Options: Repo-only, Hybrid DB, Cloud-only
* Winner: Repo-only
* Confidence: 0.92

### D-002 No Direct Publishing

* Options: Upload enabled, Local artifacts only
* Winner: Local artifacts only
* Confidence: 0.88

### D-003 Supported Targets v1

* Options: SpecMD, LaTeX, Markdown bundle
* Winner: All three
* Confidence: 0.81

---

## 16. Assumptions

* MVP timebox is 2 to 4 weeks
* Platform is web-first via Claude Code
* No compliance requirements for MVP
* No paid third-party services
* Users are Git-literate
* Voice input is treated as long-form prompts, not audio processing

---

> **This PRD is complete.**
> Copy this Markdown into Word, Google Docs, Notion, or directly into a coding model.
