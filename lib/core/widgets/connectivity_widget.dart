import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_corn/core/error/custom_exceptions/internet_exception.dart';
import 'package:math_corn/core/widgets/core_widgets.dart';
import 'package:sizer/sizer.dart';

class ConnectionWidget extends StatefulWidget {
  final Widget child;
  final void Function() onRetry;
  final double? width;
  final double? height;

  const ConnectionWidget({
    super.key,
    required this.child,
    required this.onRetry,
    this.width,
    this.height,
  });

  @override
  _ConnectionWidgetState createState() => _ConnectionWidgetState();
}

class _ConnectionWidgetState extends State<ConnectionWidget> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.mobile];
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _connectionStatus.contains(ConnectivityResult.mobile) ||
            _connectionStatus.contains(ConnectivityResult.wifi)
        ? _connectedWidget()
        : _notConnectedWidget();
  }

  Widget _connectedWidget() {
    return widget.child;
  }

  Widget _notConnectedWidget() {
    final theme = Theme.of(context);

    return Container(
      width: widget.width ?? 90.w,
      height: widget.height ?? 25.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 1.h),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: CustomErrorWidget(exception: InternetException())),
          SizedBox(height: 4.h),
          // SizedBox(
          //   height: 5.h,
          //   child: CustomButton(
          //     width: 40.w,
          //     onPressed: () async {
          //       widget.onRetry.call();
          //       await initConnectivity();
          //     },
          //     text: S.of(context).retry,
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException {
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    if (mounted) {
      setState(() {
        _connectionStatus = result;
      });
      if (result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi)) {
        widget.onRetry.call();
      }
    }
  }
}
