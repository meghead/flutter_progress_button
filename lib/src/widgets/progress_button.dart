part of flutter_progress_button;

enum ProgressButtonState {
  Default,
  Processing,
}

enum ProgressButtonType {
  Raised,
  Flat,
  Outline,
}

class ProgressButton extends StatefulWidget {
  final Widget defaultWidget;
  final Widget? progressWidget;
  final Future<VoidCallback?> Function()? onPressed;
  final ProgressButtonType type;
  final Color? color;
  final double width;
  final double height;
  final double borderRadius;
  final bool animate;

  const ProgressButton({
    Key? key,
    required this.defaultWidget,
    this.progressWidget,
    this.onPressed,
    this.type = ProgressButtonType.Raised,
    this.color,
    this.width = double.infinity,
    this.height = 40.0,
    this.borderRadius = 2.0,
    this.animate = true,
  }) : super(key: key);

  @override
  _ProgressButtonState createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton> with TickerProviderStateMixin {
  GlobalKey _globalKey = GlobalKey();
  Animation<double>? _anim;
  AnimationController? _animController;
  final Duration _duration = const Duration(milliseconds: 250);
  late ProgressButtonState _state;
  late double _width;
  late double _height;
  late double _borderRadius;

  @override
  void dispose() {
    _animController?.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _reset();
    super.deactivate();
  }

  @override
  void initState() {
    _reset();
    super.initState();
  }

  void _reset() {
    _state = ProgressButtonState.Default;
    _width = widget.width;
    _height = widget.height;
    _borderRadius = widget.borderRadius;
  }

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(_borderRadius),
      child: SizedBox(
        key: _globalKey,
        height: _height,
        width: _width,
        child: _buildChild(context),
      ),
    );
  }

  Widget _buildChild(BuildContext context) {
    var padding = const EdgeInsets.all(0.0);
    var color = widget.color;
    var shape = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius));

    switch (widget.type) {
      case ProgressButtonType.Raised:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: padding,
            primary: color, // Replace `color` with `primary`
            shape: shape,
          ),
          child: _buildChildren(context),
          onPressed: _onButtonPressed(),
        );
      case ProgressButtonType.Flat:
        return TextButton(
          style: TextButton.styleFrom(
            padding: padding,
            primary: color, // Replace `color` with `primary`
            shape: shape,
          ),
          child: _buildChildren(context),
          onPressed: _onButtonPressed(),
        );
      case ProgressButtonType.Outline:
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: padding,
            primary: color, // Replace `color` with `primary`
            shape: shape,
          ),
          child: _buildChildren(context),
          onPressed: _onButtonPressed(),
        );
    }
  }

  Widget _buildChildren(BuildContext context) {
    Widget ret;
    switch (_state) {
      case ProgressButtonState.Default:
        ret = widget.defaultWidget;
        break;
      case ProgressButtonState.Processing:
        ret = widget.progressWidget ?? widget.defaultWidget;
        break;
    }
    return ret;
  }

  VoidCallback? _onButtonPressed() {
    return widget.onPressed == null
        ? null
        : () async {
            if (_state != ProgressButtonState.Default) {
              return;
            }

            VoidCallback? onDefault;
            if (widget.animate) {
              _toProcessing();
              _forward((status) {
                if (status == AnimationStatus.dismissed) {
                  _toDefault();
                  onDefault?.call();
                }
              });
              onDefault = await widget.onPressed!();
              _reverse();
            } else {
              _toProcessing();
              onDefault = await widget.onPressed!();
              _toDefault();
              onDefault?.call();
            }
          };
  }

  void _toProcessing() {
    setState(() {
      _state = ProgressButtonState.Processing;
    });
  }

  void _toDefault() {
    if (mounted) {
      setState(() {
        _state = ProgressButtonState.Default;
      });
    } else {
      _state = ProgressButtonState.Default;
    }
  }

  void _forward(AnimationStatusListener stateListener) {
    double initialWidth = _globalKey.currentContext!.size!.width;
    double initialBorderRadius = widget.borderRadius;
    double targetWidth = _height;
    double targetBorderRadius = _height / 2;

    _animController = AnimationController(duration: _duration, vsync: this);
    _anim = Tween(begin: 0.0, end: 1.0).animate(_animController!)
      ..addListener(() {
        setState(() {
          _width = initialWidth - ((initialWidth - targetWidth) * _anim!.value);
          _borderRadius = initialBorderRadius -
              ((initialBorderRadius - targetBorderRadius) * _anim!.value);
        });
      })
      ..addStatusListener(stateListener);

    _animController!.forward();
  }

  void _reverse() {
    _animController!.reverse();
  }
}
