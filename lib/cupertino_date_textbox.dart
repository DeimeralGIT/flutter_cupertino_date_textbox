library cupertino_date_textbox;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:insurance_app/core/reusable_widgets/cw_text.dart';
import 'package:insurance_app/core/utilities/autofill_hints_by_name.dart';

import 'package:insurance_app/core/common/entities/base_text_field_entity.dart';
import 'package:insurance_app/core/common/mixins/intput_field_theme.dart';
import 'package:insurance_app/core/utilities/cw_theme.dart';
import 'package:insurance_app/core/utilities/input_control.dart';

class CupertinoDateTextBox extends StatefulWidget {
  /// A text box widget which displays a cupertino picker to select a date if clicked
  CupertinoDateTextBox(
      {required this.initialValue,
      required this.onDateChange,
      required this.hintText,
      required this.textFieldEntity,
      this.color = CupertinoColors.label,
      this.hintColor = CupertinoColors.inactiveGray,
      this.pickerBackgroundColor = CupertinoColors.systemBackground,
      this.fontSize = 17.0,
      this.textfieldPadding = 15.0,
      this.enabled = true});

  /// The initial value which shall be displayed in the text box
  final DateTime initialValue;

  /// The function to be called if the selected date changes
  final Function onDateChange;

  /// The text to be displayed if no initial value is given
  final String hintText;

  /// The color of the text within the text box
  final Color color;

  /// The color of the hint text within the text box
  final Color hintColor;

  /// The background color of the cupertino picker
  final Color pickerBackgroundColor;

  /// The size of the font within the text box
  final double fontSize;

  /// The inner padding within the text box
  final double textfieldPadding;

  /// Specifies if the text box can be modified
  final bool enabled;
  
  final BaseTextFieldEntity textFieldEntity;

  @override
  _CupertinoDateTextBoxState createState() => new _CupertinoDateTextBoxState();
}

class _CupertinoDateTextBoxState extends State<CupertinoDateTextBox> {
  final double _kPickerSheetHeight = 250.0;

  DateTime? _currentDate;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.initialValue;
  }

  void callCallback() {
    widget.onDateChange(_currentDate);
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: _kPickerSheetHeight,
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: TextStyle(
          color: widget.color,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }

  void onSelectedDate(DateTime date) {
    setState(() {
      _currentDate = date;
    });
  }

  Widget _buildTextField(String hintText, Function onSelectedFunction) {
    String fieldText;
    Color textColor;
    if (_currentDate != null) {
      final formatter = new DateFormat.yMd();
      fieldText = formatter.format(_currentDate!);
      textColor = widget.color;
    } else {
      fieldText = hintText;
      textColor = widget.hintColor;
    }

    return new Flexible(
      child: new GestureDetector(
        onTap: !widget.enabled
            ? null
            : () async {
                if (_currentDate == null) {
                  setState(() {
                    _currentDate = DateTime(1992, 1, 1, 1, 1);
                  });
                }
                await showCupertinoModalPopup<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return _buildBottomPicker(CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        backgroundColor: widget.pickerBackgroundColor,
                        initialDateTime: _currentDate,
                        onDateTimeChanged: (DateTime newDateTime) {
                          onSelectedFunction(newDateTime);
                          // call callback
                          callCallback();
                        }));
                  },
                );

                // call callback
                callCallback();
              },
        child: TextField(
                          inputFormatters: [
                            inputFormatters(widget.textFieldEntity.name, widget.textFieldEntity.keyboardInputType),
                          ],
                          enabled: widget.textFieldEntity.isEnabled,
                          focusNode: focusNode,
                          textAlignVertical: TextAlignVertical.bottom,
                          cursorColor: colorScheme.primaryTextColor,
                          maxLength: widget.textFieldEntity.maxLength,
                          onSubmitted: onSubmitAction,
                          onChanged: onChangeAction,
                          cursorHeight: 18,
                          cursorWidth: 1,
                          autocorrect: false,
                          enableSuggestions: false,
                          keyboardType: textInputType(widget.textFieldEntity.keyboardInputType),
                          textInputAction: TextInputAction.next,
                          controller: controller,
                          obscureText: isObscure,
                          decoration: getInputDecoration(context)
                              .applyDefaults(
                                applyDecoration(widget.textFieldEntity.isEnabled, context, action: textFieldEntity.action, false),
                              )
                              .copyWith(
                                suffix: SizedBox(
                                  width: textFieldEntity.actionTitle.isNotEmpty ? widget.suffixButtonWidth + 15.4 * 2.5 : 0,
                                ),
                              ),
                          style: CWTextStyle(CWTextTypes.inputText, context),
                          autofillHints: (widget.textFieldEntity.isEnabled) ? autoFillHintsByName(widget.textFieldEntity.name) : null,
                        ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(children: <Widget>[
      _buildTextField(widget.hintText, onSelectedDate),
    ]);
  }
}
