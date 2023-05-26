import 'package:flutter/material.dart';

class CustomBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomBar(
      {Key? key,
      this.height = 44,
      this.backgroundColor,
      this.suffix,
      this.hintText,
      this.borderRadius = 20,
      this.autoFocus,
      this.focusNode,
      this.controller,
      this.actions = const [],
      this.onTap,
      this.onChanged,
      this.onSearch,
      this.onClear,
      this.onCancel,
      this.value,
      this.leading,
      this.onRightTap})
      : super(key: key);

  final double height;
  final Color? backgroundColor;
  final double? borderRadius;
  final bool? autoFocus;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  // 最前面的组件
  final Widget? leading;
  // 默认值
  final String? value;
  // 搜索框内部后缀组件
  final Widget? suffix;
  // 输入框提示文字
  final String? hintText;
  // 搜索框右侧组件
  final List<Widget> actions;
  // 输入框点击回调
  final VoidCallback? onTap;
  // 输入框内容改变
  final ValueChanged<String>? onChanged;
  // 点击键盘搜索
  final ValueChanged<String>? onSearch;
  // 清除输入框内容回调
  final VoidCallback? onClear;

  // 清除输入框内容并取消输入
  final VoidCallback? onCancel;
  // 点击右边widget
  final VoidCallback? onRightTap;

  @override
  State<CustomBar> createState() => _CustomBarState();

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _CustomBarState extends State<CustomBar> {
  TextEditingController? _controller;
  FocusNode? _focusNode;

  bool get isFocus => _focusNode?.hasFocus ?? false;
  bool get isTextEmpty => _controller?.text.isEmpty ?? false;
  bool get isActionEmpty => widget.actions.isEmpty;
  bool isShowCancel = false;

  @override
  void initState() {
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    if (widget.value != null) {
      _controller?.text = widget.value ?? "";
    }
    _focusNode?.addListener(() {
      setState(() {});
    });
    _controller?.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _focusNode?.dispose();
    super.dispose();
  }

  // 清除输入框内容
  void _onClearInput() {
    setState(() {
      _controller?.clear();
      //  _focusNode?.unfocus(); //失去焦点
    });
    widget.onClear?.call();
  }

  void _onQuery(params) {
    print(params);
  }

  // 取消输入框编辑失去焦点
  void _onCancelInput() {
    setState(() {
      _controller?.clear();
      _focusNode?.unfocus(); //失去焦点
    });
    // 执行onCancel
    widget.onCancel?.call();
  }

  List<Widget> _actions() {
    List<Widget> list = [];
    // if (isFocus || !isTextEmpty) {
    list.add(InkWell(
      onTap: widget.onRightTap ?? _onCancelInput,
      child: Container(
        constraints: const BoxConstraints(minWidth: 48),
        alignment: Alignment.center,
        child: const Text(
          '搜索',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    ));
    // } else if (!isActionEmpty) {
    //   list.addAll(widget.actions);
    // }
    return list;
  }

  Widget _suffix() {
    if (!isTextEmpty) {
      return InkWell(
        onTap: _onClearInput,
        child: SizedBox(
          width: widget.height,
          height: widget.height,
          child: const Icon(Icons.cancel, size: 22, color: Color(0xFF999999)),
        ),
      );
    }
    return widget.suffix ?? const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: widget.backgroundColor,
      elevation: 0,
      titleSpacing: 0,
      leadingWidth: 40,
      leading: widget.leading ??
          InkWell(
            child: const Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.grey,
              size: 16,
            ),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());

              Future.delayed(const Duration(milliseconds: 200), () {
                Navigator.pop(context);
              });
            },
          ),
      title: Container(
        height: widget.height,
        decoration: const BoxDecoration(color: Colors.white
            // border:
            //     Border(bottom: BorderSide(width: 0.5, color: Color(0xF5F5F5F5))),
            ),
        child: Container(
          margin: const EdgeInsetsDirectional.only(
            top: 5.0,
            bottom: 5.0,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
            // border: const Border(bottom: BorderSide(width: 1.0, color: Colors.lightBlue)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: widget.height,
                height: widget.height,
                child: const Icon(Icons.search,
                    size: 20.0, color: Color(0xFF999999)),
              ),
              Expanded(
                child: TextField(
                  cursorColor: Colors.grey,
                  autofocus: widget.autoFocus ?? false, // 是否自动获取焦点
                  focusNode: _focusNode, // 焦点控制
                  controller: _controller,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: widget.hintText ?? '搜索',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                  textInputAction: TextInputAction.search,
                  onTap: () {
                    print("Tap event");
                  }, //widget.onTap,
                  // 输入框内容改变回调
                  onChanged: (value) {
                    print("onchange event$value");
                  }, //widget.onChanged,
                  onSubmitted: (value) {
                    print("submit event");
                    _onQuery(value);
                  }, //widget.onSearch, //输入框完成触发
                ),
                flex: 1,
              ),
              _suffix(),
            ],
          ),
        ),
      ),
      actions: _actions(),
    );
  }
}
