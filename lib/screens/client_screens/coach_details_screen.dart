import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jumpvalues/main.dart';
import 'package:jumpvalues/models/available_coaches_response_model.dart';
import 'package:jumpvalues/models/client_profile_response_model.dart';
import 'package:jumpvalues/screens/dashboard/client_fragments/client_add_slots.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:jumpvalues/widgets/common_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class CoachDetailsScreen extends StatefulWidget {
  const CoachDetailsScreen({super.key, required this.coachDetail});
  final AvailableCoaches coachDetail;

  @override
  State<CoachDetailsScreen> createState() => _CoachDetailsScreenState();
}

class _CoachDetailsScreenState extends State<CoachDetailsScreen> {
  ClientProfileResponseModel? userData;

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
              Column(
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
                      if (appStore.additionalSponsor.isNotEmpty) {
                        showUpgradeSponsorshipDialog(context);
                      } else {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ClientAddSlots(
                                coachId: widget.coachDetail.id ?? -1),
                          ),
                        );
                      }
                    }, text: 'Hire Me'),
                  ),
                ],
              ),
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
                    imageUrl: getImageUrl(widget.coachDetail.dp),
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
                  '${widget.coachDetail.firstName ?? ''} ${widget.coachDetail.lastName ?? ''}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.coachDetail.preferVia == 1)
                      const Icon(
                        Icons.check_circle,
                        color: greenColor,
                        size: 20,
                      ),
                    if (widget.coachDetail.preferVia == 1)
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        '${widget.coachDetail.email ?? 'N/A'}',
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
                if (widget.coachDetail.countryCode != null &&
                    widget.coachDetail.phone != null)
                  Row(
                    children: [
                      if (widget.coachDetail.preferVia == 2)
                        const Icon(
                          Icons.check_circle,
                          color: greenColor,
                          size: 20,
                        ),
                      if (widget.coachDetail.preferVia == 2)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          '${widget.coachDetail.countryCode ?? ''} ${numberToMaskedText(widget.coachDetail.phone.toString())}',
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
              '${widget.coachDetail.certifications ?? 'N/A'}'),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          singleDetailWidget(context, 'Philosophy',
              '${widget.coachDetail.philosophy ?? 'N/A'}'),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          singleDetailWidget(
              context, 'Education', '${widget.coachDetail.education ?? 'N/A'}'),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          singleDetailWidget(context, 'Prefer Via',
              '${widget.coachDetail.preferVia == 2 ? 'Phone' : 'Email'}'),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          singleDetailWidget(
            context,
            'Industries Served',
            '${widget.coachDetail.industriesServed ?? 'N/A'}',
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          singleDetailWidget(
            context,
            'Year of Coaching',
            '${widget.coachDetail.experience ?? '0'}',
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          singleDetailWidget(
            context,
            'Niche',
            '${widget.coachDetail.niche ?? 'N/A'}',
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
