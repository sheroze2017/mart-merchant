import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/modules/admin/operation/model/all_attendance_model.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BaAttendanceDetail extends StatefulWidget {
  final IndividualUserAttendance data;
  BaAttendanceDetail({super.key, required this.data});

  @override
  State<BaAttendanceDetail> createState() => _BaAttendanceDetailState();
}

class _BaAttendanceDetailState extends State<BaAttendanceDetail> {
  final TextEditingController locationController = TextEditingController();
  var result;
  @override
  void initState() {
    super.initState();
    result = countAttendanceStatus(widget.data.attendanceRecords!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Attendance Detail'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${widget.data.name}',
              style: CustomTextStyles.darkHeadingTextStyle(size: 20),
            ),
            SizedBox(
              height: 1.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Present: ${result['present']}',
                  style: CustomTextStyles.darkTextStyle(color: Colors.green)
                      .copyWith(fontSize: 14),
                ),
                Text(
                  'Weekly Off: ${result['weeklyoff']}',
                  style: CustomTextStyles.darkTextStyle(
                    color: Colors.blue,
                  ).copyWith(fontSize: 14),
                ),
                Text(
                  'Absent: ${result['absent']}',
                  style: CustomTextStyles.darkTextStyle(
                    color: Colors.red,
                  ).copyWith(fontSize: 14),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: widget.data.attendanceRecords!.length ?? 0,
                itemBuilder: (context, index) {
                  final data1 = widget.data.attendanceRecords![index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                          child: Card(
                        color: AppColors.primaryColor,
                        elevation: 2,
                        child: ListTile(
                          leading: Text(data1.status.toString().toUpperCase(),
                              style: CustomTextStyles.darkHeadingTextStyle(
                                  color:
                                      data1.status!.toLowerCase() == 'weeklyoff'
                                          ? Colors.blue
                                          : data1.status == "absent"
                                              ? Colors.red
                                              : data1.status!.toLowerCase() ==
                                                      "late"
                                                  ? Colors.brown
                                                  : Colors.green)),
                          title: Text(
                            'Dated: ' + Utils.formatDate(data1.date.toString()),
                            style: CustomTextStyles.lightTextStyle(),
                          ),
                          subtitle: data1.status == 'absent' ||
                                  data1.status == 'weeklyoff'
                              ? null
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "checkin Time: ${Utils.formatTime(data1.checkinTime!)}",
                                      style: CustomTextStyles.lightTextStyle(),
                                    ),
                                    Text(
                                      "checkout Time: ${Utils.formatTime(data1.checkoutTime!)}",
                                      style: CustomTextStyles.lightTextStyle(),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showSingleAttendanceDialog(context,
                                            record: data1);
                                      },
                                      child: SizedBox(
                                        width: 100,
                                        child: Card(
                                          color: Colors.green,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6.0, vertical: 2),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.image,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  'View',
                                                  style: CustomTextStyles
                                                      .lightSmallTextStyle(
                                                          color: Colors.white,
                                                          size: 14),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                        ),
                      )),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Map<String, int> countAttendanceStatus(List<AttendanceRecords> records) {
  int presentCount = 0;
  int absentCount = 0;
  int lateCount = 0;
  int weeklyOff = 0;

  for (var record in records) {
    final status = record.status?.toLowerCase() ?? '';
    if (status == 'present') {
      presentCount++;
    } else if (status == 'absent') {
      absentCount++;
    } else if (status == 'late') {
      lateCount++;
    } else if (status.toLowerCase() == 'weeklyoff') {
      weeklyOff++;
    }
  }

  return {
    'present': presentCount,
    'absent': absentCount,
    'late': lateCount,
    'weeklyoff': weeklyOff
  };
}

void showSingleAttendanceDialog(
  BuildContext context, {
  required AttendanceRecords record,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title:
          Text('Attendance Details', style: CustomTextStyles.darkTextStyle()),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEntryTile('Check-In', record.checkinTime, record.imageIn),
            const SizedBox(height: 16),
            _buildEntryTile('Check-Out', record.checkoutTime, record.imageOut),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Close',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );
}

Widget _buildEntryTile(String title, String? time, String? imageUrl) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: imageUrl ?? '',
          width: 150,
          height: 150,
          fit: BoxFit.cover,
          placeholder: (context, url) => const SizedBox(
              width: 150,
              height: 150,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
          errorWidget: (context, url, error) =>
              const Icon(Icons.error, size: 50),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(time ?? '-', style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    ],
  );
}
