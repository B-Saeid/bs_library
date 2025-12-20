import 'package:flutter/rendering.dart';

extension TextStyleExtension on TextStyle {
  /// Creates a copy of this text style while replacing the fields passed
  /// with false with null values
  ///
  TextStyle copyExcept({
    bool inherit = true,
    bool color = true,
    bool backgroundColor = true,
    bool fontSize = true,
    bool fontWeight = true,
    bool fontStyle = true,
    bool letterSpacing = true,
    bool wordSpacing = true,
    bool textBaseline = true,
    bool height = true,
    bool leadingDistribution = true,
    bool locale = true,
    bool foreground = true,
    bool background = true,
    bool shadows = true,
    bool fontFeatures = true,
    bool fontVariations = true,
    bool decoration = true,
    bool decorationColor = true,
    bool decorationStyle = true,
    bool decorationThickness = true,
    bool debugLabel = true,
    bool fontFamily = true,
    bool fontFamilyFallback = true,
    // bool package =  true,
    bool overflow = true,
  }) => merge(
    TextStyle(
      inherit: inherit ? this.inherit : true,
      color: color ? this.color : null,
      backgroundColor: backgroundColor ? this.backgroundColor : null,
      fontSize: fontSize ? this.fontSize : null,
      fontWeight: fontWeight ? this.fontWeight : null,
      fontStyle: fontStyle ? this.fontStyle : null,
      letterSpacing: letterSpacing ? this.letterSpacing : null,
      wordSpacing: wordSpacing ? this.wordSpacing : null,
      textBaseline: textBaseline ? this.textBaseline : null,
      height: height ? this.height : null,
      leadingDistribution: leadingDistribution
          ? this.leadingDistribution
          : null,
      locale: locale ? this.locale : null,
      foreground: foreground ? this.foreground : null,
      background: background ? this.background : null,
      shadows: shadows ? this.shadows : null,
      fontFeatures: fontFeatures ? this.fontFeatures : null,
      fontVariations: fontVariations ? this.fontVariations : null,
      decoration: decoration ? this.decoration : null,
      decorationColor: decorationColor ? this.decorationColor : null,
      decorationStyle: decorationStyle ? this.decorationStyle : null,
      decorationThickness: decorationThickness
          ? this.decorationThickness
          : null,
      debugLabel: debugLabel ? this.debugLabel : null,
      fontFamily: fontFamily ? this.fontFamily : null,
      fontFamilyFallback: fontFamilyFallback ? this.fontFamilyFallback : null,
      // package: package ? this._package : null,
      overflow: overflow ? this.overflow : null,
    ),
  );
}
