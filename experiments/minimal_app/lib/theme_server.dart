import 'package:jaspr/jaspr.dart';
import 'package:jaspr/styles.dart';

class StaticTheme extends InheritedComponent {
  StaticTheme({required this.theme, required Component child}) : super(child: child);

  final ThemeData theme;

  @override
  bool updateShouldNotify(covariant InheritedComponent oldComponent) {
    return true;
  }

  @override
  InheritedElement createElement() => StaticThemeElement(this);
}

class StaticThemeElement extends InheritedElement {
  StaticThemeElement(super.component);

  @override
  StaticTheme get component => super.component as StaticTheme;

  @override
  Component? build() {
    return Builder(builder: (context) sync* {
      yield Style(styles: [
        StyleRule(
          selector: Selector.dot(component.theme.name),
          styles: component.theme.buildStyles(),
        ),
        for (var variant in component.theme.buildVariants())
          StyleRule(
            selector: Selector.dot(component.theme.name).dot(variant.name),
            styles: variant.buildStyles(),
          ),
      ]);
      yield component.child;
    });
  }
}

abstract class ThemeData {
  final String name;

  const ThemeData(this.name);
  const factory ThemeData.variant(String name, Styles styles) = _VariantThemeData;

  Styles buildStyles();
  List<ThemeData> buildVariants();

  List<String> resolve() => [this.name];
}

class _VariantThemeData extends ThemeData {
  const _VariantThemeData(super.name, this.styles);

  final Styles styles;

  @override
  Styles buildStyles() => styles;

  @override
  List<ThemeData> buildVariants() => [];
}
