# Godot Project Guidelines

This project uses the **GladeKit MCP Bridge** to connect AI agents directly to the live Godot editor. 
When working on this project, you have access to the `gladekit-mcp` tools (such as `get_scene_tree`, `get_node_info`, `create_node`, `modify_script`, etc.). 

**CRITICAL RULES FOR ALL AGENTS:**
1. **Always use the MCP tools** for interacting with scenes, nodes, and scripts whenever possible.
2. **Do NOT edit serialized Godot files directly** (such as `.tscn` or `.tres` files) as this can corrupt them. Use the live MCP tools instead.
3. Start by calling `get_project_info` or `get_scene_tree` to understand the live state of the project before making changes.
4. Ensure the Godot Editor is running, as the MCP bridge operates over a local server hosted inside the editor (port 8766). If you cannot connect, kindly ask the user to open the Godot project first.
