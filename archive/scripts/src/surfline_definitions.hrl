% TODO (make this library application or something)
% https://erlanglabnotes.wordpress.com/2013/08/31/now-you-too-can-share-erlang-hrl-files-across-muliple-applications/
-record(spot, {internal_id,
               surfline_url,
               surfline_spotId,
               display_name}).

-define(Surfline_definitions,
        [#spot{internal_id=humboldt,
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
               display_name="SF / San Mateo County"}
        ]).
