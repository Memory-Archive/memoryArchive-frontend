import 'package:flutter/material.dart';

import '../../../../core/helpers/date_format.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_spacing.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../memories/domain/entities/memory.dart';

String _meta(Memory memory) => [
      AppDateFormat.shortDate(memory.memoryDate),
      if (memory.placeName != null) memory.placeName!,
    ].join(' · ');

Widget _cover(Memory memory, {double? width, double? height}) {
  final cover = memory.coverImage;
  if (cover == null) {
    return ImagePlaceholder(width: width, height: height);
  }
  return AppImage(cover, width: width, height: height, semanticLabel: memory.title);
}

/// Mint card: a memory from this day in an earlier year.
class OnThisDayCard extends StatelessWidget {
  const OnThisDayCard({super.key, required this.memory, required this.onTap});

  final Memory memory;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final years = AppDateFormat.yearsAgo(memory.memoryDate, DateTime.now());
    final when = years == 1 ? '1 YEAR AGO' : '$years YEARS AGO';
    return Material(
      color: AppColors.mint,
      borderRadius: BorderRadius.circular(AppRadii.card),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              _cover(memory, width: 60, height: 60),
              AppGap.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ON THIS DAY · $when', style: AppTextStyles.eyebrow(color: AppColors.greenDark)),
                    AppGap.h4,
                    Text(
                      memory.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body(size: 16, weight: FontWeight.w700, color: AppColors.greenDark),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.greenDark),
            ],
          ),
        ),
      ),
    );
  }
}

/// Big card with the cover photo, for the newest memory.
class FeaturedMemoryCard extends StatelessWidget {
  const FeaturedMemoryCard({super.key, required this.memory, required this.onTap});

  final Memory memory;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _cover(memory, width: double.infinity, height: 190),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(memory.title, style: AppTextStyles.display(size: 20)),
                      ),
                      if (memory.photoCount > 0)
                        Text(
                          memory.photoCount == 1 ? '1 photo' : '${memory.photoCount} photos',
                          style: AppTextStyles.body(size: 12, color: AppColors.muted),
                        ),
                    ],
                  ),
                  AppGap.h6,
                  Text(_meta(memory), style: AppTextStyles.body(size: 13, color: AppColors.muted)),
                  if (memory.description != null && memory.description!.isNotEmpty) ...[
                    AppGap.h6,
                    Text(
                      memory.description!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body(size: 14, height: 1.4),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small row card for older memories.
class CompactMemoryCard extends StatelessWidget {
  const CompactMemoryCard({super.key, required this.memory, required this.onTap});

  final Memory memory;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              _cover(memory, width: 76, height: 76),
              AppGap.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      memory.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body(size: 16, weight: FontWeight.w700),
                    ),
                    AppGap.h4,
                    Text(_meta(memory), style: AppTextStyles.body(size: 13, color: AppColors.muted)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
