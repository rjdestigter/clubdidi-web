module Members.Model
    exposing
        ( Members
        , Member
        , Roles
        , Role(..)
        , Model
        , Filters
        , Route(..)
        , blank
        , initial
        )


type Role
    = FrontOfHouse
    | BarTending
    | Security
    | Floating
    | SetUp
    | Tech
    | Maintenance
    | Cleaning
    | WhateverMamaNeeds
    | Other String


type alias Roles =
    List Role


type alias Member =
    { id : String
    , firstName : String
    , lastName : String
    , email : String
    , dateOfBirth : String
    , payed : Bool
    , volunteer : Bool
    , roles : Roles
    }


type alias Members =
    List Member


type alias Filters =
    { firstName : String
    , lastName : String
    , volunteer : Maybe Bool
    , roles : List Role
    }

type Route
  = Index
  | Add
  | Edit Member
  | Delete Member

type alias Model =
    { members : Members
    , operation : Member
    , filters : Filters
    , route : Route
    }


blank : Member
blank =
    Member "" "" "" "" "" False False []


initial : Model
initial =
    { members = []
    , filters = Filters "" "" Nothing []
    , operation = blank
    , route = Index
    }
