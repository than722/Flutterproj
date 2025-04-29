import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EventDetails extends StatefulWidget {
  final QueryDocumentSnapshot eventData;

  const EventDetails({super.key, required this.eventData});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  String orgLogoUrl = '';
  String orgName = '';

  @override
  void initState() {
    super.initState();
    fetchOrganizationData();
  }

  Future<void> fetchOrganizationData() async {
    final data = widget.eventData.data() as Map<String, dynamic>;
    final orgId = data['orgId'];

    if (orgId != null && orgId != '') {
      final orgSnapshot = await FirebaseFirestore.instance.collection('organizations').doc(orgId).get();
      if (orgSnapshot.exists) {
        final rawLogo = orgSnapshot.data()?['logo'] ?? '';
        setState(() {
          orgLogoUrl = formatDriveUrl(rawLogo);
          orgName = orgSnapshot.data()?['name'] ?? '';
        });
      }
    }
  }

  String formatDriveUrl(String url) {
    url = url.trim();
    try {
      final uri = Uri.parse(url);
      if (uri.host.contains('drive.google.com') && uri.pathSegments.contains('d')) {
        final fileId = uri.pathSegments[uri.pathSegments.indexOf('d') + 1];
        return 'https://drive.google.com/uc?id=$fileId';
      }
    } catch (e) {}
    return url;
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.eventData.data() as Map<String, dynamic>;

    final title = data['title'] ?? 'No Title';
    final rawBannerUrl = data['banner'] ?? '';
    final bannerUrl = formatDriveUrl(rawBannerUrl);

    final description = data['description'] ?? '';
    final location = data['location'] ?? '';
    final tags = data['tags'] ?? '';

    dynamic startData = data['datetimestart'];
    dynamic endData = data['datetimemend'];

    String startDateFormatted = '';
    String endDateFormatted = '';

    if (startData is Timestamp) {
      startDateFormatted = DateFormat('MMM dd, yyyy hh:mm a').format(startData.toDate());
    } else if (startData is String) {
      try {
        startDateFormatted = DateFormat('MMM dd, yyyy hh:mm a').format(DateTime.parse(startData));
      } catch (e) {}
    }

    if (endData is Timestamp) {
      endDateFormatted = DateFormat('MMM dd, yyyy hh:mm a').format(endData.toDate());
    } else if (endData is String) {
      try {
        endDateFormatted = DateFormat('MMM dd, yyyy hh:mm a').format(DateTime.parse(endData));
      } catch (e) {}
    }

    String dateDisplay = '';
    if (startDateFormatted.isNotEmpty && endDateFormatted.isNotEmpty) {
      dateDisplay = '$startDateFormatted - $endDateFormatted';
    } else if (startDateFormatted.isNotEmpty) {
      dateDisplay = startDateFormatted;
    } else {
      dateDisplay = 'No date available';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F4FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001C60),
        title: const Text('Event Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            if (bannerUrl.isNotEmpty)
              Image.network(
                bannerUrl,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),

            const SizedBox(height: 16),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 12),

            // Date
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.black54),
                  const SizedBox(width: 8),
                  Text(dateDisplay, style: const TextStyle(color: Colors.black87)),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // Location
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.black54),
                  const SizedBox(width: 8),
                  Text(location.isNotEmpty ? location : 'No location specified',
                      style: const TextStyle(color: Colors.black87)),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // Tags
            if (tags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '#$tags',
                  style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.blue),
                ),
              ),

            const SizedBox(height: 16),

            // Organization
            if (orgLogoUrl.isNotEmpty || orgName.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    if (orgLogoUrl.isNotEmpty)
                      ClipOval(
                        child: Image.network(
                          orgLogoUrl,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(width: 10),
                    if (orgName.isNotEmpty)
                      Text(
                        orgName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                description.isNotEmpty ? description : 'No description available.',
                style: const TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 30),

            // Register Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF001C60),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registered successfully!')),
                  );
                },
                child: const Text('Register Now', style: TextStyle(color: Colors.white)),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
