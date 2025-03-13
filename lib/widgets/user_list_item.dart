import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_example/models/github_user.dart';
import 'package:flutter_example/utils/platform_util.dart';

class UserListItem extends StatelessWidget {
  final GitHubUser user;
  final VoidCallback onTap;

  const UserListItem({
    Key? key,
    required this.user,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return _buildWebItem(context);
    } else {
      return _buildMobileItem(context);
    }
  }

  Widget _buildWebItem(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;

    final avatarSize = width < 1200 ? 80.0 : 100.0;
    final titleFontSize = width < 1200 ? 18.0 : 20.0;
    final subtitleFontSize = width < 1200 ? 14.0 : 16.0;
    final buttonWidth = width < 1200 ? 120.0 : 150.0;
    final buttonHeight = width < 1200 ? 40.0 : 48.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: avatarSize / 2,
            backgroundImage: NetworkImage(user.image),
          ),
          const SizedBox(height: 20),
          Text(
            user.nickname,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: titleFontSize,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'ID: ${user.unit}',
            style: TextStyle(
              fontSize: subtitleFontSize,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: buttonWidth,
            height: buttonHeight,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: TextStyle(
                  fontSize: subtitleFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Просмотр'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileItem(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;

    final double avatarRadius = mediaQuery.size.width * 0.08;
    final double titleFontSize = mediaQuery.textScaleFactor * 16;
    final double subtitleFontSize = mediaQuery.textScaleFactor * 12;

    final padding = EdgeInsets.all(12.0);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: padding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: avatarRadius,
                backgroundImage: NetworkImage(user.image),
              ),
              const SizedBox(height: 8),
              Text(
                user.nickname,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: titleFontSize,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'ID: ${user.unit}',
                style: TextStyle(
                  fontSize: subtitleFontSize,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: onTap,
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: const Text('Перейти'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
