# Swift Data: The Future of Data Persistence in SwiftUI
The new SwiftData framework makes it easy to persist data using declarative code. You can query and filter data using regular Swift code. And it’s designed to integrate seamlessly with SwiftUI.

## Create models with Swift
Model your data using regular Swift types with `@Model`, with no additional files or tools to manage. **SwiftData** can automatically infer many relationships and you can use clear declarations like `@Attribute(.unique)` to describe constraints. Like **SwiftUI**, the source of truth is in your code.


`
@Model
class Recipe {
    @Attribute(.unique) var name: String
    var summary: String?
    var ingredients: [Ingredient]
}
`

## Automatic persistence
SwiftData builds a custom schema using your models and maps their fields efficiently to the underlying storage. **Objects** managed by **SwiftData** are fetched from the database when needed and** automatically saved** at the right moment, with no additional work on your part. You can also take full control using the **ModelContext** API.



## Integrates with SwiftUI
Use `@Query` in your SwiftUI views to **fetch data**. SwiftData and SwiftUI work together to provide live updates to your views when the underlying data changes, with **no need to manually refresh the results.**


`
@Query var recipes: [Recipe]
var body: some View {
    List(recipes) { recipe in
        NavigationLink(recipe.name, destination: RecipeView(recipe))
    }
}
`


## Swift-native predicates
Query and filter your data using expressions that are type-checked by the compiler so you can catch typos and mistakes during development. Predicates provide compile-time errors when your expressions can’t be mapped to the underlying storage engine.


`
let simpleFood = #Predicate<Recipe> { recipe in
    recipe.ingredients.count < 3
}
`

## CloudKit syncing
Your data can be stored in files using **DocumentGroup** and synced via **iCloud Drive**, or you can use **CloudKit** to sync data between devices.



## Compatible with Core Data
SwiftData uses the proven storage architecture of Core Data, so you can use both in the same app with the same underlying storage. When you’re ready, Xcode can convert your Core Data models into classes for use with SwiftData.

# Defining a new data model
Creating a clear and well-defined data model is a crucial step in the process of organizing and structuring your data.

Defining SwiftData models using the `@Model` macro - a step-by-step guide.

You will use the `@Model` macro with all your **SwiftData** model classes. The macro allows **automatic loading** and **storing** from SwiftData, supports **observing changes**, and **adds conformances** for **Hashable, Identifiable, Observable, and PersistentModel.**

If we consider a straightforward example, the code would look like this:


`
@Model
class Todo {
    var title: String
    var description: String
 
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}
`

The complete definition of the data structure for that one type is sourced from this.

**The `@Model` macro is only compatible with classes, not structs.**

Simply marking a class with `@Model` `automatically converts its stored properties into getters and setters` that read and write the underlying SwiftData.



`When working with SwiftUI, if a view uses a property of a SwiftData model object, the view will be automatically updated whenever that property undergoes any changes.`
This means there is **no need to use annotations** such as `@Published` to indicate the properties anymore, as was previously required. Using SwiftData simplifies the process and eliminates the need for extra annotations.

**SwiftData groups multiple changes for maximum performance.**

Whenever one of these batches completes, SwiftData automatically saves all its outstanding changes, so your data is always kept safe. For instance, tasks such as inserting, deleting, and updating data.

Those computed properties that are not affected by the macro will not be stored in SwiftData persistent storage.

There are various ways to expand your models. For instance, we can assume that each Todo has a category.


`
@Model
class Todo {
    var title: String
    var description: String
    var category: Category?
 
    init(title: String, description: String, category: Category?) {
        self.title = title
        self.description = description
        self.category = category
    }
}
`

That introduces a **one-to-one relationship**. Relationships will be covered in more detail later.

Another way we can add to our models is to add special attributes to individual properties. For example, we could say that **every Tudo must have a unique date with a timestamp:**


`
@Model
class Todo {
    var title: String
    var description: String
    var category: Category?
    @Attribute(.unique) var date: Date
 
    init(title: String, description: String, category: Category?, date: .now,) {
        self.title = title
        self.description = description
        self.category = category
        self.date = date
    }
}
`

SwiftData will enforce this rule for us automatically, ensuring that no two Todos have the same date and time.

