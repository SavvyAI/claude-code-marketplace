# Bug: Marketplace Install Missing Writer Plugin

## Summary

When installing ccplugins from the marketplace, only the Pro plugin is installed. The Writer plugin is missing.

## Root Cause

The `.claude-plugin/marketplace.json` file was not updated when the Writer plugin was added in PR #40. The `plugins` array only contained the `pro` plugin entry.

## Fix

Added the `writer` plugin entry to the `plugins` array in `marketplace.json`:

```json
{
  "name": "ccplugins",
  "owner": {
    "name": "Savvy AI"
  },
  "plugins": [
    {
      "name": "pro",
      "source": "./pro"
    },
    {
      "name": "writer",
      "source": "./writer"
    }
  ]
}
```

## Prevention

Future plugin additions should include updating `marketplace.json`. Consider adding this to the plugin creation checklist or `/pro:feature` workflow when creating new plugins.

## Related

- ADR-023: Writer Plugin Multi-Plugin Architecture
- PR #40: feat(writer): add Writer Plugin for long-form authoring
