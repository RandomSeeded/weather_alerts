-record(spot, {internal_id,
               surfline_url,
               surfline_spotId,
               display_name}).

-define(Surfline_qualities,
        #{
          "flat" => 1,
          "very poor" => 2,
          "poor" => 3,
          "poor to fair" => 4,
          "fair" => 5,
          "fair to good" => 6,
          "good" => 7,
          "very good" => 8,
          "good to epic" => 9,
          "epic" => 10
         }
       ).

-define(Surfline_definitions,
        [
         #spot{internal_id=oregon,
               surfline_spotId=2138,
               surfline_url="http://www.surfline.com/surf-forecasts/pacific-northwest/oregon_2138/",
               display_name="Oregon"},
         #spot{internal_id=humboldt,
               surfline_spotId=2139,
               surfline_url="http://www.surfline.com/surf-forecasts/northern-california/humboldt_2139/",
               display_name="Humboldt County"},
         #spot{internal_id=marin,
               surfline_url="http://www.surfline.com/surf-forecasts/northern-california/marin-county_2949/",
               surfline_spotId=2949,
               display_name="Marin County"},
         #spot{internal_id=sonoma,
               surfline_url="http://www.surfline.com/surf-forecasts/northern-california/sonoma-county_2948/",
               surfline_spotId=2948,
               display_name="Marin County"},
         #spot{internal_id=mendocino,
               surfline_url="http://www.surfline.com/surf-forecasts/northern-california/mendocino-county_2947/",
               surfline_spotId=2947,
               display_name="Sonoma County"},
         #spot{internal_id=sf,
               surfline_url="http://www.surfline.com/surf-forecasts/northern-california/sf-san-mateo-county_2957/",
               surfline_spotId=2957,
               display_name="SF / San Mateo County"},
         #spot{internal_id=santa_cruz,
               surfline_url="http://www.surfline.com/surf-forecasts/central-california/santa-cruz_2958/",
               surfline_spotId=2958,
               display_name="Santa Cruz"},
         #spot{internal_id=monterey,
               surfline_url="http://www.surfline.com/surf-forecasts/central-california/monterey_2959/",
               surfline_spotId=2959,
               display_name="Monterey"},
         #spot{internal_id=slo,
               surfline_url="http://www.surfline.com/surf-forecasts/central-california/san-luis-obispo-county_2962/",
               surfline_spotId=2962,
               display_name="San Luis Obisbo County"},
         #spot{internal_id=santa_barbara,
               surfline_url="http://www.surfline.com/surf-forecasts/southern-california/santa-barbara_2141/",
               surfline_spotId=2141,
               display_name="Santa Barbara"},
         #spot{internal_id=ventura,
               surfline_url="http://www.surfline.com/surf-forecasts/southern-california/ventura_2952/",
               surfline_spotId=2952,
               display_name="Ventura"},
         #spot{internal_id=north_los_angeles,
               surfline_url="http://www.surfline.com/surf-forecasts/southern-california/north-los-angeles_2142/",
               surfline_spotId=2142,
               display_name="North Los Angeles"},
         #spot{internal_id=south_los_angeles,
               surfline_url="http://www.surfline.com/surf-forecasts/southern-california/south-los-angeles_2951/",
               surfline_spotId=2951,
               display_name="South Los Angeles"},
         #spot{internal_id=north_orange_county,
               surfline_url="http://www.surfline.com/surf-forecasts/southern-california/north-orange-county_2143/",
               surfline_spotId=2143,
               display_name="North Orange County"},
         #spot{internal_id=south_orange_county,
               surfline_url="http://www.surfline.com/surf-forecasts/southern-california/south-orange-county_2950/",
               surfline_spotId=2950,
               display_name="South Orange County"},
         #spot{internal_id=north_san_diego,
               surfline_url="http://www.surfline.com/surf-forecasts/southern-california/north-san-diego_2144/",
               surfline_spotId=2144,
               display_name="North San Diego"},
         #spot{internal_id=south_san_diego,
               surfline_url="http://www.surfline.com/surf-forecasts/southern-california/south-san-diego_2953/",
               surfline_spotId=2953,
               display_name="South San Diego"},
         #spot{internal_id=nh_maine,
               surfline_url="http://www.surfline.com/surf-forecasts/new-england/new-hampshire---maine_20897/",
               surfline_spotId=20897,
               display_name="New Hampshire - Maine"},
         #spot{internal_id=cape_cod,
               surfline_url="http://www.surfline.com/surf-forecasts/new-england/cape-cod_2145/",
               surfline_spotId=2145,
               display_name="Cape Cod"},
         #spot{internal_id=rhode_island,
               surfline_url="http://www.surfline.com/surf-forecasts/new-england/rhode-island_20914/",
               surfline_spotId=20914,
               display_name="Rhode Island"},
         #spot{internal_id=suffolk,
               surfline_url="http://www.surfline.com/surf-forecasts/long-island/suffolk-county_2146/",
               surfline_spotId=2146,
               display_name="Suffolk County"},
         #spot{internal_id=nassau_queens,
               surfline_url="http://www.surfline.com/surf-forecasts/long-island/nassau---queens-county_131699/",
               surfline_spotId=131699,
               display_name="Nassau - Queens County"},
         #spot{internal_id=new_jersey,
               surfline_url="http://www.surfline.com/surf-forecasts/mid-atlantic/new-jersey_2147/",
               surfline_spotId=2147,
               display_name="New Jersey"},
         #spot{internal_id=maryland_delaware,
               surfline_url="http://www.surfline.com/surf-forecasts/mid-atlantic/maryland-delaware_2148/",
               surfline_spotId=2148,
               display_name="Maryland - Delaware"},
         #spot{internal_id=virginia,
               surfline_url="http://www.surfline.com/surf-forecasts/virginia---outer-banks/virginia_2149/",
               surfline_spotId=2149,
               display_name="Virginia"},
         #spot{internal_id=northern_outer_banks,
               surfline_url="http://www.surfline.com/surf-forecasts/virginia---outer-banks/northern-outer-banks_2150/",
               surfline_spotId=2150,
               display_name="Northern Outer Banks"},
         #spot{internal_id=hatteras_island,
               surfline_url="http://www.surfline.com/surf-forecasts/virginia---outer-banks/hatteras-island_129661/",
               surfline_spotId=129661,
               display_name="Hatteras Island"},
         #spot{internal_id=new_hanover,
               surfline_url="http://www.surfline.com/surf-forecasts/southeast/south-onslow---new-hanover_126153/",
               surfline_spotId=126153,
               display_name="New Hanover"},
         #spot{internal_id=south_carolina,
               surfline_url="http://www.surfline.com/surf-forecasts/southeast/south-carolina_2152/",
               surfline_spotId=2152,
               display_name="South Carolina"},
         #spot{internal_id=north_florida,
               surfline_url="http://www.surfline.com/surf-forecasts/florida/north-florida_2153/",
               surfline_spotId=2153,
               display_name="North Florida"},
         #spot{internal_id=central_florida,
               surfline_url="http://www.surfline.com/surf-forecasts/florida/central-florida_2154/",
               surfline_spotId=2154,
               display_name="Central Florida"},
         #spot{internal_id=treasure_coast_palm_beach,
               surfline_url="http://www.surfline.com/surf-forecasts/florida/treasure-coast---palm-beach_2155/",
               surfline_spotId=2155,
               display_name="Treasure Coast - Palm Beach"},
         #spot{internal_id=broward_miami_dade,
               surfline_url="http://www.surfline.com/surf-forecasts/florida/broward---miami-dade_121124/",
               surfline_spotId=121124,
               display_name="Broward - Miami Dade"},
         #spot{internal_id=west_florida,
               surfline_url="http://www.surfline.com/surf-forecasts/florida-gulf/west-florida_2156/",
               surfline_spotId=2156,
               display_name="Florida Gulf - West Florida"},
         #spot{internal_id=panhandle,
               surfline_url="http://www.surfline.com/surf-forecasts/florida-gulf/panhandle_2172/",
               surfline_spotId=2172,
               display_name="Florida Gulf - Panhandle"},
         #spot{internal_id=oahu_north_shore,
               surfline_url="http://www.surfline.com/surf-forecasts/oahu/north-shore_2132/",
               surfline_spotId=2132,
               display_name="Oahu - North Shore"},
         #spot{internal_id=oahu_west_side,
               surfline_url="http://www.surfline.com/surf-forecasts/oahu/west-side_2133/",
               surfline_spotId=2133,
               display_name="Oahu - West Side"},
         #spot{internal_id=oahu_south_shore,
               surfline_url="http://www.surfline.com/surf-forecasts/oahu/south-shore_2134/",
               surfline_spotId=2134,
               display_name="Oahu - South Shore"},
         #spot{internal_id=oahu_windward_side,
               surfline_url="http://www.surfline.com/surf-forecasts/oahu/windward-side_2135/",
               surfline_spotId=2135,
               display_name="Oahu - Windward Side"},
         #spot{internal_id=maui_south,
               surfline_url="http://www.surfline.com/surf-forecasts/maui/maui-south_3239/",
               surfline_spotId=3239,
               display_name="Maui South"},
         #spot{internal_id=hawaii_kona,
               surfline_url="http://www.surfline.com/surf-forecasts/big-island-hawaii/hawaii-kona_8904/",
               surfline_spotId=8904,
               display_name="Hawaii Kona"},
         #spot{internal_id=ensenada,
               surfline_url="http://www.surfline.com/surf-forecasts/northern-baja/ensenada_2158/",
               surfline_spotId=2158,
               display_name="Ensenada"},
         #spot{internal_id=southern_points,
               surfline_url="http://www.surfline.com/surf-forecasts/southern-baja/southern-points-region_2976/",
               surfline_spotId=2976,
               display_name="Southern Baja - Southern Points"},
         #spot{internal_id=cabo,
               surfline_url="http://www.surfline.com/surf-forecasts/southern-baja/cabo_2159/",
               surfline_spotId=2159,
               display_name="Cabo"},
         #spot{internal_id=mazatlan,
               surfline_url="http://www.surfline.com/surf-forecasts/northern-mexico/mazatlan-area_3308/",
               surfline_spotId=3308,
               display_name="Northern Mexico - Mazatlan"},
         #spot{internal_id=riviera_nayarit,
               surfline_url="http://www.surfline.com/surf-forecasts/northern-mexico/riviera-nayarit-area_2160/",
               surfline_spotId=2160,
               display_name="Northern Mexico - Riveria Nayarit Area"},
         #spot{internal_id=puerto_escondido,
               surfline_url="http://www.surfline.com/surf-forecasts/southern-mexico/puerto-escondido-area_2742/",
               surfline_spotId=2742,
               display_name="Southern Mexico - Puerto Escondido"},
         #spot{internal_id=huatulco,
               surfline_url="http://www.surfline.com/surf-forecasts/southern-mexico/huatulco-area_16175/",
               surfline_spotId=16175,
               display_name="Southern Mexico - Huatulco Area"}
        ]).

