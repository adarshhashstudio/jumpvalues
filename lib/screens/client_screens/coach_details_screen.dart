import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jumpvalues/main.dart';
import 'package:jumpvalues/models/client_profile_response_model.dart';
import 'package:jumpvalues/models/service_resource.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/screens/dashboard/client_fragments/client_add_slots.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:jumpvalues/widgets/common_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class CoachDetailsScreen extends StatefulWidget {
  const CoachDetailsScreen({super.key, required this.coachDetail});
  final ServiceResource coachDetail;

  @override
  State<CoachDetailsScreen> createState() => _CoachDetailsScreenState();
}

class _CoachDetailsScreenState extends State<CoachDetailsScreen> {
  ClientProfileResponseModel? userData;
  bool loader = false;
  final preferVia = 'phone';

  Future<void> getUser() async {
    setState(() {
      loader = true;
    });
    try {
      var response = await getUserClientDetails(appStore.userId ?? -1);
      if (response?.status == true) {
        setState(() {
          userData = response;
        });
        setState(() {});
      } else {
        if (response?.message != null) {
          SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
              response?.message ?? errorSomethingWentWrong);
        }
      }
    } catch (e) {
      debugPrint('getUser Error: $e');
    } finally {
      setState(() {
        loader = false;
      });
    }
  }

  Future<void> refreshData() async {
    await getUser();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: Colors.grey,
              height: 0.5,
            ),
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 14.0),
              child: Icon(Icons.arrow_back_ios_new),
            ),
          ),
          centerTitle: true,
          title: Text(
            'Coach Details',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: textColor.withOpacity(0.8),
                fontSize: 20),
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: refreshData,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: SafeArea(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildProfilePicWidget(context),
                              additionalDetails(context)
                                  .paddingSymmetric(horizontal: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: button(context, onPressed: () async {
                        if (loader) {
                        } else {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ClientAddSlots(),
                            ),
                          );
                        }
                      }, text: 'Hire Me'),
                    ),
                  ],
                ),
              ),
              if (loader)
                Container(
                    color: Colors.transparent,
                    child: const Center(child: CircularProgressIndicator()))
            ],
          ),
        ),
      );

  Container buildProfilePicWidget(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        child: Row(
          children: [
            Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  border: Border.all(width: 1, color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(360),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(360),
                  child: CachedNetworkImage(
                    imageUrl: widget.coachDetail.avatar ??
                        'https://picsum.photos/200/300',
                    fit: BoxFit.cover,
                    placeholder: (context, _) => Center(
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                )),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.08,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.coachDetail.firstName} ${widget.coachDetail.lastName}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (preferVia == 'email')
                      const Icon(
                        Icons.check_circle,
                        color: greenColor,
                        size: 20,
                      ),
                    if (preferVia == 'email')
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        '${widget.coachDetail.email}',
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Row(
                  children: [
                    if (preferVia == 'phone')
                      const Icon(
                        Icons.check_circle,
                        color: greenColor,
                        size: 20,
                      ),
                    if (preferVia == 'phone')
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        '+1-404-724-1937',
                        style: TextStyle(fontSize: 14, color: primaryColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );

  Widget additionalDetails(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          singleDetailWidget(context, 'Certifications',
              'Certified Professional in Training Management (CPTM)'),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          singleDetailWidget(context, 'Philosophy',
              'Personal development, Be Yourself, Integrity, Mutual respect, Take accountability, Leadership'),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          singleDetailWidget(
              context, 'Bio', 'Expert In Personality Development'),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          singleDetailWidget(context, 'Education', 'Phd'),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          singleDetailWidget(context, 'Prefer Via', '$preferVia'),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          singleDetailWidget(
            context,
            'Industries Served',
            'Sports',
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          singleDetailWidget(
            context,
            'Year of Coaching',
            '8',
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          singleDetailWidget(
            context,
            'Niche',
            'N/A',
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
        ],
      );

  Widget singleDetailWidget(BuildContext context, String label, String text) =>
      labelContainer(
        label: label,
        text: text,
        width: MediaQuery.of(context).size.width * 1,
        alignment: Alignment.centerLeft,
        height: null,
        labelContainerSpace: 6,
        borderRadius: BorderRadius.circular(10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      );
}
