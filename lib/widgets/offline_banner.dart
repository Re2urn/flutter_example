import 'package:flutter/material.dart';

class OfflineBanner extends StatelessWidget {
  final VoidCallback? onTryAgain;

  const OfflineBanner({
    Key? key,
    this.onTryAgain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Material(
        elevation: 4,
        color: Colors.red.shade700,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.wifi_off,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Нет подключения к интернету',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  if (onTryAgain != null)
                    TextButton(
                      onPressed: onTryAgain,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Обновить'),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Проверьте подключение к сети для загрузки данных',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
