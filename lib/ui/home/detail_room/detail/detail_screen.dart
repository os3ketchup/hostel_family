import 'dart:io';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/network/client.dart';
import 'package:hostels/providers/hotels_provider.dart';
import 'package:hostels/ui/home/detail_room/comfortableness_item.dart';
import 'package:hostels/ui/home/detail_room/comments_item.dart';
import 'package:hostels/ui/home/detail_room/order/order_screen.dart';
import 'package:hostels/ui/home/loading_detail_screen.dart';
import 'package:hostels/variables/icons.dart';
import 'package:hostels/variables/images.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/links.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;
import 'package:gap/gap.dart' show Gap;
import 'package:share_plus/share_plus.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../../../providers/comment_provider.dart';
import '../../choose_all.dart';
import 'all_comments_screen.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen(
      {super.key, required this.hostel, required this.onNavigate});

  final Hostels hostel;
  final Function(int selectedPage) onNavigate;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String selectedImage = '';
  var isConnected = true;
  var likeTapped = false;

  @override
  void initState() {
    selectedImage = widget.hostel.imageUrls.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    double widthButton = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: mTheme.colorScheme.background,
      body: StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ConnectivityResult>? result = snapshot.data;
            if (result!.contains(ConnectivityResult.mobile)) {
              isConnected = true;
              likeTapped = false;
            } else if (result.contains(ConnectivityResult.wifi)) {
              isConnected = true;
              likeTapped = false;
            } else {
              isConnected = false;
            }
          } else {}
          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 30.o),
                child: Consumer(
                  builder: (context, ref, child) {
                    var notifier = ref.watch(commentProvider);
                    if (notifier.commentList == null) {
                      return const LoadingDetailScreen();
                    } else {
                      int count = getFilteredComment(
                          notifier.commentList!, widget.hostel)
                          .length;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildImageStack(),
                          _buildContent(notifier, count, mTheme),
                        ],
                      );
                    }
                  },
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: likeTapped && !isConnected
                    ? Container(
                  padding: EdgeInsets.all(12.o),
                  color: Colors.black,
                  width: double.infinity,
                  height: 75.o,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        maxLines: 2,
                        reaction.tr,
                        style: theme.primaryTextStyle.copyWith(
                            color: Colors.white, fontSize: 12.o),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            likeTapped = false;
                          });
                        },
                        child: Text(
                          textAlign: TextAlign.end,
                          skip.tr,
                          style: theme.primaryTextStyle.copyWith(
                              color: Colors.grey, fontSize: 10.o),
                        ),
                      ),
                    ],
                  ),
                )
                    : Container(),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(widthButton, mTheme),
    );
  }

  ////**** small widgets ****////

  Widget _buildImageStack() {
    return Stack(
      children: [
        FadeInImage(
          placeholder: MemoryImage(kTransparentImage),
          image: NetworkImage(selectedImage),
          height: 374.o,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned(
          child: _buildBackButton(),
        ),
        // Positioned(
        //   right: 0,
        //   child: _buildShareButton(),
        // ),
        Positioned(
          bottom: 0,
          child: _buildImageList(),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.5.o),
        borderRadius: BorderRadius.all(
          Radius.circular(50.o),
        ),
      ),
      margin: EdgeInsets.only(top: 40.o, left: 20.o),
      width: 40.0,
      height: 40.0,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(50.o)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.o, sigmaY: 8.o),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_sharp,
              size: 15.o,
              color: theme.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShareButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.5.o),
        borderRadius: BorderRadius.all(
          Radius.circular(50.o),
        ),
      ),
      margin: EdgeInsets.only(top: 40.o, right: 20.o),
      width: 40.o,
      height: 40.o,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(50.o)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.o, sigmaY: 8.o),
          child: IconButton(
            onPressed: () {
              Share.share(
                '${widget.hostel.name}\n ${widget.hostel.description}\n',
              );
            },
            icon: Icon(
              Icons.share,
              size: 15.o,
              color: theme.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageList() {
    return Container(
      width: 600.w - 100.w,
      height: 60.o,
      margin: EdgeInsets.only(left: 20.o, bottom: 20.o),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.hostel.imageUrls.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: selectedImage == widget.hostel.imageUrls[index]
                  ? Colors.white
                  : Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.all(Radius.circular(8.o)),
            ),
            margin: EdgeInsets.symmetric(horizontal: 6.o),
            width:
            selectedImage == widget.hostel.imageUrls[index] ? 75.o : 60.o,
            height:
            selectedImage == widget.hostel.imageUrls[index] ? 75.o : 60.o,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8.o)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8.o, sigmaY: 8.o),
                child: Container(
                  margin: EdgeInsets.all(6.o),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(6.o)),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedImage = widget.hostel.imageUrls[index];
                        });
                      },
                      child: FadeInImage(
                        placeholder: MemoryImage(kTransparentImage),
                        image: NetworkImage(widget.hostel.imageUrls[index]),
                        height: 374.o,
                        fit: BoxFit.cover,
                      ),
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

  Widget _buildContent(CommentCounter notifier, int count, ThemeData mTheme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.o),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Gap(20.o),
              _buildTitle(
                  double.tryParse(
                    widget.hostel.rating,
                  ) ??
                      0.0,
                  count,
                  mTheme),
              Gap(10.o),
              _buildDescription(mTheme),
              Gap(10.o),
              _buildComfortableness(mTheme),
              Gap(10.o),
              ChooseAllWidget(
                title: comments.tr,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return AllCommentScreen(
                        hotelId: int.tryParse(widget.hostel.id) ?? 0,
                        commentList: notifier.commentList!,
                        hostel: widget.hostel,
                      );
                    },
                  ));
                },
              ),
              Gap(10.o),
              _buildCommentsList(
                notifier.commentList!,
                // getFilteredComment(notifier.commentList!, widget.hostel)
                //     .take(3)
                //     .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(double rating, int count, ThemeData mTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTitleInfo(rating, count, mTheme),
        _buildFavoriteButton(),
      ],
    );
  }

  Widget _buildTitleInfo(double rating, int count, ThemeData mTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 600.w - 100.w,
          child: Text(
            maxLines: 2,
            widget.hostel.name,
            style: theme.primaryTextStyle.copyWith(
              fontSize: 20.o,
              fontWeight: FontWeight.w700,
              color: ThemeMode.dark == ThemeMode.light
                  ? theme.primaryColor
                  : mTheme.textTheme.headlineLarge!.color,
            ),
          ),
        ),
        Gap(10.o),
        Text(
          widget.hostel.address,
          style: theme.primaryTextStyle
              .copyWith(color: mTheme.colorScheme.primary),
        ),
        Gap(10.o),
        Consumer(
          builder: (context, ref, child) {
            var hostelNotifier = ref.watch(hostelsProvider);
            if (hostelNotifier.hostelsList != null) {
              return Row(
                children: [
                  RatingBar.builder(
                    unratedColor: Colors.amber.withOpacity(0.24),
                    ignoreGestures: true,
                    itemSize: 25.o,
                    initialRating: double.tryParse(hostelNotifier.hostelsList!
                        .firstWhere(
                            (hostels) => hostels.id == widget.hostel.id)
                        .rating) ??
                        0.0,
                    // ignoreGestures: isEditable ? false : true,
                    allowHalfRating: true,
                    direction: Axis.horizontal,
                    minRating: 1,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return const Icon(
                        Icons.star,
                        color: Colors.amber,
                      );
                    },
                    onRatingUpdate: (value) {},
                  ),
                  // SvgPicture.asset(SVGIcons.star),
                  Gap(10.o),
                  Text(
                    '${double.tryParse(hostelNotifier.hostelsList!
                        .firstWhere(
                            (hostels) => hostels.id == widget.hostel.id)
                        .rating) ??
                        0.0}',
                    style: theme.primaryTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: mTheme.colorScheme.primary),
                  ),
                  Gap(10.o),
                  Container(
                    height: 12.o,
                    width: 1.o,
                    color: theme.textFieldHintColor,
                  ),
                  Gap(10.o),
                  Text(
                    count > 1
                        ? ' $count ${commentary.tr.toLowerCase()}'
                        : ' $count ${comment.tr}',
                    style: theme.primaryTextStyle.copyWith(
                        color: ThemeMode.dark == ThemeMode.light
                            ? theme.primaryTextStyle.color
                            : mTheme.textTheme.bodyMedium!.color),
                  )
                ],
              );
            }
            return Container();
          },
        ),
      ],
    );
  }

  Widget _buildFavoriteButton() {
    return Consumer(
      builder: (context, ref, child) {
        final notifier = ref.watch(hostelsProvider);
        return isConnected
            ? GestureDetector(
          onTap: () {
            setState(() {
              setState(() {
                notifier.postFavourite(
                  hotelId: widget.hostel.id,
                );
              });
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: theme.purpleColor.withOpacity(0.1),
              borderRadius: BorderRadius.all(Radius.circular(8.o)),
            ),
            padding: EdgeInsets.all(8.o),
            child: SvgPicture.asset(
              widget.hostel.liked
                  ? SVGIcons.heart
                  : SVGIcons.outLinedHeart,
            ),
          ),
        )
            : InkWell(
          onTap: () {
            setState(() {
              setState(() {
                likeTapped = true;
              });
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: theme.purpleColor.withOpacity(0.1),
              borderRadius: BorderRadius.all(Radius.circular(8.o)),
            ),
            padding: EdgeInsets.all(8.o),
            child: SvgPicture.asset(
              SVGIcons.outLinedHeart,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDescription(ThemeData mTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          description.tr,
          style: theme.primaryTextStyle.copyWith(
              color: mTheme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18.o),
        ),
        Gap(10.o),
        Text(
          widget.hostel.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.primaryTextStyle.copyWith(
            color: mTheme.colorScheme.surface,
          ),
        ),
      ],
    );
  }

  Widget _buildComfortableness(ThemeData mTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          comfortableness.tr,
          style: theme.primaryTextStyle.copyWith(
            color: mTheme.colorScheme.primary,
            fontWeight: FontWeight.w700,
            fontSize: 18.o,
          ),
        ),
        Gap(10.o),
        _buildComfortablenessList(widget.hostel.listFeatures, mTheme),
      ],
    );
  }

  Widget _buildComfortablenessList(
      List<ActiveFeatures> activeFeatures, ThemeData mTheme) {
    return Container(
      height: 120.o,
      padding: EdgeInsets.symmetric(horizontal: 2.o, vertical: 8.o),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: theme.primaryColor.withOpacity(0.1),
        ),
        borderRadius: BorderRadius.all(Radius.circular(8.o)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.hostel.listFeatures.length,
        itemBuilder: (context, index) {
          return ComfortablenessItem(
            title: widget.hostel.listFeatures[index].name,
            mTheme: mTheme,
            imageUrl: widget.hostel.listFeatures[index].imageUrl,
          );
        },
      ),
    );
  }

  Widget _buildCommentsList(
      List<Comment> comments,
      ) {
    return SizedBox(
      height: 200.o,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: comments.length,
        itemBuilder: (context, index) {
          return CommentsItem(
            comment: comments[index],
            rating: double.tryParse(comments[index].rating) ?? 0.0,
            width: 0.85,
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar(double widthButton, ThemeData mTheme) {
    return PreferredSize(
      preferredSize: Size.fromHeight(65.o),
      child: Container(
        decoration: BoxDecoration(
          color: ThemeMode.dark == ThemeMode.light
              ? Colors.white
              : mTheme.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 10.o,
              blurRadius: 10.o,
              offset: Offset(12.o, 8.o),
            ),
          ],
        ),
        height: Platform.isIOS ? 95.o : 65.o,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildPriceInfo(mTheme),
            _buildOrderButton(widthButton, widget.hostel.id, mTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceInfo(ThemeData mTheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(10.o),
        Text(
          price.tr,
          style: theme.hintTextFieldStyle.copyWith(
              color: mTheme.colorScheme.surface, fontWeight: FontWeight.w500),
        ),
        RichText(
          text: TextSpan(
            children: [
              if (widget.hostel.originalPrice.length == 7) ...[
                TextSpan(
                  text: widget.hostel.originalPrice.substring(0, 3),
                  style: theme.primaryTextStyle.copyWith(
                    fontSize: 18.o,
                    color: mTheme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: widget.hostel.originalPrice.substring(3, 7),
                  style: theme.primaryTextStyle.copyWith(
                    fontSize: 12.o,
                    color: mTheme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ] else if (widget.hostel.originalPrice.length == 8) ...[
                TextSpan(
                  text: widget.hostel.originalPrice.substring(0, 1),
                  style: theme.primaryTextStyle.copyWith(
                    fontSize: 18.o,
                    color: mTheme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: widget.hostel.originalPrice.substring(1, 3),
                  style: theme.primaryTextStyle.copyWith(
                    fontSize: 18.o,
                    color: mTheme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: widget.hostel.originalPrice.substring(3, 7),
                  style: theme.primaryTextStyle.copyWith(
                    fontSize: 12.o,
                    color: mTheme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderButton(
      double widthButton, String hotelId, ThemeData mTheme) {
    return Container(
      margin: Platform.isIOS
          ? EdgeInsets.only(bottom: 30.o)
          : const EdgeInsets.only(bottom: 0),
      width: widthButton * 0.7,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: mTheme.colorScheme.primary,
        ),
        onPressed: () {
          getAllOrder();
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return OrderScreen(
                hotelId: hotelId,
                onNavigate: widget.onNavigate,
              );
            },
          ));
        },
        child: Text(
          choosingRoom.tr,
          style: theme.primaryTextStyle.copyWith(color: theme.white),
        ),
      ),
    );
  }

  List<Comment> getFilteredComment(List<Comment> allComment, Hostels hostel) {
    List<Comment> filteredComment = [];
    for (var comment in allComment) {
      if (comment.hotelId == hostel.name) {
        filteredComment.add(comment);
      }
    }
    return filteredComment;
  }

  void getAllOrder() {
    client.get(Links.getAllOrder).then((value) {});
  }
}
