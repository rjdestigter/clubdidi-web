module Members.Utils exposing (..)

import Date
import Members.Model exposing (..)

stringToRole : String -> Role
stringToRole role =
    case role of
        "Front of House" ->
            FrontOfHouse

        "Bar Tending" ->
            BarTending

        "Security" ->
            Security

        "Floating" ->
            Floating

        "Set-up" ->
            SetUp

        "Tech" ->
            Tech

        "Maintenance" ->
            Maintenance

        "Cleaning" ->
            Cleaning

        "Whatever Mama needs" ->
            WhateverMamaNeeds

        _ ->
            Other role


roleToString : Role -> String
roleToString role =
    case role of
        FrontOfHouse ->
            "Front Of House"

        BarTending ->
            "Bar Tending"

        Security ->
            "Security"

        Floating ->
            "Floating"

        SetUp ->
            "Set-up"

        Tech ->
            "Tech"

        Maintenance ->
            "Maintenance"

        Cleaning ->
            "Cleaning"

        WhateverMamaNeeds ->
            "Whatever Mama Needs"

        Other other ->
            other
