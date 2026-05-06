# Architectural Patterns & Best Practices

1.  **Struct-based Singletons:** Do NOT use persistent "Manager Objects" (e.g., `obj_game_controller`). Implement Singletons as global structs or static struct accessors.
2.  **Logic "Evacuation":** Decouple logic from Object Instances.
    - Game logic resides in Structs and Functions (Scripts).
    - Objects (`obj_player`, `obj_enemy`) should act primarily as "Views" or "Controllers" that bridge the engine's events to the internal struct logic.
3.  **Pseudo-Objects:** Prefer lightweight Structs over Object Instances for high-volume entities that do not require complex built-in collision/events (e.g., bullets, particles, inventory items, grid-based entities).
4.  **Fluent Interfaces:** Design struct methods to return `self` where appropriate to enable method chaining (e.g., `_box.SetColor(c_red).SetSize(10, 10).Draw();`).
5.  **Resource Management (Destructors):** Since GML lacks automatic destructors for dynamic resources (Surfaces, Buffers, DS Lists), any struct owning these MUST implement a `.Cleanup()` method. You must explicitly verify and free these resources.
6.  **Configuration:** Use `#macro` for static configuration values and constants to ensure compile-time optimization. Avoid "magic numbers".
7.  **Public API:** Place global functions intended for public use in dedicated Scripts. The Script Asset name should reflect the module (e.g., `InputSystem.gml`).

---

# Coding Standards & Formatting

- **Comment Logic:** Add concise but explanatory comments to complex or counter-intuitive logic.
- **Encapsulation:**
  - `_variable`: Local variables (var).
  - `variable`: Public instance/struct variables.
  - `__variable`: Private variables (Internal use only). NEVER access double-underscore variables from outside their scope.
- **Naming Conventions:**
  - **Variables/Assets:** `camelCase` (e.g., `playerHealth`, `sPlayerIdle`)
  - **Functions/Methods:** `PascalCase` (e.g., `InitializeSystem`, `GetDamage`)
  - **Constants/Macros:** `SCREAMING_SNAKE_CASE` (e.g., `MAX_INVENTORY_SLOTS`)
- **Syntax Style:**
  - **Brackets:** Egyptian brackets (also known as K&R style).  
     → Open curly bracket `{` stays on the **same line** as the statement.  
     Example:
    ```c
    if (condition) {
        show_debug_message("hello world");
    }
    ```
  - **Indentation:** Spaces only. NO tabs.
  - **Language:** American English for all code and API naming.

---

É importante lembrar de criar os arquivos .yy e atualizar o arquivo .yyp ao criar novos assets no projeto.
