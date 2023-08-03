import 'dart:async';
import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:pip_services4_observability/pip_services4_observability.dart';
import '../read/ILoader.dart';
import '../write/ISaver.dart';
import 'dart:convert';

/// Abstract persistence component that stores data in memory.
///
/// This is the most basic persistence component that is only
/// able to store data items of any type. Specific CRUD operations
/// over the data items must be implemented in child classes by
/// accessing this.items property and calling [save] method.
///
/// The component supports loading and saving items from another data source.
/// That allows to use it as a base class for file and other types
/// of persistence components that cache all data in memory.
///
/// ### References ###
///
/// - \*:logger:\*:\*:1.0       (optional) [ILogger](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ILogger-class.html) components to pass log messages
///
/// ### Example ###
///
///     class MyMemoryPersistence extends MemoryPersistence<MyData> {
///
///        Future<MyData> getByName(IContext? context, String name) async {
///             var item = items.firstWhere((d) => d.name == name);
///            return item;
///         });
///
///         Future<MyData> set(IContext? context, MyData item) async {
///             items = items.where((d) => d.name != name);
///             items.add(item);
///             await save(context);
///             return item;
///         }
///     }
///
///     var persistence = MyMemoryPersistence();
///
///     persistence.set("123", { name: "ABC" })
///     var item = await persistence.getByName("123", "ABC")
///     print(item);                   // Result: { name: "ABC" }
///

class MemoryPersistence<T> implements IReferenceable, IOpenable, ICleanable {
  var logger = CompositeLogger();
  var items = <T>[];
  ILoader<T>? loader;
  ISaver<T>? saver;
  bool opened = false;
  int maxPageSize = 100;

  /// Creates a new instance of the persistence.
  ///
  /// - [loader]    (optional) a loader to load items from external datasource.
  /// - [saver]     (optional) a saver to save items to external datasource.

  MemoryPersistence([ILoader<T>? loader, ISaver<T>? saver]) {
    this.loader = loader;
    this.saver = saver;
  }

  /// Sets references to dependent components.
  ///
  /// - [references] 	references to locate the component dependencies.
  @override
  void setReferences(IReferences references) {
    logger.setReferences(references);
  }

  /// Checks if the component is opened.
  ///
  /// Return true if the component has been opened and false otherwise.

  @override
  bool isOpen() {
    return opened;
  }

  /// Opens the component.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// Return			Future that receives error or null no errors occured.
  @override
  Future open(IContext? context) async {
    await _load(context);
    opened = true;
  }

  Future _load(IContext? context) async {
    if (loader == null) {
      return null;
    }

    var items = await loader!.load(context);
    this.items = items;
    logger.trace(context, 'Loaded %d items', [items.length]);
  }

  /// Closes component and frees used resources.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// Return			Future that receives error or null no errors occured.
  @override
  Future close(IContext? context) async {
    await save(context);
    opened = false;
  }

  /// Saves items to external data source using configured saver component.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// Return         (optional) Future that receives error or null for success.
  Future save(IContext? context) async {
    if (saver == null) {
      return null;
    }

    await saver!.save(context, items);
    logger.trace(context, 'Saved %d items', [items.length]);
  }

  /// Clears component state.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// Return			Future that receives error or null no errors occured.
  @override
  Future clear(IContext? context) async {
    items = <T>[];
    logger.trace(context, 'Cleared items');
    await save(context);
  }

  /// Gets a page of data items retrieved by a given filter and sorted according to sort parameters.
  ///
  /// This method shall be called by a public getPageByFilter method from child class that
  /// receives FilterParams and converts them into a filter function.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [filter]            (optional) a filter function to filter items
  /// - [paging]            (optional) paging parameters
  /// - [sort]              (optional) sorting parameters
  /// - [select]            (optional) projection parameters (not used yet)
  /// Return         Future that receives a data page
  /// Throws error.
  Future<DataPage<T>> getPageByFilterEx(
      IContext? context, Function? filter, PagingParams? paging, Function? sort,
      [select]) async {
    var items = this.items.toList();

    // Filter and sort
    if (filter != null) {
      items = List<T>.from(items.where((item) => filter(item)));
    }
    if (sort != null) {
      items.sort((a, b) {
        var sa = sort(a);
        var sb = sort(b);
        if (sa > sb) return -1;
        if (sa < sb) return 1;
        return 0;
      });
    }

    // Extract a page
    paging = paging ?? PagingParams();
    var skip = paging.getSkip(-1);
    var take = paging.getTake(maxPageSize);

    int? total;
    if (paging.total) {
      total = items.length;
    }

    if (skip > 0) {
      items.removeRange(0, skip <= items.length ? skip : items.length);
    }
    items =
        items.getRange(0, take <= items.length ? take : items.length).toList();

    logger.trace(context, 'Retrieved %d items', [items.length]);

    var page = DataPage<T>(items, total ?? 0);
    return page;
  }

