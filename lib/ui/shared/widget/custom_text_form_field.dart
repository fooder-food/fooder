import 'package:flutter/material.dart';

class FooderCustomTextFormField extends StatefulWidget {
  FooderCustomTextFormField({
    Key? key,
    required this.labelName,
    this.error = "",
    this.errorColor = Colors.red,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.go,
    this.maxLines = 1,
    this.addOnsWidget = const [],
    this.prefixWidget = const [],
    this.focusNode,
    this.textEditingController,
    this.isPassField = false,
    this.readonly = false,
    this.enablePrefixIcon = false,
    this.enableSuffixIcon = false,
    this.autoFocus = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,

    String? placeholderName,
  }) : placeholderName = placeholderName ?? labelName,
        super(key: key);
  final String labelName;
  final String error;
  final String? placeholderName;
  final Color errorColor;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final TextEditingController? textEditingController;
  List<Widget> addOnsWidget ;
  List<Widget> prefixWidget;
  bool isPassField;
  bool readonly;
  bool autoFocus;
  bool enablePrefixIcon;
  bool enableSuffixIcon;
  int maxLines;
  Widget? prefixIcon;
  Widget ? suffixIcon;
  FormFieldValidator<String>? validator;
  ValueChanged<String>? onChanged;

  @override
  _FooderCustomTextFormFieldState createState() =>
      _FooderCustomTextFormFieldState();
}

class _FooderCustomTextFormFieldState extends State<FooderCustomTextFormField> {
  bool _hasText = false;
  final FocusNode _fieldFocusNode = FocusNode();
  late bool _isObscureText;
  @override
  void initState() {
    _isObscureText = widget.isPassField;
    _fieldFocusNode.addListener(_focusNodeListener);
    super.initState();
  }

  void _focusNodeListener() {
   if(_fieldFocusNode.hasFocus && widget.textEditingController!.text.isNotEmpty) {
     setState(() {
       _hasText = true;
     });
     return ;
   }
   setState(() {
     _hasText = false;
   });
  }

  @override
  Widget build(BuildContext context) {
    final themeStyle = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         widget.labelName.isNotEmpty ? Container(
            padding: const EdgeInsets.only(
              bottom: 5,
              top: 10,
            ),
            child: Text(
              widget.labelName,
              style: themeStyle.textTheme.subtitle1!.copyWith(
              ) ,
            ),
          ): Container(),
          Row(
            children: [
              if(widget.prefixWidget.isNotEmpty)
                ...widget.prefixWidget,
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: widget.enablePrefixIcon ? widget.prefixIcon : null,
                      suffixIcon: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                        mainAxisSize: MainAxisSize.min, // added line
                        children: <Widget>[
                          widget.enableSuffixIcon ? widget.suffixIcon! : Container(),
                          if(widget.isPassField)
                            _passwordIcon(),
                          if(_hasText)
                            _cancelIcon(),
                        ],
                      ),
                      contentPadding: const EdgeInsets.only(
                        top: 10,
                        left: 10,
                        right: 10,
                      ),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          )),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.5,
                          )),
                      errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1.5,
                          )),
                      hintText: widget.placeholderName,
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                      )),
                  keyboardType: widget.textInputType,
                  textInputAction: widget.textInputAction,
                  focusNode: widget.focusNode ?? _fieldFocusNode,
                  maxLines: widget.maxLines,
                  controller:  widget.textEditingController,
                  readOnly: widget.readonly,
                  obscureText: _isObscureText,
                  autofocus: widget.autoFocus,
                  validator: widget.validator,
                  onChanged: (value) {
                    widget.onChanged;
                    if(value.isNotEmpty) {
                      setState(() {
                        _hasText = true;
                      });
                      return;
                    }
                    setState(() {
                      _hasText = false;
                    });
                  },
                )
              ),
              if(widget.addOnsWidget.isNotEmpty) const SizedBox(width: 10,),
              ...widget.addOnsWidget
            ],
          ),
          widget.error.isNotEmpty?
          Text(
            widget.error,
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
              color: widget.errorColor,
              fontSize: 14,
            ),
          ) : Container(),
        ],
      ),
    );
  }

  Widget _cancelIcon() {
    return  Padding(
      padding: const EdgeInsets.only(right: 5),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          widget.textEditingController!.clear();
          setState(() {
            _hasText = false;
          });
        },
        child: const Padding(
          padding: EdgeInsets.all(5.0),
          child: Icon(Icons.cancel, color: Colors.grey,),
        ),
      ),
    );
  }
  Widget _passwordIcon() {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          setState(() {
           _isObscureText = !_isObscureText;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation ) {
              return ScaleTransition(child: child, scale: animation);
            },
            child: Icon(
              _isObscureText? Icons.lock : Icons.text_fields,
              color: Colors.grey,
              key: ValueKey<bool>(_isObscureText),
            ),
          )
        ),
      ),
    );
  }
}
