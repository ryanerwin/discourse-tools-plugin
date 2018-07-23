# discourse-tools-plugin

Command line "rake" utilities for use with Discourse, currently can lock users by group and enable theme components

## Rake Tasks
```
tools:add_child_theme[parent,child]                               # Add child theme to a theme
tools:remove_child_theme[parent,child]                            # Remove child theme from a theme
tools:disable_users[group,till]                                   # Disable users except member of group
tools:enable_users                                                # Re-enable disabled users
```
