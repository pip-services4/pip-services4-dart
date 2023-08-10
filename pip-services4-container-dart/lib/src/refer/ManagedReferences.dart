import 'dart:async';

import 'package:pip_services4_components/pip_services4_components.dart';

import './ReferencesDecorator.dart';
import './BuildReferencesDecorator.dart';
import './LinkReferencesDecorator.dart';
import './RunReferencesDecorator.dart';

/// Managed references that in addition to keeping and locating references can also
/// manage their lifecycle:
/// - Auto-creation of missing component using available factories
/// - Auto-linking newly added components
/// - Auto-opening newly added components
/// - Auto-closing removed components
///
/// See [RunReferencesDecorator]
/// See [LinkReferencesDecorator]
/// See [BuildReferencesDecorator]
/// See [References](https://pub.dev/documentation/pip_services4_components/latest/pip_services4_components/References-class.html) (in the PipServices "Commons" package)

class ManagedReferences extends ReferencesDecorator implements IOpenable {
  late References references;
  late BuildReferencesDecorator builder;
  late LinkReferencesDecorator linker;
  late RunReferencesDecorator runner;

  /// Creates a new instance of the references
  ///
  /// - tuples    tuples where odd values are component locators (descriptors) and even values are component references

  ManagedReferences(List tuples) : super(null, null) {
    references = References(tuples);
    builder = BuildReferencesDecorator(references, this);
    linker = LinkReferencesDecorator(builder, this);
    runner = RunReferencesDecorator(linker, this);

    nextReferences = runner;
  }

  /// Checks if the component is opened.
  ///
  /// Returns true if the component has been opened and false otherwise.
  @override
  bool isOpen() {
    return linker.isOpen() && runner.isOpen();
  }

  /// Opens the component.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// Return  			Future that receives error or null no errors occured.
  // Throws error
  @override
  Future open(IContext? context) async {
    await linker.open(context);
    await runner.open(context);
    return null;
  }

  /// Closes component and frees used resources.
  ///
  /// - context 	(optional) transaction id to trace execution through call chain.
  /// Return  			Future that receives null no errors occured.
  /// Throws error
  @override
  Future close(IContext? context) async {
    await runner.close(context);
    return linker.close(context);
  }

  /// Creates a new ManagedReferences object filled with provided key-value pairs called tuples.
  /// Tuples parameters contain a sequence of locator1, component1, locator2, component2, ... pairs.
  ///
  /// - [tuples]	the tuples to fill a new ManagedReferences object.
  /// Returns			a new ManagedReferences object.
  static ManagedReferences fromTuples(List tuples) {
    return ManagedReferences(tuples);
  }
}
