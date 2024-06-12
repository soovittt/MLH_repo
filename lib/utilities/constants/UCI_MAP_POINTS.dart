import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:notifyme/classes/MapLocation.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

// ignore: non_constant_identifier_names
Map<String, List<MapLocation>> LOCATION_POINTS = {
  "Arts": [
    MapLocation(
      address: "Quad, 714 Arts, Irvine, CA 92697",
      image: "assets/schools/arts/ACT.jpeg",
      location:
          Position(-117.84394668384503, 33.64985963273532), // Reverse the order
      title: "Art Culture & Technology (ACT)",
    ),
    MapLocation(
      address:
          "Claire Trevor School of the Arts, University of California, Irvine, Irvine, CA 92697",
      image: "assets/schools/arts/art_studio.jpeg",
      location:
          Position(-117.84483295253052, 33.6505461289739), // Reverse the order
      title: "Art Studio (ART)",
    ),
    MapLocation(
      image: "assets/schools/arts/art_annex.jpeg",
      location:
          Position(-117.84671783564748, 33.64727936009988), // Reverse the order
      title: "Arts Annex (ARAN)",
    ),
    MapLocation(
      image: "assets/schools/arts/aitr.jpeg",
      location:
          Position(-117.84252396008468, 33.65063195573833), // Reverse the order
      title: "Arts Instruction & Technology Resource Center (AITR)",
    ),
    MapLocation(
      image: "assets/schools/arts/choral.jpeg",
      location:
          Position(-117.84412989700873, 33.65053245483928), // Reverse the order
      title: "Choral Studio",
    ),
    MapLocation(
      address: "UC Irvine - Building #711, Irvine, CA 92617",
      image: "assets/schools/arts/claire_trevor_theater.jpeg",
      location:
          Position(-117.84533662652476, 33.64938487027157), // Reverse the order
      title: "Claire Trevor Theatre (CTT)",
    ),
    MapLocation(
      address: "Contemporary Arts Center, Loading Area, Irvine, CA 92617",
      image: "assets/schools/arts/contemporary_arts_center.jpeg",
      location:
          Position(-117.84534216089949, 33.65023925025151), // Reverse the order
      title: "Contemporary Arts Center (CAC)",
    ),
    MapLocation(
      image: "assets/schools/arts/Drama_Building.jpeg",
      location:
          Position(-117.844672816721, 33.65071069383971), // Reverse the order
      title: "Drama Building (DRA)",
    ),
    MapLocation(
      address: "523 Humanities Ct, Irvine, CA 92617",
      image: "assets/schools/arts/humanities_interim.jpeg",
      location:
          Position(-117.84682553206397, 33.64719244083952), // Reverse the order
      title:
          "Humanities Interim Classroom Facility (HICF) | Studio Art Trailer",
    ),
    MapLocation(
      address: "4242 Campus Dr, Irvine, CA 92612",
      image: "assets/schools/arts/Irvine_Barclay_Theatre.jpg",
      location: Position(
          -117.84087467624232, 33.649353365481105), // Reverse the order
      title: "Irvine Barclay Theatre",
    ),
    MapLocation(
      image: "assets/schools/arts/little_theater.jpeg",
      location:
          Position(-117.84526817797577, 33.64970125635549), // Reverse the order
      title: "Little Theatre",
    ),
    MapLocation(
      address: "4002 Mesa Rd, Irvine, CA 92617",
      image: "assets/schools/arts/Mesa_Arts_Building.jpeg",
      location: Position(
          -117.84628694125848, 33.650305161060565), // Reverse the order
      title: "Mesa Arts Building (MAB)",
    ),
    MapLocation(
      address: "Mesa Rd, Irvine, CA 92617",
      image: "assets/schools/arts/Music_and_Media_Building.JPG",
      location: Position(
          -117.84454688166821, 33.650055636794534), // Reverse the order
      title: "Music & Media Building (MM)",
    ),
    MapLocation(
      address: "723 Mesa Rd, Irvine, CA 92617",
      image: "assets/schools/arts/Production_Studio.jpeg",
      location:
          Position(-117.84612238905277, 33.65077770092765), // Reverse the order
      title: "Production Studio",
    ),
    MapLocation(
      address: "UCI Arts, Irvine, CA 92617",
      image: "assets/schools/arts/Robert_Cohen_Theatre_and_Dance_Studios.jpeg",
      location:
          Position(-117.8452156282613, 33.65026583327919), // Reverse the order
      title: "Robert Cohen Theatre & Dance Studios (DS)",
    ),
    MapLocation(
      address: "Loading Area, Irvine, CA 92617",
      image: "assets/schools/arts/SCS_Nixon_Theatre.jpeg",
      location:
          Position(-117.84191433054526, 33.65089753154596), // Reverse the order
      title: "Sculpture & Ceramic Studios (SCS) | Nixon Theatre",
    ),
    MapLocation(
      address: "725 Arts Ct, Irvine, CA 92617",
      image: "assets/schools/arts/Studio_Four.jpeg",
      location:
          Position(-117.84586581234907, 33.65075108406584), // Reverse the order
      title: "Studio Four (STU4)",
    ),
    MapLocation(
      address:
          "University of California, Irvine, Claire Trevor School of the Arts, 712 Arts Plaza, Irvine, CA 92697",
      image:
          "assets/schools/arts/University_Art_Gallery_and_Beall_Center_for_Art_and_Technology.jpeg",
      location:
          Position(-117.84421391388564, 33.64996699962823), // Reverse the order
      title: "University Art Gallery (UAG) | Beall Center for Art + Technology",
    ),
    MapLocation(
      address: "728 Arts Ct, Irvine, CA 92617",
      image: "assets/schools/arts/William_J_Gillespie_Performance_Studios.jpeg",
      location: Position(-117.845631804393, 33.65171051341192),
      title: "William J. Gillespie Performance Studios (PSTU)",
    ),
    MapLocation(
      address: "710 Arts Quad, Irvine, CA 92617",
      image: "assets/schools/arts/Winifred_Smith_Hall.jpeg",
      location: Position(-117.84444263887637, 33.649562687892136),
      title: "Winifred Smith Hall (WSH)",
    ),
    MapLocation(
      image: "assets/schools/arts/Yurt_Dance_Studio.jpeg",
      location: Position(-117.8282092276939, 33.642800078409934),
      title: "Yurt Dance Studio",
    ),
  ],
};
