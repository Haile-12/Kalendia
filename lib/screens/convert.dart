import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ethiopian_calendar/ethiopian_date_converter.dart';

class ConvertPage extends StatefulWidget {
  @override
  _ConvertPageState createState() => _ConvertPageState();
}

class _ConvertPageState extends State<ConvertPage> {
  final TextEditingController _dateController = TextEditingController();
  String _convertedDate = '';
  String _errorMessage = ''; // Dedicated error message
  bool _isGregorianInput = true;
  bool _isProcessing = false;

  // Helper: Check leap year
  bool _isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  // Helper: Get max days in Gregorian month
  int _getMaxDaysInMonth(int year, int month) {
    if (month == 2) {
      return _isLeapYear(year) ? 29 : 28;
    }
    final List<int> thirtyDayMonths = [4, 6, 9, 11];
    return thirtyDayMonths.contains(month) ? 30 : 31;
  }

  void _convertDate() async {
    setState(() {
      _isProcessing = true;
      _convertedDate = '';
      _errorMessage = '';
    });

    try {
      final input = _dateController.text.trim();
      if (input.isEmpty) {
        throw const FormatException('Please enter a date.');
      }

      if (_isGregorianInput) {
        // Gregorian → Ethiopian
        final parts = input.split('-');
        if (parts.length != 3) {
          throw const FormatException(
            'Invalid Gregorian format. Use YYYY-MM-DD.',
          );
        }

        final year = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final day = int.tryParse(parts[2]);

        if (year == null || month == null || day == null) {
          throw const FormatException('Only numbers are allowed.');
        }

        // Validate Gregorian Date
        if (month < 1 || month > 12) {
          throw const FormatException('Month must be between 1 and 12.');
        }

        final maxDays = _getMaxDaysInMonth(year, month);
        if (day < 1 || day > maxDays) {
          throw FormatException(
            'Invalid day. Max $maxDays days in month $month.',
          );
        }

        final gregorianDate = DateTime(year, month, day);
        final dayOfWeek = DateFormat('EEEE').format(gregorianDate);
        final ethiopianDate = EthiopianDateConverter.convertToEthiopianDate(
          gregorianDate,
        );
        await Future.delayed(const Duration(milliseconds: 400));
        setState(() {
          _convertedDate =
              'Ethiopian Date: ${ethiopianDate.month}/${ethiopianDate.day}/${ethiopianDate.year}, $dayOfWeek';
        });
      } else {
        // Ethiopian → Gregorian
        final parts = input.split('-');
        if (parts.length != 3) {
          throw const FormatException(
            'Invalid Ethiopian format. Use YYYY-MM-DD.',
          );
        }

        final year = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final day = int.tryParse(parts[2]);

        if (year == null || month == null || day == null) {
          throw const FormatException('Only numbers are allowed.');
        }

        // Ethiopian Date Validation
        if (month < 1 || month > 13) {
          throw const FormatException('Month must be between 1 and 13.');
        }

        if (day < 1) {
          throw const FormatException('Day must be at least 1.');
        }

        if (month <= 12 && day > 30) {
          throw const FormatException('Months 1–12 have max 30 days.');
        }

        if (month == 13 && day > 6) {
          throw const FormatException('Tsagume has max 6 days.');
        }

        final gregorianDate = EthiopianDateConverter.convertToGregorianDate(
          DateTime(year, month, day),
        );

        final dayOfWeek = DateFormat('EEEE').format(gregorianDate);
        await Future.delayed(const Duration(milliseconds: 400));
        setState(() {
          _convertedDate =
              "Gregorian Date: $dayOfWeek, ${DateFormat('MMMM d, y').format(gregorianDate)}";
        });
      }
    } on FormatException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Invalid date format.';
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = _isGregorianInput ? 'Gregorian Date' : 'Ethiopian Date';
    final hintText = _isGregorianInput ? '2025-04-30' : '2017-08-23';

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            // Header with Icon
            Row(
              children: [
                const Icon(
                  Icons.calendar_month,
                  size: 32,
                  color: Color(0xFF007A3D),
                ),
                const SizedBox(width: 12),
                Text(
                  'Convert Dates',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Toggle Switch
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isGregorianInput ? 'Gregorian' : 'Ethiopian',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Transform.scale(
                    scale: 1.2,
                    child: Switch(
                      value: !_isGregorianInput,
                      onChanged: (value) {
                        setState(() {
                          _isGregorianInput = !value;
                          _dateController.clear();
                          _errorMessage = '';
                          _convertedDate = '';
                        });
                      },
                      activeColor: const Color(0xFF007A3D),
                      inactiveTrackColor: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Input Card
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(26),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter $label',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _dateController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: hintText,
                        errorText:
                            _errorMessage.isNotEmpty ? _errorMessage : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _dateController.clear();
                              _convertedDate = '';
                              _errorMessage = '';
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      child: Wrap(
                        spacing: 8,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          Text(
                            _isGregorianInput
                                ? 'Format: YYYY-MM-DD (e.g., 2025-04-30)'
                                : 'Format: YYYY-MM-DD (e.g., 2017-13-06 for Tsagume)',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _convertDate,
                      icon:
                          _isProcessing
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Color.fromARGB(255, 124, 15, 175),
                                ),
                              )
                              : const Icon(Icons.sync_alt),
                      label: const Text(
                        'Convert',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          117,
                          140,
                          128,
                        ),
                        padding: const EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Conversion Result
            if (_convertedDate.isNotEmpty)
              SlideInAnimation(
                convertedDate: _convertedDate,
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: const Color(0xFF007A3D).withAlpha(26),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _convertedDate,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// SlideInAnimation (unchanged)
class SlideInAnimation extends StatelessWidget {
  final String convertedDate;
  final Widget child;

  const SlideInAnimation({
    Key? key,
    required this.convertedDate,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Offset>(
      duration: const Duration(milliseconds: 400),
      tween: Tween(begin: const Offset(0, 0.2), end: Offset.zero),
      curve: Curves.easeOutCubic,
      child: child,
      builder: (context, offset, child) {
        return Transform.translate(
          offset: offset * 50,
          child: Opacity(
            opacity: convertedDate.isNotEmpty ? 1.0 : 0.0,
            child: child,
          ),
        );
      },
    );
  }
}
