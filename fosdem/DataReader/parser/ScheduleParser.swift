//
//  XMLParser.swift
//  fosdem
//
//  Created by Houman Brinjcargorabi on 17/06/2018.
//  Copyright © 2018 Hbrinj. All rights reserved.
//

import Foundation
import SwiftyXMLParser

class ScheduleParser {
    private var input:InputStream
    required init(input: InputStream) {
        self.input = input
    }
    
    var someshit: String = """
    <schedule>
    <conference>
    <title>FOSDEM 2018</title>
    <subtitle/>
    <venue>ULB (Université Libre de Bruxelles)</venue>
    <city>Brussels</city>
    <start>2018-02-03</start>
    <end>2018-02-04</end>
    <days>2</days>
    <day_change>09:00:00</day_change>
    <timeslot_duration>00:05:00</timeslot_duration>
    </conference>
    <day index="1" date="2018-02-03">
    <room name="Janson">
    <event id="7294">
    <start>09:30</start>
    <duration>00:25</duration>
    <room>Janson</room>
    <slug>keynotes_welcome</slug>
    <title>Welcome to FOSDEM 2018</title>
    <subtitle>derp</subtitle>
    <track>Keynotes</track>
    <type>keynote</type>
    <language/>
    <abstract>&lt;p&gt;FOSDEM welcome and opening talk.&lt;/p&gt;</abstract>
    <description>&lt;p&gt;Welcome to FOSDEM 2018!&lt;/p&gt;</description>
    <persons>
    <person id="6">FOSDEM Staff</person>
    </persons>
    <links>
    <link href="https://submission.fosdem.org/feedback/7294.php">Submit feedback</link>
    </links>
    </event>
    <event id="6245">
    <start>10:00</start>
    <duration>00:50</duration>
    <room>Janson</room>
    <slug>osi</slug>
    <title>Consensus as a Service</title>
    <subtitle>Twenty Years of OSI Stewardship</subtitle>
    <track>Keynotes</track>
    <type>keynote</type>
    <language/>
    <abstract>&lt;p&gt;The Open Source label was born in February 1998 as a new way to popularise free software for business adoption. OSI will celebrate its 20th Anniversary on February 3, 2018, during the opening day of FOSDEM 2018. The presentation will summarize the evolution of open source licences and the Open Source Definition (OSD) across two decades, explain why the concept of free open source software has grown in both relevance and popularity and explore trends for the third decade of open source.&lt;/p&gt;</abstract>
    <description>&lt;p&gt;Open source software is now ubiquitous, recognized across industries as a fundamental component to infrastructure, as well as a critical factor for driving innovation. Over the past twenty years, the OSI has worked to promote and protect open source software, development, and communities, championing software freedom in society through education, collaboration, and infrastructure, stewarding the Open Source Definition (OSD), and preventing abuse of the ideals and ethos inherent to the open source movement. The “open source” label was created at a strategy session held at the start of February 1998 in Mountain View, California. That same month, now almost twenty years ago, the OSI was founded as a general educational and advocacy organization to raise awareness and adoption for the application of free software in an open development process.
    Some of the largest forces in business today — consumer-facing companies like Google and Facebook, business-facing companies like Salesforce and SUSE, companies outside the tech industry such as BMW, Capital One, and Zalando, even first-gen tech corporations like Microsoft and IBM — all increasingly depend on open source software. Governments too, including the European Union, France, India, the United Kingdom, the United States, and many others have discovered the benefits of open source software and development models. Successful collaborative development of software and infrastructure used by these organizations is enabled by the safe space created when they use their IP in new ways... to ensure an environment for co-creation where the four essential freedoms of software are guaranteed.
    As open source adoption has expanded, we have seen changes in the assumptions surrounding licensing, governance and development of open source projects. We will document that evolution and look ahead to see what trends and pressures face the global free and open source software movement as it expands beyond ICT to wireless, distributed devices and beyond.&lt;/p&gt;</description>
    <persons>
    <person id="228">Simon Phipps</person>
    <person id="312">Italo Vignoli</person>
    </persons>
    <links>
    <link href="https://video.fosdem.org/2018/Janson/osi.mp4">Video recording (mp4)</link>
    <link href="https://video.fosdem.org/2018/Janson/osi.webm">Video recording (WebM/VP9)</link>
    <link href="https://speakerdeck.com/webmink/the-third-decade-of-open-source">Slides</link>
    <link href="https://submission.fosdem.org/feedback/6245.php">Submit feedback</link>
    </links>
    </event>
    </room>
    </day>
    </schedule>
"""

    func parse() -> [Talk] {
        let xml = try! XML.parse(self.someshit)
        var t:[Talk] = []
        for room in xml["schedule", "day", "room"] {
            for event in room["event"] {
                let z:Talk = Talk(
                    id: Int(event.attributes["id"]!)!,
                    title: event["title"].text!,
                    subTitle: event["subtitle"].text ?? "",
                    startTime: event["start"].text ?? "",
                    duration: event["duration"].text ?? "",
                    type: event["type"].text ?? "",
                    abstract: event["abstract"].text ?? "",
                    track: event["track"].text ?? "",
                    description: event["description"].text ?? "",
                    people: [""],
                    links: [""]
                )
                t.append(z)
            }
        }
        return t
    }
}
