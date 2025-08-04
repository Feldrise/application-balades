# Public Rambles View - Architecture Documentation

## Overview

This document describes the new public rambles view architecture, created by reusing and adapting components from the admin rambles system.

## Directory Structure

```
lib/features/ramble/
├── public_rambles_page/           # New public view
│   ├── public_rambles_page.dart   # Main public page
│   ├── providers/
│   │   └── public_rambles_provider.dart  # Simplified state management
│   └── widgets/
│       ├── ramble_public_card.dart       # Public-facing ramble card
│       └── public_rambles_filters.dart   # Simplified filters
├── shared/                        # Shared components
│   └── widgets/
│       ├── rambles_empty_state_shared.dart    # Reusable empty state
│       └── rambles_loading_error_states.dart  # Loading/error states
└── admin/                         # Existing admin components (unchanged)
    └── admin_home_page/
        ├── widgets/
        │   ├── ramble_admin_card.dart      # Admin card (full CRUD)
        │   ├── filters/ ...                # Admin filters
        │   ├── grids/ ...                  # Grid/list components
        │   └── headers/ ...                # Header components
        └── providers/
            └── rambles_provider.dart       # Full admin state management
```

## Key Components

### 1. RamblePublicCard

**Location:** `lib/features/ramble/public_rambles_page/widgets/ramble_public_card.dart`

**Purpose:** Public-facing ramble card optimized for user discovery and registration.

**Features:**

- Beautiful cover image display with fallback icons
- Clear difficulty and type indicators
- Guide information display
- Price range display
- Registration call-to-action button
- Responsive design for all screen sizes

**Usage:**

```dart
RamblePublicCard(
  ramble: ramble,
  onTap: () => navigateToDetails(ramble.id),
  onRegister: () => registerForRamble(ramble.id),
)
```

### 2. PublicRamblesProvider

**Location:** `lib/features/ramble/public_rambles_page/providers/public_rambles_provider.dart`

**Purpose:** Simplified state management focused on public functionality.

**Key differences from admin provider:**

- Only shows active rambles (status filtering removed)
- No admin-specific actions (edit, delete, status toggle)
- Simplified filter state (no guide filtering)
- Client-side sorting since service doesn't support it

**Usage:**

```dart
// Watch state
final state = ref.watch(publicRamblesProvider);

// Update filters
ref.read(publicRamblesProvider.notifier).updateSearch('champignons');
ref.read(publicRamblesProvider.notifier).updateType('champignons');
ref.read(publicRamblesProvider.notifier).updateDifficulty('facile');
```

### 3. PublicRamblesFilters

**Location:** `lib/features/ramble/public_rambles_page/widgets/public_rambles_filters.dart`

**Purpose:** Simplified filtering interface for public users.

**Features:**

- Quick filter chips for common searches
- Type and difficulty dropdowns
- Sorting options
- Responsive layout (wide vs narrow)
- Clear filters functionality

### 4. PublicRamblesPage

**Location:** `lib/features/ramble/public_rambles_page/public_rambles_page.dart`

**Purpose:** Main public rambles page with responsive design.

**Responsive Layouts:**

- **Desktop (>1200px):** Sidebar with filters + 3-column grid
- **Tablet (768-1200px):** Top filters + 2-column grid
- **Mobile (<768px):** Search bar + bottom sheet filters + list view

**Features:**

- Integrated with app navigation (`/balades` route)
- Search functionality with debouncing
- Filter bottom sheet for mobile
- Loading, error, and empty states
- Pull-to-refresh support

## Shared Components

### RamblesEmptyStateShared

**Location:** `lib/features/ramble/shared/widgets/rambles_empty_state_shared.dart`

Reusable empty state component that can be used by both admin and public views.

### RamblesLoadingState & RamblesErrorState

**Location:** `lib/features/ramble/shared/widgets/rambles_loading_error_states.dart`

Consistent loading and error state components.

## Integration

### Routing

The public rambles page is integrated into the main app navigation:

**File:** `lib/features/navigation/routes.dart`

```dart
GoRoute(
  path: "/balades",
  pageBuilder: (context, state) => _buildPageWithDefaultTransition(
    context: context,
    state: state,
    child: const PublicRamblesPage()
  ),
),
```

### Service Integration

Both admin and public views use the same `RamblesService`, but:

- Admin view: Full access with authorization headers
- Public view: Only fetches active rambles, no auth required

## Key Differences: Admin vs Public

| Feature     | Admin View                  | Public View            |
| ----------- | --------------------------- | ---------------------- |
| **Cards**   | Full CRUD operations        | View + Register only   |
| **Filters** | All statuses, guides        | Active rambles only    |
| **Actions** | Edit, Delete, Toggle Status | Register, View Details |
| **Layout**  | Data-dense, functional      | User-friendly, visual  |
| **State**   | Complex admin workflows     | Simple discovery flow  |

## Future Enhancements

1. **Ramble Details Page:** Create detailed view for individual rambles
2. **Registration System:** Implement actual registration workflow
3. **User Authentication:** Add user login for registration
4. **Favorites:** Allow users to save favorite rambles
5. **Calendar Integration:** Add calendar view for date-based browsing
6. **Map View:** Geographic visualization of ramble locations

## Performance Considerations

- **Debounced Search:** 500ms delay to avoid excessive API calls
- **Client-side Sorting:** Reduces server load
- **Responsive Images:** Proper image loading with fallbacks
- **Lazy Loading:** Consider implementing for large lists
- **Caching:** Consider adding local state caching for better UX

## Testing Strategy

1. **Unit Tests:** Test providers and individual widgets
2. **Widget Tests:** Test responsive layouts and interactions
3. **Integration Tests:** Test full user workflows
4. **Accessibility Tests:** Ensure proper screen reader support
5. **Performance Tests:** Verify smooth scrolling and loading
