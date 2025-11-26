import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/business/auth/roles.dart';

class QuickAction {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  QuickAction(this.label, this.icon, this.color, this.onTap);
}

class ActionGrid extends StatelessWidget {
  const ActionGrid({super.key, required this.actions, required AppRole role});
  final List<QuickAction> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: actions.map((a) {
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: a.onTap,
          child: Ink(
            width: 160,
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: a.color.withOpacity(0.1),
              border: Border.all(color: a.color.withOpacity(0.3)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: a.color,
                    child: Icon(a.icon, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      a.label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
