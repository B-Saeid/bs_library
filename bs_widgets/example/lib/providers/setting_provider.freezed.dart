// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'setting_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingState {

 LocaleSetting get localeSettings; Locale? get locale; ThemeMode get themeMode;
/// Create a copy of SettingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingStateCopyWith<SettingState> get copyWith => _$SettingStateCopyWithImpl<SettingState>(this as SettingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingState&&(identical(other.localeSettings, localeSettings) || other.localeSettings == localeSettings)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode));
}


@override
int get hashCode => Object.hash(runtimeType,localeSettings,locale,themeMode);

@override
String toString() {
  return 'SettingState(localeSettings: $localeSettings, locale: $locale, themeMode: $themeMode)';
}


}

/// @nodoc
abstract mixin class $SettingStateCopyWith<$Res>  {
  factory $SettingStateCopyWith(SettingState value, $Res Function(SettingState) _then) = _$SettingStateCopyWithImpl;
@useResult
$Res call({
 LocaleSetting localeSettings, Locale? locale, ThemeMode themeMode
});




}
/// @nodoc
class _$SettingStateCopyWithImpl<$Res>
    implements $SettingStateCopyWith<$Res> {
  _$SettingStateCopyWithImpl(this._self, this._then);

  final SettingState _self;
  final $Res Function(SettingState) _then;

/// Create a copy of SettingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? localeSettings = null,Object? locale = freezed,Object? themeMode = null,}) {
  return _then(SettingState._(
localeSettings: null == localeSettings ? _self.localeSettings : localeSettings // ignore: cast_nullable_to_non_nullable
as LocaleSetting,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as Locale?,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,
  ));
}

}



// dart format on
