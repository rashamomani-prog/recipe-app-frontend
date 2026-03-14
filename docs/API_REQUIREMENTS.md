# APIs Required for Recipe CRUD (Rashify Frontend)

The app implements full **CRUD** for recipes. Below is what the **backend must provide**.

---

## Already used (from existing Rashify API)

| Method | Endpoint | Description |
|--------|----------|-------------|
| **GET** | `/recipes/` | List all recipes. Optional query: `?category=...` |
| **GET** | `/recipes/search?items=...` | Search by comma-separated ingredients |
| **GET** | `/recipes/by-query?query=...` | Search by text (title/ingredients/category) |
| **GET** | `/recipes/favorites` | List current user's favorite recipes (auth required) |
| **GET** | `/recipes/{id}/favorite` | Check if recipe is favorited (auth optional; no token ⇒ `favorited: false`) |
| **POST** | `/recipes/{recipe_id}/favorite` | Toggle favorite (auth required). Response: `{ "status": "favorited" \| "unfavorited", "message": "..." }` |
| **POST** | `/admin/recipes` | Create recipe (admin only). Body: RecipeBase |

---

## APIs the backend needs to add for full CRUD

### 1. Get single recipe (Read one)

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| **GET** | `/recipes/{id}` | Optional | Return one recipe by ID |

**Response 200** – same shape as list item:

```json
{
  "id": 1,
  "title": "...",
  "ingredients": "...",
  "instructions": "...",
  "image_url": null,
  "category": "...",
  "owner_id": 1
}
```

**Response 404** – `{ "detail": "Recipe not found" }`

---

### 2. Update recipe (Update)

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| **PUT** (or **PATCH**) | `/admin/recipes/{id}` | Bearer (admin) | Update recipe by ID |

**Request body** – same as create (RecipeBase):

- `title` (string, required)
- `ingredients` (string, required)
- `instructions` (string, required)
- `image_url` (string, optional)
- `category` (string, optional)

**Response 200** – RecipeOut (same as create response).

**Responses:**

- **401** – `{ "detail": "Could not validate credentials" }`
- **403** – `{ "detail": "Not allowed" }`
- **404** – `{ "detail": "Recipe not found" }`

---

### 3. Delete recipe (Delete)

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| **DELETE** | `/admin/recipes/{id}` | Bearer (admin) | Delete recipe by ID |

**Response 204** No Content, or **200** with a message.

**Responses:**

- **401** – `{ "detail": "Could not validate credentials" }`
- **403** – `{ "detail": "Not allowed" }`
- **404** – `{ "detail": "Recipe not found" }`

---

## Summary

| Operation | HTTP   | Endpoint | Status |
|-----------|--------|----------|--------|
| **Create** | POST   | `/admin/recipes` | ✅ In use |
| **Read (list)** | GET    | `/recipes/` | ✅ In use |
| **Read (one)** | GET    | `/recipes/{id}` | ⚠️ **Backend must add** |
| **Update** | PUT/PATCH | `/admin/recipes/{id}` | ⚠️ **Backend must add** |
| **Delete** | DELETE | `/admin/recipes/{id}` | ⚠️ **Backend must add** |

Until the backend implements **GET /recipes/{id}**, **PUT /admin/recipes/{id}**, and **DELETE /admin/recipes/{id}**, the app will get 404 or 4xx when using single-recipe view, edit, or delete. The UI is ready and will work once these endpoints exist.
