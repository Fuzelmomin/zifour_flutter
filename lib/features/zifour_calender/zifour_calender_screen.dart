import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar_plus/flutter_rating_bar_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/utils/user_preference.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/event_item.dart';
import '../../core/widgets/my_course_item.dart';
import '../../core/widgets/signup_field_box.dart';
import '../../core/widgets/text_field_container.dart';
import '../../l10n/app_localizations.dart';
import 'bloc/calendar_event_bloc.dart';
import 'bloc/get_calender_events_bloc.dart';
import 'model/calendar_events_list_model.dart';

class ZifourCalenderScreen extends StatefulWidget {
  const ZifourCalenderScreen({super.key});

  @override
  State<ZifourCalenderScreen> createState() => _ZifourCalenderScreenState();
}

class _ZifourCalenderScreenState extends State<ZifourCalenderScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final BehaviorSubject<DateTime> _selectedDay =
      BehaviorSubject<DateTime>.seeded(DateTime.now());

  final BehaviorSubject<DateTime> _focusedDay =
      BehaviorSubject<DateTime>.seeded(DateTime.now());

  final BehaviorSubject<List<Map<String, String>>> _events =
      BehaviorSubject<List<Map<String, String>>>.seeded([]);

  /// convert string date to DateTime
  DateTime parseEventDate(String date) {
    return DateTime.parse(DateTime.tryParse(date)?.toString() ??
        /*DateTime.parse(date.replaceAll("th ", " ").replaceAll("st ", " ").replaceAll("nd ", " ").replaceAll("rd ", " ")).toString());*/
        DateTime.parse(date).toString());
  }

  bool hasEvent(DateTime day) {
    print('CheckDate $day');
    var list = _events.value;
    for (var e in list) {
      print('DateCheckkkkk ${e["date"]}');
      DateTime d = parseDate(e["date"]!);
      if (d.year == day.year && d.month == day.month && d.day == day.day) {
        return true;
      }
    }
    return false;
  }

  List<Map<String, String>> eventsForDay(DateTime day) {
    var list = _events.value;
    return list.where((e) {
      DateTime d = parseDate(e["date"]!);
      return d.year == day.year && d.month == day.month && d.day == day.day;
    }).toList();
  }

  DateTime parseDate(String dateString) {
    try {
      // For format: 18-10-2025
      return DateFormat("dd-MM-yyyy").parse(dateString);
    } catch (e) {
      throw FormatException("Invalid date format: $dateString");
    }
  }

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.purpleAccent,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.purpleAccent,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  bool _eventsLoaded = false;

  Future<void> _loadEvents(BuildContext context) async {
    if (!_eventsLoaded && context.mounted) {
      _eventsLoaded = true;
      final userData = await UserPreference.getUserData();
      if (userData != null && context.mounted) {
        context.read<GetCalenderEventsBloc>().add(
              FetchCalenderEvents(studentId: userData.stuId),
            );
      } else if (context.mounted) {
        // Fallback for testing
        context.read<GetCalenderEventsBloc>().add(
              FetchCalenderEvents(studentId: "6"),
            );
      }
    }
  }

  List<Map<String, String>> _convertApiEventsToDisplayFormat(
      List<CalendarEventItem> apiEvents) {
    return apiEvents.map((event) {
      // Convert date from "YYYY-MM-DD" to "dd-MM-yyyy"
      String displayDate = event.date ?? '';
      if (displayDate.isNotEmpty) {
        try {
          final dateTime = DateFormat('yyyy-MM-dd').parse(displayDate);
          displayDate = DateFormat('dd-MM-yyyy').format(dateTime);
        } catch (e) {
          // Keep original if parsing fails
        }
      }

      // Convert time from "HH:mm:ss" to "HH:mm" (24-hour format)
      String displayTime = event.time ?? '';
      if (displayTime.isNotEmpty && displayTime.length >= 5) {
        displayTime = displayTime.substring(0, 5); // Take only HH:mm
      }

      return {
        "time": displayTime,
        "date": displayDate,
        "title": event.name ?? '',
        "subtitle": event.description ?? '',
      };
    }).toList();
  }

  @override
  void dispose() {
    _selectedDay.close();
    _focusedDay.close();
    _events.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CalendarEventBloc()),
        BlocProvider(create: (context) => GetCalenderEventsBloc()),
      ],
      child: Builder(
        builder: (context) {
          // Load events once when widget is built
          if (!_eventsLoaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _loadEvents(context);
            });
          }
          
          return BlocListener<GetCalenderEventsBloc, GetCalenderEventsState>(
            listener: (context, state) {
              if (state is GetCalenderEventsSuccess) {
                final displayEvents =
                    _convertApiEventsToDisplayFormat(state.events);
                _events.add(displayEvents);
              } else if (state is GetCalenderEventsError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
          child: BlocListener<CalendarEventBloc, CalendarEventState>(
            listener: (context, state) {
              if (state is CalendarEventSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
                // Clear form and close bottom sheet
                nameController.clear();
                noteController.clear();
                setState(() {
                  selectedDate = null;
                  selectedTime = null;
                });
                Navigator.pop(context);
                // Reload events after creating new event
                _eventsLoaded = false;
                _loadEvents(context);
              } else if (state is CalendarEventError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            child: Scaffold(
              body: Container(
                width: double.infinity,
                height: double.infinity,
                color: AppColors.darkBlue,
                child: SafeArea(
                  child: Stack(
                    children: [
                      // Background Decoration set

                      Positioned.fill(
                        child: Image.asset(
                          AssetsPath.signupBgImg,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // App Bar
                      Positioned(
                          top: 0.h,
                          left: 15.w,
                          right: 5.w,
                          child: CustomAppBar(
                            isBack: true,
                            title:
                                '${AppLocalizations.of(context)?.zifour_calender}',
                            isActionWidget: true,
                            actionWidget: SvgPicture.asset(
                              AssetsPath.svgAdd,
                              width: 55.w,
                              height: 55.h,
                            ),
                            actionClick: () {
                              final calendarEventBloc =
                                  context.read<CalendarEventBloc>();
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                elevation: 1.0,
                                barrierColor: Colors.transparent,
                                builder: (bottomSheetContext) {
                                  return BlocProvider.value(
                                    value: calendarEventBloc,
                                    child: _buildAddEventBottomSheet(
                                        bottomSheetContext),
                                  );
                                },
                              );
                            },
                          )),

                      // Main Content with BLoC
                      Positioned(
                        top: 70.h,
                        left: 20.w,
                        right: 20.w,
                        bottom: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(),
                            _buildCalendar(),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                 ),
               ),
             ),
           ),
          );
        },
      ),
    );
  }

  bool _validateFields(BuildContext context) {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter event name'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
        ),
      );
      return false;
    }

    if (noteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter event description'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
        ),
      );
      return false;
    }

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select date'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
        ),
      );
      return false;
    }

    if (selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select time'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
        ),
      );
      return false;
    }

    return true;
  }

  String _formatTime24Hour(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _createEvent(BuildContext context) async {
    if (!_validateFields(context)) {
      return;
    }

    final userData = await UserPreference.getUserData();
    if (userData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User data not found. Please login again.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
        ),
      );
      return;
    }

    // Format date as YYYY-MM-DD
    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);

    // Format time as HH:mm (24-hour format)
    final formattedTime = _formatTime24Hour(selectedTime!);

    // Use the context passed to the method (from bottom sheet)
    if (context.mounted) {
      context.read<CalendarEventBloc>().add(
            CreateCalendarEvent(
              studentId: userData.stuId,
              //studentId: "6",
              date: formattedDate,
              time: formattedTime,
              title: nameController.text.trim(),
              description: noteController.text.trim(),
            ),
          );
    }
  }

  /// ✅ Month & Year Header
  Widget _buildHeader() {
    return StreamBuilder<DateTime>(
      stream: _focusedDay.stream,
      builder: (context, snapshot) {
        final date = snapshot.data ?? DateTime.now();
        final month = "${date.month}"; // convert to name below
        final year = date.year.toString();

        const months = [
          "",
          "January",
          "February",
          "March",
          "April",
          "May",
          "June",
          "July",
          "August",
          "September",
          "October",
          "November",
          "December"
        ];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  DateTime newDate =
                      DateTime(date.year, date.month - 1, date.day);
                  _focusedDay.add(newDate);
                },
              ),
              Text(
                "${months[date.month]} $year",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                onPressed: () {
                  DateTime newDate =
                      DateTime(date.year, date.month + 1, date.day);
                  _focusedDay.add(newDate);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// ✅ Calendar UI
  Widget _buildCalendar() {
    return StreamBuilder<DateTime>(
      stream: _selectedDay.stream,
      builder: (context, s1) {
        return StreamBuilder<DateTime>(
          stream: _focusedDay.stream,
          builder: (context, s2) {
            final selectedDate = s1.data ?? DateTime.now();
            final focusedDate = s2.data ?? DateTime.now();
            
            return TableCalendar(
              focusedDay: focusedDate,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              headerVisible: false,
              selectedDayPredicate: (day) =>
                  day.year == selectedDate.year &&
                  day.month == selectedDate.month &&
                  day.day == selectedDate.day,
              onDaySelected: (selected, focused) {
                _selectedDay.add(selected);
                _focusedDay.add(focused);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  elevation: 1.0,
                  barrierColor: Colors.transparent,
                  builder: (context) {
                    return Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: _buildEventsBottomSheet());
                  },
                );
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF21D4FD), Color(0xFFB721FF)],
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.purple,
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: const TextStyle(color: Colors.white),
                weekendTextStyle: const TextStyle(color: Colors.white),
                markerDecoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              eventLoader: (day) => hasEvent(day) ? [1] : [],
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isNotEmpty) {
                    return Positioned(
                      bottom: 1,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.pinkAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
            );
          },
        );
      },
    );
  }

  /// ✅ Bottom Sheet showing events
  Widget _buildEventsBottomSheet() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: StreamBuilder<DateTime>(
        stream: _selectedDay.stream,
        builder: (context, snapshot) {
          var selected = snapshot.data ?? DateTime.now();
          var todaysEvents = eventsForDay(selected);

          return ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Events List",
                            style: const TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w600)),
                        GestureDetector(
                          onTap: () {},
                          child: SvgPicture.asset(
                            AssetsPath.svgCloseCircle,
                            width: 30.w,
                            height: 30.h,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                        itemCount: todaysEvents.length,
                        itemBuilder: (context, index) {
                          var e = todaysEvents[index];
                          return EventItem(
                            time: e['time'],
                            date: e['date'],
                            eventName: e['title'],
                            eventDescription: e['subtitle'],
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// ✅ Bottom Sheet showing Add Event
  Widget _buildAddEventBottomSheet(BuildContext bottomSheetContext) {
    final keyboardHeight = MediaQuery.of(bottomSheetContext).viewInsets.bottom;
    final screenHeight = MediaQuery.of(bottomSheetContext).size.height;
    
    return Padding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: SizedBox(
        height: screenHeight * 0.5 + (keyboardHeight > 0 ? keyboardHeight * 0.3 : 0),
        child: StatefulBuilder(
          builder: (context, setModalState) {
            return StreamBuilder<DateTime>(
              stream: _selectedDay.stream,
              builder: (context, snapshot) {
                var selected = snapshot.data ?? DateTime.now();
                var todaysEvents = eventsForDay(selected);

                return ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Drag Handle
                            Center(
                              child: Container(
                                width: 45,
                                height: 4,
                                margin: const EdgeInsets.only(bottom: 15),
                                decoration: BoxDecoration(
                                  color: Colors.white30,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const Text(
                              "ADD NEW EVENT",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Event Name Input
                            CustomTextField(
                              hint: 'Event Name',
                              editingController: nameController,
                              type: 'text',
                              textFieldBgColor: Colors.black.withOpacity(0.1),
                              changedValue: (value) {},
                            ),
                            SizedBox(height: 10.h),
                            CustomTextField(
                              hint: 'Type the note here...',
                              editingController: noteController,
                              type: 'text',
                              textFieldBgColor: Colors.black.withOpacity(0.1),
                              isMessageTextField: true,
                              textFieldHeight: 100.h,
                              changedValue: (value) {},
                            ),
                            const SizedBox(height: 12),

                            // Date & Time Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: _pickerButton(
                                    text: selectedDate == null
                                        ? "Date"
                                        : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                                    icon: Icons.calendar_month,
                                    onTap: () async {
                                      await pickDate();
                                      setModalState(() {});
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _pickerButton(
                                    text: selectedTime == null
                                        ? "Time"
                                        : _formatTime24Hour(selectedTime!),
                                    icon: Icons.access_time_outlined,
                                    onTap: () async {
                                      await pickTime();
                                      setModalState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            BlocBuilder<CalendarEventBloc, CalendarEventState>(
                              builder: (context, state) {
                                final isLoading = state is CalendarEventLoading;
                                return CustomGradientButton(
                                  text: isLoading
                                      ? 'Creating...'
                                      : '${AppLocalizations.of(context)?.createEvent}',
                                  onPressed: isLoading
                                      ? null
                                      : () => _createEvent(context),
                                );
                              },
                            ),
                            SizedBox(height: keyboardHeight > 0 ? 20 : 0),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _pickerButton(
      {required String text,
      required IconData icon,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white24),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text,
                style: const TextStyle(color: Colors.white70, fontSize: 14)),
            Icon(icon, color: Colors.white70, size: 20),
          ],
        ),
      ),
    );
  }
}
