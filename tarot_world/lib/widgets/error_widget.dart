// lib/widgets/error_widget.dart
import 'package:flutter/material.dart';

class ErrorDisplayWidget extends StatelessWidget {
  final String message;
  final String? details;
  final VoidCallback? onRetry;
  final IconData icon;

  const ErrorDisplayWidget({
    super.key,
    required this.message,
    this.details,
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            if (details != null) ...[
              const SizedBox(height: 8),
              Text(
                details!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('다시 시도'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final String message;

  const NetworkErrorWidget({
    super.key,
    this.onRetry,
    this.message = '인터넷 연결을 확인해주세요',
  });

  @override
  Widget build(BuildContext context) {
    return ErrorDisplayWidget(
      message: message,
      details: '네트워크 상태를 확인하고 다시 시도해주세요.',
      icon: Icons.wifi_off,
      onRetry: onRetry,
    );
  }
}

class ServerErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final String message;

  const ServerErrorWidget({
    super.key,
    this.onRetry,
    this.message = '서버에 연결할 수 없습니다',
  });

  @override
  Widget build(BuildContext context) {
    return ErrorDisplayWidget(
      message: message,
      details: '잠시 후 다시 시도해주세요.',
      icon: Icons.cloud_off,
      onRetry: onRetry,
    );
  }
}

// 에러 스낵바 표시
void showErrorSnackBar(BuildContext context, String message,
    {VoidCallback? onRetry}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.red.shade600,
      duration: const Duration(seconds: 4),
      action: onRetry != null
          ? SnackBarAction(
              label: '다시 시도',
              textColor: Colors.white,
              onPressed: onRetry,
            )
          : null,
    ),
  );
}

// 성공 스낵바 표시
void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
      backgroundColor: Colors.green.shade600,
      duration: const Duration(seconds: 2),
    ),
  );
}