  /// Gets a list of data items retrieved by a given filter and sorted according to sort parameters.
  ///
  /// This method shall be called by a public getListByFilter method from child class that
  /// receives FilterParams and converts them into a filter function.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [filter]           (optional) a filter function to filter items
  /// - [paging]           (optional) paging parameters
  /// - [sort]             (optional) sorting parameters
  /// - [select]           (optional) projection parameters (not used yet)
  /// Return                Future that receives a data list
  /// Throw  error.
  Future<List<T>> getListByFilterEx(
      IContext? context, Function? filter, Function? sort, select) async {
    var items = this.items;

    // Apply filter
    if (filter != null) {
      items = List<T>.from(items.where((item) => filter(item)));
    }

    // Apply sorting
    if (sort != null) {
      items.sort((a, b) {
        var sa = sort(a);
        var sb = sort(b);
        if (sa > sb) return -1;
        if (sa < sb) return 1;
        return 0;
      });
    }

    logger.trace(context, 'Retrieved %d items', [items.length]);

    return items;
  }

  /// Gets a random item from items that match to a given filter.
  ///
  /// This method shall be called by a public getOneRandom method from child class that
  /// receives FilterParams and converts them into a filter function.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [filter]            (optional) a filter function to filter items.
  /// Return         Future that receives a random item
  /// Throw error.
  Future<T?> getOneRandom(IContext? context, Function? filter) async {
    var items = this.items;

    // Apply filter
    if (filter != null) {
      items = List<T>.from(items.where((item) => filter(item)));
    }

    T? item;
    if (items.isNotEmpty) {
      items.shuffle();
      item = items[0];
    }

    if (item != null) {
      logger.trace(context, 'Retrieved a random item');
    } else {
      logger.trace(context, 'Nothing to return as random item');
    }

    return item;
  }

  /// Deletes data items that match to a given filter.
  ///
  /// This method shall be called by a public deleteByFilter method from child class that
  /// receives FilterParams and converts them into a filter function.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [filter]            (optional) a filter function to filter items.
  /// Return                Future that receives null for success.
  /// Throws error
  Future deleteByFilterEx(IContext? context, Function? filter) async {
    var deleted = 0;
    if (filter is! Function) {
      throw Exception('Filter parameter must be a function.');
    }

    for (var index = items.length - 1; index >= 0; index--) {
      var item = items[index];
      if (filter(item)) {
        items.removeAt(index);
        deleted++;
      }
    }

    if (deleted == 0) {
      return null;
    }

    logger.trace(context, 'Deleted %s items', [deleted]);
    await save(context);
  }

  /// Creates a data item.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [item]              an item to be created.
  /// Return         (optional) Future that receives created item or error.
  Future<T?> create(IContext? context, T item) async {
    dynamic clone_item;
    if (item is ICloneable) {
      clone_item = (item).clone();
    } else {
      var jsonMap = json.decode(json.encode(item));
      clone_item = TypeReflector.createInstanceByType(T, []);
      clone_item.fromJson(jsonMap);
    }

    items.add(clone_item);
    logger.trace(context, 'Created item %s', [clone_item.id]);
    await save(context);
    return clone_item;
  }

  /// Gets a count of data items retrieved by a given filter.
  ///
  /// This method shall be called by a public getCountByFilter method from child class that
  /// receives FilterParams and converts them into a filter function.
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [filter]           (optional) a filter function to filter items
  /// Return                Future that receives a data count
  /// Throw  error.
  Future<int> getCountByFilterEx(IContext? context, Function? filter) async {
    // Filter
    var count = 0;
    if (filter != null) {
      for (var item in items) {
        if (filter(item)) {
          count++;
        }
      }
    }
    logger.trace(context, 'Find %d items', [count]);
    return count;
  }
}
