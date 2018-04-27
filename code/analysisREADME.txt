INTRODUCTION

    This project was done by Vail Dorchester and Jackson Mediavilla.

    The goal was to analyze baseball data and learn what factors influence
    player performance.

    I've decided to make this readme for the analysis code to document some of the
    decisions and thought processes I went through. This will hopefully help
    in writing the report and also in making the code more understandable.
    This is honestly more for my own good than anything, because it's easy
    to get lost in the details and forget the big picture of what you've done
    and what you're trying to do.

    Basically, the way it's set up now, I've defined functions to generate the
    data and to prune the data. Right now, we are dealing with two datasets --
    one of all of the event files, and one of the game logs. I will probably
    pull some weather data later.

DATA DESCRIPTION

    -- Event Data --
    The event data contains information on
    every EVENT. To clarify, a regular pitch is not an event. Only things like
    hits, stolen bases, outs, etc. Pretty much anything except regular pitches,
    because that would make the data way too large. This data contains really
    any information you could possible be interested in to the point where it's
    kind of excessive. For example, who was playing every single position
    when the play occurred, who contributed to fielding the ball and in what
    order, etc. The data is organized in files for each team and year. The data
    also contains which game the play took place in, which was important for
    matching this data to the game log data and weather data.

    -- Game Logs --
    The game logs are general summaries of each game -- scores, totals, dates,
    lineups, team stats, time of day, field, etc. It also contained all of the
    umpire information, the team rosters, and the lineups. Mostly, I wanted
    the offensive and defensive game summaries, the dates, attendance,
    time of day, park ID (for weather location), etc.


DATA GATHERING

    -- Summary --
    Basically, we wanted to analyze player performance, so we figured the data
    that would be useful for this would be event data, game logs, and weather
    data, where the weather is an outside factor chosen to compare to player
    performance. All of the baseball data came from retrosheet.org.

    -- Event Data --
    The event data was originally in a ton of poorly formatted text files on
    retrosheet.org. We downloaded files from 1950-present day, and then used
    functions included in retrosheet called BEVENT to format the data into CSV
    files. First, I wrote a bash script to find the paths of all of the event
    files and store those paths in a separate file, the path file. This path
    file was then loaded in python and each line was read and opened and
    imported into a csv. The dataset is rather large (~10M rows), so I added
    a subframe option to the method where you can specify how many files you
    want to include. By default, it is 50. -1 gets all of the files.

    -- Game Log Data --
    This data was also on retrosheet.org. I downloaded a bunch of text files
    where each file contains the game logs for a year. They came in folders by
    the decade. To import this, I wrote a python method that basically uses
    os.listdir to list all of the files in the folder, and I had a path defined
    for the folder that holds all of the game log subfolders. Then, I defined
    the start year of 1950 and end year of 2017, and basically just iterated
    over each decade folder to see if the start date was more recent or equal
    to the range of the decade folder. If so, I opened the folder and imported
    all game logs that were more recent than out start date. Looking back,
    this was probably way more efficient and easier than writing bash scripts
    and moving a bunch of folders around. At the same time, this data was also
    already in CSV format (though it was in __.txt files), so it was easier
    to import and required less processing.

    -- Park Info --
    This was extremely simple. I just downloaded a text file in CSV format
    with all of the park codes and information, then imported it into a single
    dataframe.

DATA PRE-PROCESSING

    -- Summary --
    For the data preprocessing, most of the work involved pruning the data,
    reformatting some features, and making the data smaller in terms of memory
    usage so that analysis was easier, more streamlined, and also faster
    computationally. A lot of this was dropping unnecessary columns because
    the data contained way more information than we needed.

    -- Event Data --
    Preprocessing the event data consisted largely of removing irrelevant
    features. This was done by manually reading over the data descriptions
    on retrosheet and finding the columns that were not related. This was
    mostly things like who played each and every position, where the ball was
    hit, errors made, etc. Since our main metrics are batting average and
    batting average against, we weren't really concerned with anything that
    happened after the batter hit the ball or struck out. I kept information
    on whether or not it was a single, double, etc, and also on RBI, and other
    base stats, but the player and detailed play info -- most of the features --
    was removed.

    After pruning, I looked at any fields that could be converted to categories
    and then integers. This included lots of flags and binary fields such as
    which hand the batter used, which hand the pitcher used, and flags for
    bunt, whether the event ended the batters appearance, and things of that
    nature. Originally, I left the individual player codes intact because I
    thought we might use them later on. However, after stepping back and
    thinking about it, this project is more interested in overall trends as
    opposed to specifics like player names, so I may end up converting the name
    information and specific codes to integers as well that act as IDs. That
    would probably save a significant amount of space and processing time.

    Doing this, I was able to reduce the physical memory usage of the data
    by ~85%, but I think I could reduce it by even more by casting the
    other categorical data to ints as well. Update: Got the data reduced by
    about 89% in size. Decided to keep player names and park codes, and team
    codes as strings so that they will reference across data sets. more
    easily.

    Finally, after casting categorical data to integers, I used cat.codes and
    pandas.to_numeric() to reduce the integers to their smallest form without
    data loss.

    Then I did the same to floats.

    -- Game Log Data --
    For this, I did basically the exact same thing that I did to the event data.
    The ONLY difference is which specific fields were dropped or converted to
    integers.

    -- Park Info --
    No preprocessing needed.
