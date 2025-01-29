import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Details_Model/details_Screen.dart';
import 'Search_button/custom_search.dart';
import 'campaign_model.dart';

class CampaignPost extends StatefulWidget {
  const CampaignPost({Key? key}) : super(key: key);

  @override
  _CampaignPostState createState() => _CampaignPostState();
}

class _CampaignPostState extends State<CampaignPost> {
  late StreamSubscription<List<CampaignModel>> _subscription;
  late Stream<List<CampaignModel>> _campaignStream;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _campaignStream = _fetchCampaignsFromFirebase();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Stream<List<CampaignModel>> _fetchCampaignsFromFirebase() {
    return FirebaseFirestore.instance.collection('campaigns').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final moreImagesUrl = doc['moreImagesUrl'];
        final imageUrlList = moreImagesUrl is List ? moreImagesUrl : [moreImagesUrl]; // Ensure it's always a list

        return CampaignModel(
          imageUrl: doc['imageUrl'],
          place: doc['place'],
          name: doc['name'],
          endDate: doc['endDate'],
          startDate: doc['startDate'],
          docId: doc.id,
          startTime: doc['startTime'],
          endTime: doc['endTime'],
          moreImagesUrl: imageUrlList.map((url) => url as String).toList(),
        );
      }).toList();
    });
  }

  Widget _buildCampaign(BuildContext context, CampaignModel campaign) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailsScreen(camp: campaign),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white
          ),
          height: 280,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      campaign.imageUrl,
                      height: 180,
                      width: size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          '${campaign.name}',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            campaign.place,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'START ON : ${campaign.startDate} - ',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.red
                          ),
                        ),
                        Text(
                          '${campaign.endDate}',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.red
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  void _onSearch(String searchText) {
    setState(() {
      _searchText = searchText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20,),
        SearchField(onSearch: _onSearch),
        Expanded(
          child: StreamBuilder<List<CampaignModel>>(
            stream: _campaignStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                List<CampaignModel>? campaigns = snapshot.data;
                if (campaigns != null && campaigns.isNotEmpty) {
                  List<CampaignModel> filteredCampaigns = campaigns.where((campaign) =>
                      _matchesSearchText(campaign)
                  ).toList();
                  if (filteredCampaigns.isNotEmpty) {
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: filteredCampaigns.length,
                      itemBuilder: (context, index) {
                        return _buildCampaign(context, filteredCampaigns[index]);
                      },
                    );
                  } else {
                    return Center(
                      child: Text('No matching campaigns found.'),
                    );
                  }
                } else {
                  return Center(
                    child: Text('No campaigns available.'),
                  );
                }
              }
            },
          ),
        ),
      ],
    );
  }

  bool _matchesSearchText(CampaignModel campaign) {
    String searchText = _searchText.toLowerCase();
    List<String> searchTerms = searchText.split(' ');

    // Check if any term matches any part of the campaign details
    return searchTerms.every((term) =>
    campaign.name.toLowerCase().contains(term) ||
        campaign.place.toLowerCase().contains(term) ||
        campaign.endDate.toLowerCase().contains(term) ||
        campaign.startDate.toLowerCase().contains(term)
    );
  }
}